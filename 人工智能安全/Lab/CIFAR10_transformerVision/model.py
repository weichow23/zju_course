import torch.nn as nn
import torch
import torch.nn.functional as F
import torchvision
from vit_pytorch import ViT
from vit_pytorch.distill import DistillableViT, DistillWrapper
from torchsummary import summary

import timm


class Net(nn.Module):
    def __init__(self, network="self_net"):
        super(Net, self).__init__()

        if network in ['self_net']:
            self.network = SelfNet(network)

        if network in ['resnet50']:
            self.network = ResNet(network)

        if network in ['vision_transformer']:
            self.network = VisionTransformer(network)

        if network in ['vit_sota']:
            net = timm.create_model("vit_base_patch16_224", pretrained=True)
            net.head = nn.Linear(net.head.in_features, 10)
            self.network = net

    def forward(self, x):
        return self.network(x)


class SelfNet(nn.Module):
    def __init__(self, network):
        super(SelfNet, self).__init__()
        # 1 input image channel, 6 output channels, 5x5 square convolution
        # kernel
        self.conv1 = nn.Conv2d(3, 6, 5)
        self.conv2 = nn.Conv2d(6, 16, 5)
        # an affine operation: y = Wx + b
        self.fc1 = nn.Linear(16 * 5 * 5, 120)
        self.fc2 = nn.Linear(120, 84)
        self.fc3 = nn.Linear(84, 10)

    def forward(self, x):
        # Max pooling over a (2, 2) window
        x = F.max_pool2d(F.relu(self.conv1(x)), (2, 2))
        # If the size is a square you can only specify a single number
        x = F.max_pool2d(F.relu(self.conv2(x)), 2)
        x = x.view(-1, 16 * 5 * 5)
        x = F.relu(self.fc1(x))
        x = F.relu(self.fc2(x))
        x = self.fc3(x)
        return x


class ResNet(nn.Module):
    def __init__(self, network):
        super(ResNet, self).__init__()
        net = torchvision.models.__dict__[network](pretrained=True)
        fc_features = net.fc.in_features

        net_list = list(net.children())
        self.out = nn.Sequential(*net_list)
        self.feature_extractor = nn.Sequential(*net_list[:-2])
        self.fc_layer = nn.Linear(fc_features, 10)

    def forward(self, x):
        x = self.feature_extractor(x)
        x = F.softmax(self.fc_layer(x.mean([2, 3])), dim=1)
        return x


class VisionTransformer(nn.Module):
    def __init__(self, network):
        super(VisionTransformer, self).__init__()
        self.v = ViT(
            image_size=32,
            patch_size=4,
            num_classes=10,
            dim=512,
            depth=6,
            heads=8,
            mlp_dim=512,
            dropout=0.1,
            emb_dropout=0.1
        )

    def forward(self, x):
        x = self.v(x)
        return x



if __name__ =="__main__":
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    # net = timm.create_model("vit_large_patch16_224", pretrained=True)
    # summary(net.to(device), input_size=(3, 224, 224))