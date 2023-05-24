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


classes = ('plane', 'car', 'bird', 'cat',
           'deer', 'dog', 'frog', 'horse', 'ship', 'truck')


def train(model, pth_dir, epochs, ROOT, batch_size, WORKERS):
    trainloader = utils.train_loader(ROOT=ROOT, batch_size=batch_size, WORKERS=WORKERS)
    testloader = utils.test_loader(ROOT=ROOT, batch_size=batch_size, WORKERS=WORKERS)
    trained_epoch = 0  # 已训练的batch数
    writer = SummaryWriter()
    file_list = os.listdir(pth_dir+opt.model_name+"/")  # 判断是否有已存在的模型
    pth_list = []
    for file in file_list:
        if file.endswith('pth') and file.startswith(opt.model_name):
            pth_list.append(file)
    if pth_list:
        pth_list.sort(key=lambda x: int(x[len(opt.model_name) + 7:-4]))
        trained_model = pth_list[-1]
        print("Found trained model: " + trained_model)
        checkpoint = torch.load(pth_dir + opt.model_name+"/" + trained_model)       # 加载模型
        model.load_state_dict(checkpoint['model'])
        optimizer.load_state_dict(checkpoint['optimizer'])
        trained_epoch = checkpoint['epoch']
        print("Load model from epoch " + str(trained_epoch))
        trained_epoch += 1
    print("\nstart training from epoch " + str(trained_epoch))

    if trained_epoch >= epochs:
        print('Finished Training')
        return 0

    for epoch in range(trained_epoch, epochs):  # 开始训练
        start_time = time.time()
        correct = 0
        total = 0
        running_loss = 0.0
        total_loss = 0.0
        for iter, data in enumerate(tqdm(trainloader)):
            # 获取输入
            inputs, labels = data
            inputs, labels = inputs.to(device), labels.to(device)

            # 梯度置0
            optimizer.zero_grad()

            # 正向传播，反向传播，优化
            output = model(inputs)
            _, predicted = torch.max(output.data, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()

            loss = criterion(output, labels)
            loss.backward()
            optimizer.step()
            total_loss += loss.item()
            # 打印状态信息
            running_loss += loss.item()
            if iter % 64 == 63:    # 每64批次打印一次
                print('[%d, %5d] loss: %.3f' %
                      (epoch + 1, iter + 1, running_loss / 64))
                running_loss = 0.0
        end_time = time.time()
        spent_time = end_time - start_time
        acc = correct / total
        total_loss = total_loss / iter
        print('Training: Epoch : %d, Accuracy : %f %%, spent time : %f' % (epoch, 100 * correct / total, spent_time))
        writer.add_scalar("time/train/"+opt.model_name, spent_time, global_step=epoch)
        writer.add_scalar("loss/train/"+opt.model_name, total_loss, global_step=epoch)
        writer.add_scalar("acc/train/"+opt.model_name, acc, global_step=epoch)
        state = {'model': model.state_dict(), 'optimizer': optimizer.state_dict(), 'epoch': epoch}
        pth_name = opt.model_name+"_epoch_"+str(epoch)+".pth"
        # if epoch % 5 == 0 or epoch == epochs-1:
        torch.save(state, pth_dir + opt.model_name + "/" + pth_name)
        if epoch > 0:
            os.remove(pth_dir+opt.model_name+"/"+opt.model_name+"_epoch_"+str(epoch-1)+".pth")  # 删除上一个

    print('Finished Training')
    writer.close()





if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--model_name', type=str, default="resnet50", help='the name of netural networks')
    parser.add_argument('--batch_size', type=int, default=64, help='train batch size')
    parser.add_argument('--epoch_num', type=int, default=200, help='train epochs')
    parser.add_argument('--worker_num', type=int, default=16, help='maximum number of dataloader workers')
    parser.add_argument('--learning_rate', type=float, default=1e-2, help='learning rate')
    parser.add_argument('--optimizer', type=str, default="sgd", help='choice of optimizer')
    parser.add_argument('--momentum', type=float, default=0.9, help='SGD optimizer momentum')
    parser.add_argument('--datasets_path', type=str, default="./dataset/", help='datasets path')
    parser.add_argument('--pth_path', type=str, default="./model_pth/", help='trained model saving and loading path')
    opt = parser.parse_args()

    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    utils.create_dir_not_exist(opt.pth_path)
    utils.create_dir_not_exist(opt.pth_path+opt.model_name+"/")

    model = (model.Net(opt.model_name)).to(device)           # 确定网络模型
    if opt.model_name == 'vit_soat':
        utils.img_size = 224

    criterion = nn.CrossEntropyLoss()                        # 确定损失和优化函数
    if opt.optimizer == "sgd":
        optimizer = optim.SGD(model.parameters(), lr=opt.learning_rate, momentum=opt.momentum)
    if opt.optimizer == "adam":
        optimizer = optim.Adam(model.parameters(), lr=opt.learning_rate)

    train(model, pth_dir=opt.pth_path, epochs=opt.epoch_num, ROOT=opt.datasets_path, batch_size=opt.batch_size,
          WORKERS=opt.worker_num)
