import matplotlib.pyplot as plt

def plot(X, idx, title ,k ,t):
    '''
    Show clustering results

    Input:  X: data point features, n-by-p maxtirx.
            idx: data point cluster labels, n-by-1 vector.
    '''
    plt.figure(figsize=(6, 6))
    if k == 15 and t == 1.45:
        # plt.set_cmap('plasma')
        plt.plot(X[idx == 0, 0], X[idx == 0, 1], 'r.', markersize=5, label='Cluster 1')
        plt.plot(X[idx == 1, 0], X[idx == 1, 1], 'b.', markersize=5, label='Cluster 2')
    elif k>=20:
        plt.scatter(X[idx == 0, 0], X[idx == 0, 1], c='#FBAB7E', s=5, label='Cluster 1')
        plt.scatter(X[idx == 1, 0], X[idx == 1, 1], c='#85FFBD', s=5, label='Cluster 2')
    elif t!=1.45:
        plt.scatter(X[idx == 0, 0], X[idx == 0, 1], c='#F7CE68', s=5, label='Cluster 1')
        plt.scatter(X[idx == 1, 0], X[idx == 1, 1], c='#97D9E1', s=5, label='Cluster 2')
    else:
        # plt.set_cmap('viridis')
        # plt.plot(X[idx == 0, 0], X[idx == 0, 1], '#D9AFD9', markersize=5, label='Cluster 1')
        # plt.plot(X[idx == 1, 0], X[idx == 1, 1], '#97D9E1', markersize=5, label='Cluster 2')
        plt.scatter(X[idx == 0, 0], X[idx == 0, 1], c='#D9AFD9', s=5, label='Cluster 1')
        plt.scatter(X[idx == 1, 0], X[idx == 1, 1], c='#97D9E1', s=5, label='Cluster 2')

    plt.title(title)
    plt.legend(loc='upper right')
    plt.savefig('pic/'+title+'.png')