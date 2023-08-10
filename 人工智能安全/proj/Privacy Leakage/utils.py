# modified by zhouwei in 22/06/2023
# Utility functions for the experiments in the papers
import os, dill
import numpy as np

import torch
import torch.nn as nn
import torch.nn.functional as F
from torch.utils.data import DataLoader, Subset

from torchvision import transforms
from torchvision import models
from torchvision.datasets import ImageFolder

import robustness
from robustness import model_utils, datasets, train, defaults
from robustness.datasets import ImageNet
from robustness.attacker import AttackerModel


# adapted from https://github.com/MadryLab/robustness/blob/79d371fd799885ea5fe5553c2b749f41de1a2c4e/robustness/model_utils.py
def make_and_restore_model(*_, arch, dataset, resume_path=None,
         parallel=False):
    """
    Makes a model and (optionally) restores it from a checkpoint.
    Args:
        arch (str|nn.Module): Model architecture identifier or otherwise a
            torch.nn.Module instance with the classifier
        dataset (Dataset class [see datasets.py])
        resume_path (str): optional path to checkpoint saved with the 
            robustness library (ignored if ``arch`` is not a string)
        not a string
        parallel (bool): if True, wrap the model in a DataParallel 
            (defaults to False)
    Returns: 
        A tuple consisting of the model (possibly loaded with checkpoint), and the checkpoint itself
    """
    assert isinstance(arch, str)

    classifier_model = dataset.get_model(arch, pretrained=False)

    model = AttackerModel(classifier_model, dataset)

    # optionally resume from a checkpoint
    checkpoint = None
    if resume_path and os.path.isfile(resume_path):
        print("=> loading checkpoint '{}'".format(resume_path))
        checkpoint = torch.load(resume_path, pickle_module=dill)
        
        # Makes us able to load models saved with legacy versions
        state_dict_path = 'model'
        if not ('model' in checkpoint):
            state_dict_path = 'state_dict'

        sd = checkpoint[state_dict_path]
        new_sd = {}
        for k, v in sd.items():
            new_k = k[len('module.'):]
            if 'attacker' not in new_k:
                new_k = new_k.replace('model.model', 'model')
            else:
                new_k = new_k.replace('.model.model', '.model')
            new_sd[new_k] = v

        model.load_state_dict(new_sd)
        print("=> loaded checkpoint '{}' (epoch {})".format(resume_path, checkpoint['epoch']))
    elif resume_path:
        error_msg = "=> no checkpoint found at '{}'".format(resume_path)
        raise ValueError(error_msg)

    if parallel:
        model = torch.nn.DataParallel(model)
    model = model.cuda()

    return model, checkpoint


def get_model(arch='resnet18', eps=0, checkpoint_dir="./pretrained-models", inet_dir="/home/public/ImageNet"):
    if eps.is_integer():
        eps = int(eps)

    imagenet_ds = ImageNet(inet_dir)
    net , _ = make_and_restore_model(
        arch=arch, dataset=imagenet_ds, 
        resume_path=os.path.join(checkpoint_dir, f"{arch}_l2_eps{eps}.ckpt"), parallel=torch.cuda.device_count()>1
    )
    net.eval()
    return net


def get_inet_label_index_pair(inet_dir="/home/public/ImageNet", split="val"):
    dset = ImageFolder(os.path.join(inet_dir, split))
    label_index_pair = {i: [] for i in range(1000)}

    for i, s in enumerate(dset.samples):
        label_index_pair[s[1]].append(i)

    return label_index_pair


def get_batch_index(anchor_label, anchor_index, label_index_pair, batch_size, num_batches):
    rng = np.random.RandomState(anchor_label)
    label_list = list(set(range(1000)) - set([anchor_label]))

    batches = [[] for _ in range(num_batches)]
    anchor_position = []
    for i in range(num_batches):
        batches[i].append(anchor_index)
        labels = rng.choice(label_list, batch_size-1, replace=False)

        for l in labels:
            batches[i].append(rng.choice(label_index_pair[l]))
        
        order = np.argsort([anchor_label]+list(labels))
        batches[i] = list(np.array(batches[i])[order])
        assert len(batches[i]) == batch_size

        anchor_position.append(batches[i].index(anchor_index))
    
    return batches, anchor_position


def get_batch_data(batch_index, inet_dir="/home/public/ImageNet", split="val"):
    transform = transforms.Compose([
            transforms.Resize(256),
            transforms.CenterCrop(224),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
        ])

    dset = Subset(
        ImageFolder(os.path.join(inet_dir, split), transform),
        batch_index
    )
    dataloader = DataLoader(dset, batch_size=len(batch_index), shuffle=False, num_workers=4)
    x, y = next(iter(dataloader))
    return x, y


def get_batch_fc_gradients_and_reps(batch_data, net, eps=0):
    x, y = batch_data
    x, y = x.cuda(), y.cuda()

    attack_kwargs = {
        'constraint': '2', # L-2 PGD
        'eps': eps, # Epsilon constraint (L-2 norm)
        'step_size': eps * 2/3, # Learning rate for PGD
        'iterations': 3, # Number of PGD steps
        'targeted': False, # Untargeted attack
        'custom_loss': None # Use default cross-entropy loss
    }
    make_adv = eps > 0
    (logits, reps), adv_imgs = net(x, y, make_adv, with_image=True, with_latent=True, **attack_kwargs)
    loss = F.cross_entropy(logits, y.cuda())

    try:
        m = net.model
    except AttributeError:
        m = net.module.model

    m.zero_grad()
    loss.backward()

    if isinstance(m, robustness.imagenet_models.resnet.ResNet):
        fc_grad = m.fc.weight.grad.data
    elif isinstance(m, robustness.imagenet_models.densenet.DenseNet):
        fc_grad = m.classifier.weight.grad.data
    elif isinstance(m, robustness.imagenet_models.vgg.VGG):
        fc_grad = m.classifier[-1].weight.grad.data
    else:
        raise NotImplementedError
    
    return fc_grad, reps, adv_imgs


def recov_reps_from_gradients(batch_fc_grads, batch_size):
    batch_labels = torch.min(batch_fc_grads, dim=-1)[0].argsort()[:batch_size]
    batch_labels = torch.sort(batch_labels)[0]  # for convenience of measuring the accuracy
    recovered_reps = batch_fc_grads[batch_labels]
    return recovered_reps



#### inversion utils
def new_init(size: int, batch_size: int = 1, last: torch.nn = None, padding: int = -1) -> torch.nn:
    output = torch.rand(size=(batch_size, 3, size, size)).cuda()
    if last is not None:
        big_size = size if padding == -1 else size - padding
        up = torch.nn.Upsample(size=(big_size, big_size), mode='bilinear', align_corners=False).cuda()
        scaled = up(last)
        cx = (output.size(-1) - big_size) // 2
        output[:, :, cx:cx + big_size, cx:cx + big_size] = scaled
    output = output.detach().clone()
    output.requires_grad_()
    return output


class Focus(nn.Module):
    def __init__(self, size: int, std: float):
        super().__init__()
        self.size = size
        self.std = std

    def forward(self, img: torch.tensor) -> torch.tensor:
        pert = (torch.rand(2) * 2 - 1) * self.std
        w, h = img.shape[-2:]
        x = (pert[0] + w // 2 - self.size // 2).long().clamp(min=0, max=w - self.size)
        y = (pert[1] + h // 2 - self.size // 2).long().clamp(min=0, max=h - self.size)
        return img[:, :, x:x + self.size, y:y + self.size]


class Jitter(nn.Module):
    def __init__(self, lim: int = 32):
        super().__init__()
        self.lim = lim

    def forward(self, x: torch.tensor) -> torch.tensor:
        off1 = random.randint(-self.lim, self.lim)
        off2 = random.randint(-self.lim, self.lim)
        return torch.roll(x, shifts=(off1, off2), dims=(2, 3))


class Clip(nn.Module):
    @torch.no_grad()
    def forward(self, x: torch.tensor) -> torch.tensor:
        return x.clamp(min=0, max=1)

if __name__ == "__main__":
    net = get_model('resnet', eps=3)
    print(isinstance(net.model, models.ResNet))
    label_2_index = get_inet_label_index_pair()

    anchor_label = 0
    anchor_index = label_2_index[anchor_label][0]
    batches = get_batch_index(anchor_label, anchor_index, label_2_index, batch_size=5, num_batches=3)