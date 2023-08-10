import numpy as np
import matplotlib.pyplot as plt
import scipy as sp
import scipy.io as io
import os
import sys

def YALE_split(Yale_file, train_points_per_label=50):
    # 加载Yale文件
    YALE = io.loadmat(Yale_file)
    X = YALE['X']  # 获取特征数据
    Y = YALE['Y']  # 获取标签数据
    X = X.T / 255.0  # 特征数据归一化
    X = X.reshape((2414, 168, 192)).swapaxes(1, 2)  # 重新调整特征数据的形状
    Y = Y.flatten()  # 将标签数据展平
    train_data, train_label, test_data, test_label = [], [], [], []  # 初始化训练和测试数据集
    np.random.seed(0)  # 设置随机种子
    label_count = 0  # 标签计数器
    for label in set(Y):
        label_idx = np.argwhere(Y == label).flatten()  # 获取具有特定标签的索引
        tot_num = len(label_idx)  # 计算具有特定标签的总样本数量
        idx_permute = np.random.permutation(label_idx)  # 随机打乱索引
        # 将数据分为训练集和测试集
        train_data.append(X[idx_permute[:train_points_per_label]])  # 将一部分数据添加到训练集
        train_label.append(np.repeat(label_count, train_points_per_label))  # 将相应标签添加到训练标签集
        test_data.append(X[idx_permute[train_points_per_label:]])  # 将剩余的数据添加到测试集
        test_label.append(np.repeat(label_count, tot_num - train_points_per_label))  # 将相应标签添加到测试标签集
        label_count += 1  # 标签计数器递增
    train_data = np.concatenate(train_data)  # 合并训练数据集
    test_data = np.concatenate(test_data)  # 合并测试数据集
    train_label = np.concatenate(train_label)  # 合并训练标签集
    test_label = np.concatenate(test_label)  # 合并测试标签集
    train_idx_permute = np.random.permutation(len(train_label))  # 随机打乱训练数据的索引
    train_data = np.expand_dims(train_data[train_idx_permute], 3)  # 对训练数据进行维度扩展
    train_label = train_label[train_idx_permute]  # 对训练标签进行相应调整
    test_idx_permute = np.random.permutation(len(test_label))  # 随机打乱测试数据的索引
    test_data = np.expand_dims(test_data[test_idx_permute], 3)  # 对测试数据进行维度扩展
    test_label = test_label[test_idx_permute]  # 对测试标签进行相应调整
    return train_data, train_label, test_data, test_label
