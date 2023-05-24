import torch
import torchvision
import torchvision.transforms as transforms
import model
import torch.optim as optim
import torch.nn as nn
from torch.utils.tensorboard import SummaryWriter
import os
import time
import argparse
import utils
from tqdm import tqdm


def test(model, pth_dir, ROOT, batch_size, WORKERS):
    testloader = utils.test_loader(ROOT=ROOT, batch_size=batch_size, WORKERS=WORKERS)
    trained_epoch = 0
    file_list = os.listdir(pth_dir+opt.model_name+"/")  # 判断是否有已存在的模型
    pth_list = []
    for file in file_list:
        if file.endswith('pth') and file.startswith(opt.model_name):
            pth_list.append(file)
    if pth_list:
        pth_list.sort(key=lambda x: int(x[len(opt.model_name) + 7:-4]))
        trained_model = pth_list[-1]
        print("Found trained model: " + trained_model)
        checkpoint = torch.load(pth_dir+opt.model_name+"/" + trained_model)
        model.load_state_dict(checkpoint['model'])
        # optimizer.load_state_dict(checkpoint['optimizer'])
        trained_epoch = checkpoint['epoch']
        print("\nStart testing")
    else:
        print("No trained model!")
        return 0

    for epoch in range(len(pth_list)-1, -1, -1):
        print(epoch)
        checkpoint = torch.load(pth_dir +opt.model_name+"/"+pth_list[epoch])
        model.load_state_dict(checkpoint['model'])
        print("Load model from epoch: " + str(5 * epoch - 1))
        start_time = time.time()
        correct = 0
        total = 0
        total_loss = 0.0

        for iter, data in enumerate(tqdm(testloader)):
            # 获取输入
            inputs, labels = data
            inputs, labels = inputs.to(device), labels.to(device)

            outputs = model(inputs)
            loss = criterion(outputs, labels)
            _, predicted = torch.max(outputs, 1)

            total += labels.size(0)
            correct += (predicted == labels).sum().item()
            total_loss += loss.item()

        end_time = time.time()
        spent_time = end_time - start_time
        acc = correct / total
        total_loss /= iter
        print('Epoch: %d, loss: %f, Accuracy : %f %%, spent time : %f' % (epoch, total_loss, 100 * correct / total, spent_time))
    print('Finished Testing')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--model_name', type=str, default="vit_soat", help='the name of netural networks')
    parser.add_argument('--batch_size', type=int, default=16, help='train batch size')
    parser.add_argument('--worker_num', type=int, default=8, help='maximum number of dataloader workers')
    parser.add_argument('--datasets_path', type=str, default="./dataset/", help='datasets path')
    parser.add_argument('--pth_path', type=str, default="./model_pth/", help='trained model saving and loading path')
    opt = parser.parse_args()

    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

    model = (model.Net(opt.model_name)).to(device)  # 确定网络模型
    criterion = nn.CrossEntropyLoss()  # 确定损失函数

    test(model, pth_dir=opt.pth_path, ROOT=opt.datasets_path, batch_size=opt.batch_size,
         WORKERS=opt.worker_num)
