import numpy as np
import matplotlib.pyplot as plt

def plot(X, y, w_gt, w_l, title):
    '''
    Plot data set.

    Input:  X: sample features, P-by-N matrix.
            y: sample labels, 1-by-N row vector.
            w_gt: true target function parameters, (P+1)-by-1 column vector.
            w_l: learnt target function parameters, (P+1)-by-1 column vector.
            title: title of figure.
    '''

    if X.shape[0] != 2:
        print('Here we only support 2-d X data')
        return

    plt.plot(X[0, y.flatten() == 1], X[1, y.flatten() == 1], 'o', markerfacecolor='r', \
                                              markersize=10)

    plt.plot(X[0, y.flatten() == -1], X[1, y.flatten() == -1], 'o', markerfacecolor='g', \
                                                markersize=10)
    
    k, b = -w_gt[1] / w_gt[2], -w_gt[0] / w_gt[2]
    max_x = max(min((1 - b) / k, (-1 - b ) / k), -1)
    min_x = min(max((1 - b) / k, (-1 - b ) / k), 1)
    x = np.arange(min_x, max_x, (max_x - min_x) / 100)
    temp_y = k * x + b
    plt.plot(x, temp_y, color='b', linewidth=2, linestyle='-')
    k, b = -w_l[1] / w_l[2], -w_l[0] / w_l[2]
    max_x = max(min((1 - b) / k, (-1 - b ) / k), -1)
    min_x = min(max((1 - b) / k, (-1 - b ) / k), 1)
    x = np.arange(min_x, max_x, (max_x - min_x) / 100)
    temp_y = k * x + b
    plt.plot(x, temp_y, color='b', linewidth=2, linestyle='--')
    plt.title(title)
    plt.savefig('pic/'+title+'.png')