import scipy.io as sio
from plot import plot
from todo import kmeans, kmedoids
from todo import spectral
from todo import knn_graph

cluster_data = sio.loadmat('cluster_data.mat')
X = cluster_data['X']

# idx = kmeans(X, 2)
# plot(X, idx, "Clustering-kmeans")

# idx = kmedoids(X, 2)
# plot(X, idx, "Clustering-kmedoids")

k=15
threshold=5
W = knn_graph(X, k, threshold)
idx = spectral(W, 2)
plot(X, idx, "Clustering-Spectral k="+str(k)+'threshold='+str(threshold),k , threshold)