import model
import torch
import torchvision
import torchvision.transforms as transforms
import os

# 默认参数声明
# batch_size = 64
# epochs = 60
# WORKERS = 4   # dataloder线程数
# ROOT = './dataset/'  # 数据集保存路径
# pth_dir = './model_pth/'  # 模型保存路径

classes = ('plane', 'car', 'bird', 'cat',
           'deer', 'dog', 'frog', 'horse', 'ship', 'truck')

img_size = 32  # 输入网络的图片大小



def create_dir_not_exist(path):
    if not os.path.exists(path):
        os.mkdir(path)


def train_loader(ROOT, batch_size, WORKERS):
    transform_train = transforms.Compose([
        transforms.RandomCrop(32, padding=4),
        transforms.Resize([img_size, img_size]),
        transforms.RandomHorizontalFlip(),
        transforms.ToTensor(),
        transforms.Normalize((0.4914, 0.4822, 0.4465), (0.2023, 0.1994, 0.2010)),
    ])

    train_dataset = torchvision.datasets.CIFAR10(root=ROOT, train=True,
                                            download=False, transform=transform_train)
    trainloader = torch.utils.data.DataLoader(train_dataset, batch_size=batch_size,
                                              shuffle=True, num_workers=WORKERS)
    return trainloader

def test_loader(ROOT, batch_size, WORKERS):
    transform_test = transforms.Compose([
        transforms.Resize([img_size, img_size]),
        transforms.ToTensor(),
        transforms.Normalize((0.4914, 0.4822, 0.4465), (0.2023, 0.1994, 0.2010)),
    ])

    testset = torchvision.datasets.CIFAR10(root=ROOT, train=False,
                                           download=False, transform=transform_test)
    testloader = torch.utils.data.DataLoader(testset, batch_size=batch_size,
                                             shuffle=False, num_workers=WORKERS)
    return testloader