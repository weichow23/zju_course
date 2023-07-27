import numpy as np
from scipy.spatial.distance import cdist

'''
K-Means clustering algorithm

Input:  x: data point features, N-by-P maxtirx
        k: the number of clusters

Output:  idx: cluster label, N-by-1 vector
'''

def kmeans(X, k):
    Num, Po = X.shape
    idx = np.zeros(Num)
    cen = X[np.random.choice(Num, k, replace=False)]      # k x P 矩阵，从X中随机选择k个不同的点作为聚类中心
    while True:
        old = idx.copy()
        for i in range(Num):
            idx[i] = np.argmin(cdist(X[i].reshape(1, Po), cen))
        if np.array_equal(idx, old):
            break
        for i in range(k):                                  # 更新聚类中心
            cen[i] = X[idx == i].mean(axis=0)
    return idx

def kmedoids(X, k):
    Num, Po = X.shape
    idx = np.zeros(Num)
    cen = X[np.random.choice(Num, k, replace=False)]  # k x P 矩阵，从X中随机选择k个不同的点作为聚类中心
    while True:
        idx_old = idx.copy()
        for i in range(Num):
            distances = cdist(X[i].reshape(1, Po), cen)  # 计算点X[i]到所有聚类中心的距离
            idx[i] = np.argmin(distances)  # 将点分配给最近的聚类中心的索引
        if np.array_equal(idx, idx_old):
            break
        for i in range(k):
            cluster_points = X[idx == i]  # 获取分配给当前聚类中心的所有点
            medoid_index = np.argmin(np.sum(cdist(cluster_points, cluster_points), axis=1))  # 找到Medoid的索引
            cen[i] = cluster_points[medoid_index]  # 将聚类中心更新为Medoid
    return idx

'''
Spectral clustering algorithm
Input:  W: Adjacency matrix, N-by-N matrix
    k: number of clusters
Output:  idx: data point cluster labels, N-by-1 vector
'''
def spectral(W, k):
    N = W.shape[0]
    idx = np.zeros((N, 1))
    D = np.diag(np.sum(W, axis=1)) # 支持数矩阵和拉普拉斯矩阵
    L = D - W
    eig_value, eig_vector = np.linalg.eig(L) # 得到特征值和特征向量
    index = np.argsort(eig_value) # 对特征值和特征向量进行排序
    X = eig_vector[:, index[:k]]
    X = X.astype(float)  # keep real part, discard imaginary part
    idx = kmeans(X, k)
    return idx

def knn_graph(X, k, threshold):
    '''
    Construct W using KNN graph

    Input:  X:data point features, N-by-P maxtirx.
            k: number of nearest neighbour.
            threshold: distance threshold.

    Output:  W - adjacency matrix, N-by-N matrix.
    '''
    N = X.shape[0]
    W = np.zeros((N, N))
    aj = cdist(X, X, 'euclidean')
    for i in range(N):
        index = np.argsort(aj[i])[:(k+1)]
        W[i, index] = 1
        W[i, i] = 0  # aj[i,i] = 0
    W[aj >= threshold] = 0
    return W
