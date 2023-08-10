### Inversion
### modified by zhouwei in 22/06/2023
import random
import numpy as np
from collections import defaultdict
from tqdm import tqdm

import torch
from torch import nn, optim
import torch.nn.functional as F
import torch.cuda.amp as amp

from robustness.attacker import AttackerModel
from utils import Focus, Jitter, Clip
#from dip_models import skip



DEFAULT_CONFIG = dict(
    # optimizer
    lr=0.1,
    optimizer='adam',               # adam, sgd
    momentum=0.0,                   # only applies to sgd
    adam_betas=[0.9, 0.999],
    max_iters=5000,
    lr_decay='none',                # none, cosine, #multistep
    warmup_iters=0,                 # only applies to cosine schedule
    #renorm_grad=False,
    # regularization strength
    inv_reg=1.,
    bn_reg=0.,
    tv_l1_reg=0.,
    tv_l2_reg=0.,
    l2_reg=0.,
    # regularization options
    jitter=False,
    jitter_lim=2,
    flipping=False,
    noise_step=False,
    noise_scale=0.,
    #group_consistency='none',       # none, lazy, register
    #group_reg=0., 
    restarts=1,
    # others
    print_iter=200,
    use_best=True,
    seed=0,
    #save_intermediate=False
)


def _validate_config(config):
    for key in DEFAULT_CONFIG.keys():
        if config.get(key) is None:
            config[key] = DEFAULT_CONFIG[key]
    for key in config.keys():
        if DEFAULT_CONFIG.get(key) is None:
            raise ValueError(f'Deprecated key in config dict: {key}!')
    return config


# adapted from https://kornia.readthedocs.io/en/latest/_modules/kornia/losses/total_variation.html
def total_variation(img: torch.Tensor) -> torch.Tensor:
    r"""Function that computes Total Variation according to [1].

    Args:
        img: the input image with shape :math:`(N, C, H, W)` or :math:`(C, H, W)`.

    Return:
         a scalar with the computer loss.

    Examples:
        total_variation(torch.ones(3, 4, 4))
        tensor(0.)

    .. note::
       See a working example `here <https://kornia-tutorials.readthedocs.io/en/latest/
       total_variation_denoising.html>`__.

    Reference:
        [1] https://en.wikipedia.org/wiki/Total_variation
    """
    if not isinstance(img, torch.Tensor):
        raise TypeError(f"Input type is not a torch.Tensor. Got {type(img)}")

    if len(img.shape) < 3 or len(img.shape) > 4:
        raise ValueError(f"Expected input tensor to be of ndim 3 or 4, but got {len(img.shape)}.")

    pixel_dif1 = img[..., 1:, :] - img[..., :-1, :]
    pixel_dif2 = img[..., :, 1:] - img[..., :, :-1]

    reduce_axes = (-3, -2, -1)
    
    res11 = pixel_dif1.abs().sum(dim=reduce_axes)
    res12 = pixel_dif2.abs().sum(dim=reduce_axes)
    
    res21 = pixel_dif1.pow(2).sum(dim=reduce_axes)
    res22 = pixel_dif2.pow(2).sum(dim=reduce_axes)

    return res11 + res12, res21 + res22


def np_to_torch(img_np):
    '''Converts image in numpy.array to torch.Tensor.
    From C x W x H [0..1] to  C x W x H [0..1]
    '''
    return torch.from_numpy(img_np)[None, :]


def fill_noise(x, noise_type):
    """Fills tensor `x` with noise of type `noise_type`."""
    if noise_type == 'u':
        x.uniform_()
    elif noise_type == 'n':
        x.normal_() 
    else:
        assert False


# https://github.com/DmitryUlyanov/deep-image-prior/blob/master/utils/common_utils.py
def get_noise(bs, input_depth, method, spatial_size, noise_type='u', var=1./10):
    """Returns a pytorch.Tensor of size (1 x `input_depth` x `spatial_size[0]` x `spatial_size[1]`) 
    initialized in a specific way.
    Args:
        bs: batch size
        input_depth: number of channels in the tensor
        method: `noise` for fillting tensor with noise; `meshgrid` for np.meshgrid
        spatial_size: spatial size of the tensor to initialize
        noise_type: 'u' for uniform; 'n' for normal
        var: a factor, a noise will be multiplicated by. Basically it is standard deviation scaler. 
    """
    if isinstance(spatial_size, int):
        spatial_size = (spatial_size, spatial_size)
    if method == 'noise':
        shape = [bs, input_depth, spatial_size[0], spatial_size[1]]
        net_input = torch.zeros(shape)
        
        fill_noise(net_input, noise_type)
        net_input *= var            
    elif method == 'meshgrid':
        assert input_depth == 2
        X, Y = np.meshgrid(np.arange(0, spatial_size[1])/float(spatial_size[1]-1), np.arange(0, spatial_size[0])/float(spatial_size[0]-1))
        meshgrid = np.concatenate([X[None,:], Y[None,:]])
        net_input = np_to_torch(meshgrid)
    else:
        assert False
        
    return net_input


# https://github.com/NVlabs/DeepInversion/blob/master/deepinversion.py
class DeepInversionFeatureHook():
    '''
    Implementation of the forward hook to track feature statistics and compute a loss on them.
    Will compute mean and variance, and will use l2 as a loss
    '''
    def __init__(self, module):
        self.hook = module.register_forward_hook(self.hook_fn)

    def hook_fn(self, module, input, output):
        # hook co compute deepinversion's feature distribution regularization
        nch = input[0].shape[1]
        mean = input[0].mean([0, 2, 3])
        var = input[0].permute(1, 0, 2, 3).contiguous().view([nch, -1]).var(1, unbiased=False)

        #forcing mean and variance to match between two distributions
        #other ways might work better, i.g. KL divergence
        r_feature = torch.norm(module.running_var.data - var, 2) + torch.norm(
            module.running_mean.data - mean, 2)

        self.r_feature = r_feature
        # must have no output

    def close(self):
        self.hook.remove()


class RepInversion():
    def __init__(self, config=DEFAULT_CONFIG):
        """Initialize with algorithm setup."""
        self.config = _validate_config(config)

    def invert(self, model, targets, bs=None, img_shape=(224, 224)):
        # 翻转函数，用于反演优化图像
        # 假设model是AttackerModel的实例
        assert isinstance(model, AttackerModel) or isinstance(model.module, AttackerModel)
        assert isinstance(targets, torch.Tensor) and len(targets.shape) == 2
        model.eval()
        if bs is None:
            bs = targets.size(0)
        # 初始化
        stats = defaultdict(list)  # 统计信息，默认字典列表
        torch.manual_seed(self.config['seed'])  # 设置随机种子
        random.seed(self.config['seed'])
        x = torch.randn((self.config['restarts'], bs, 3, *img_shape)).cuda() / 2 + 0.5  # 随机生成初始图像
        x = torch.clamp(x, 0, 1)  # 对图像进行范围限制[0, 1]
        # 多次试验并根据损失选择最佳结果
        scores = torch.zeros((self.config['restarts'], bs))  # 损失值
        all_stats = []  # 所有统计信息
        try:
            for trial in tqdm(range(self.config['restarts']), total=self.config['restarts'], leave=False, position=0,
                              desc='Trial'):
                x_trial, score, stats = self._run_default(model, x[trial], targets)  # 运行默认的优化方法得到反演图像

                x[trial] = x_trial
                scores[trial] = score
                all_stats.append(stats)
        except KeyboardInterrupt:
            print('Trial procedure manually interrupted.')
            pass
        x_optimal = torch.zeros((bs, 3, *img_shape)).cuda()  # 最优图像
        final_stats = []  # 最终统计信息
        for bi in range(bs):
            sample_scores = scores[:, bi]
            sample_scores = sample_scores[torch.isfinite(sample_scores)]  # 处理NaN和无穷大的得分值
            optimal_index = torch.argmin(sample_scores)  # 找到最小得分对应的索引
            x_optimal[bi] = x[optimal_index][bi]  # 选择最优图像
            final_stats.append(
                all_stats[optimal_index][bi]  # 选择最优统计信息
            )
        return x_optimal, x, final_stats  # 返回最优图像、所有图像和最终统计信息

    def _run_default(self, model, x_trial, targets):
        stats_keys = ['loss', 'inv_loss', 'bn_loss', 'tv_l1_loss', 'tv_l2_loss', 'l2_loss']
        stats = [{k: [] for k in stats_keys} for _ in range(len(x_trial))]
        
        x_trial = x_trial.clone().detach()
        x_trial.requires_grad = True

        # optimizer
        if self.config['optimizer'] == 'adam':
            optimizer = optim.Adam([x_trial], lr=self.config['lr'], betas=self.config['adam_betas'], eps=1e-8)
        elif self.config['optimizer'] == 'sgd':
            optimizer = optim.SGD([x_trial], lr=self.config['lr'], momentum=self.config['momentum'])
        else:
            raise ValueError
        
        # scheduler
        if self.config['lr_decay'] == 'none':
            scheduler = None
        elif self.config['lr_decay'] == 'cosine':
            def cosine_annealing(step, total_steps, lr_max, lr_min, warmup_steps=0):
                if step < warmup_steps:
                    return lr_min + (lr_max - lr_min) * step / warmup_steps
                else:
                    return lr_min + (lr_max - lr_min) * 0.5 * (
                            1 + np.cos((step - warmup_steps)/ total_steps * np.pi))

            scheduler = optim.lr_scheduler.LambdaLR(
                optimizer,
                lr_lambda=lambda step: cosine_annealing(
                    step,
                    self.config['max_iters'],
                    1,  # since lr_lambda computes multiplicative factor
                    1e-6 / self.config['lr'],
                    self.config['warmup_iters']
                )
            )
        # keep track of the "best" loss and its corresponding input
        best_loss = None
        best_x = None

        # inversion process
        for i in tqdm(range(self.config['max_iters']), total=self.config['max_iters'], leave=False, position=1, desc='Iter'):
            if self.config['jitter']:
                # TODO: how much does this matter?
                # apply random jitter offsets
                off1 = random.randint(-self.config['jitter_lim'], self.config['jitter_lim'])
                off2 = random.randint(-self.config['jitter_lim'], self.config['jitter_lim'])
                x_forward = torch.roll(x_trial, shifts=(off1, off2), dims=(2,3))
            else:
                x_forward = x_trial

            # Flipping
            if self.config['flipping'] and random.random() > 0.5:
                x_forward = torch.flip(x_forward, dims=(3,))

            # forward pass
            logits, rep = model(x_forward, with_latent=True, with_image=False)
            
            # inversion loss
            inv_loss = 1 - F.cosine_similarity(rep, targets, dim=-1)

            # bn regularization
            #bn_loss = sum([mod.r_feature for mod in bn_loss_layers])
            
            # total variation regularization
            tv_l1_loss, tv_l2_loss = total_variation(x_trial)

            # l2 regularization
            l2_loss = torch.norm(x_trial, p=2, dim=(1,2,3))

            # total loss
            loss = self.config['inv_reg'] * inv_loss + \
                self.config['tv_l1_reg'] * tv_l1_loss + self.config['tv_l2_reg'] * tv_l2_loss + \
                self.config['l2_reg'] * l2_loss

            # some recording
            with torch.no_grad():
                best_loss, best_x = replace_best(loss, best_loss, x_trial, best_x)

            for bi in range(loss.size(0)):
                stats[bi]['loss'].append(loss[bi].item())
                stats[bi]['inv_loss'].append(inv_loss[bi].item())
                #stats[bi]['bn_loss'].append(bn_loss.item())
                stats[bi]['tv_l1_loss'].append(tv_l1_loss[bi].item())
                stats[bi]['tv_l2_loss'].append(tv_l2_loss[bi].item())
                stats[bi]['l2_loss'].append(l2_loss[bi].item())

            # update
            loss = loss.mean()
            optimizer.zero_grad()
            loss.backward()

            if self.config['noise_step']:
                grad_noise = self.config['noise_scale'] * torch.randn_like(x_trial.grad)
                x_trial.grad.data += grad_noise 

            #gradients.append(x_trial.grad.data.cpu())

            optimizer.step()
            if scheduler is not None:
                scheduler.step()

            # respect image bound
            x_trial.data.clamp_(0., 1.)
            
            if (i+1) % self.config['print_iter'] == 0:
                tqdm.write(
                    f"It [{i+1:>5d}] | LR: {scheduler.get_last_lr()[0] if scheduler is not None else self.config['lr']:.4f}    Loss: {loss.item():3.4f}    "
                    f"Inversion loss: {inv_loss.mean().item():3.4f}    "    #BN loss: {bn_loss.item():3.4f}    "
                    f"TV L1 loss: {tv_l1_loss.mean().item():3.4f}    TV L2 loss: {tv_l2_loss.mean().item():3.4f}    L2 loss: {l2_loss.mean().item():3.4f}"
                )

                #if self.config['save_intermediate']:
                #    intermediate_x.append(x_trial.clone().detach())

        # evaluation for the last iteration
        with torch.no_grad():
            logits, rep = model(x_trial, with_latent=True, with_image=False)

            # inversion loss
            inv_loss = 1 - F.cosine_similarity(rep, targets, dim=-1)

            # bn regularization
            #bn_loss = sum([mod.r_feature for mod in bn_loss_layers])
            
            # total variation regularization
            tv_l1_loss, tv_l2_loss = total_variation(x_trial)

            # l2 regularization
            l2_loss = torch.norm(x_trial, p=2, dim=(1,2,3))

            # total loss
            loss = self.config['inv_reg'] * inv_loss + \
                self.config['tv_l1_reg'] * tv_l1_loss + self.config['tv_l2_reg'] * tv_l2_loss + \
                self.config['l2_reg'] * l2_loss

            # some recording
            best_loss, best_x = replace_best(loss, best_loss, x_trial, best_x)

        if self.config['use_best']:
            return best_x, best_loss, stats#, gradients
        else:
            return x_trial, loss, stats#, gradients

# a function that updates the best loss and best input
def replace_best(loss, bloss, x, bx):
    if bloss is None:
        bx = x.clone().detach()
        bloss = loss.clone().detach()
    else:
        replace = bloss > loss
        bx[replace] = x[replace].clone().detach()
        bloss[replace] = loss[replace].clone().detach()

    return bloss, bx