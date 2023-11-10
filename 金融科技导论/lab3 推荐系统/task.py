import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from mpl_toolkits.mplot3d import Axes3D
from scipy.interpolate import griddata

train_rating = pd.read_csv("data/ratings_train_v1.csv") 
test_rating = pd.read_csv("data/ratings_test_v1.csv") 

all_data = pd.concat([train_rating, test_rating])

all_user = np.unique(all_data['userId'])
all_item = np.unique(all_data['movieId'])

num_user = len(all_user)
num_item = len(all_item)

rating_mat = np.zeros([num_user, num_item], dtype=float)

######################### fill in ##########################
# turn the csv into the rating matrix
for i in range(len(train_rating)):
    user = int(train_rating.iloc[i]['userId'])
    item = int(train_rating.iloc[i]['movieId'])
    score = float(train_rating.iloc[i]['rating'])
    user_id = np.where(all_user == user)[0][0]
    item_id = np.where(all_item == item)[0][0]
    rating_mat[user_id][item_id] = float(score)
############################################################
def get_loss(rating_mat, embed_dim, lamda, P, Q):
    '''
    INPUT:
    :param rating_mat: [m, n]
    :param embed_dim: dimension of the embeddings
    :param gamma: learning rate
    :param P: user embedding [m, embed_dim] 
    :param Q: item embedding [n, embed_dim]
    RETURN: the sum of the error.
    '''
    ######################### fill in ##########################
    # get loss during the training on the training datasets
    pred_mat = np.dot(P, Q.T)
    idx = np.where(rating_mat > 0)
    diff = rating_mat[idx] - pred_mat[idx]
    error = np.sum(diff ** 2)
    error += lamda * (np.sum(P[idx[0], :] ** 2) + np.sum(Q[idx[1], :] ** 2))
    error /= rating_mat.shape[0]
    ############################################################
    return error

def matrix_factorization(rating_mat, embed_dim, gamma, lamda, steps):
    '''
    INPUT:
    :param rating_mat: [m, n]
    :param embed_dim: dimension of the embeddings
    :param gamma: learning rate
    :param lamda: balanced hyper parameters
    :param steps: training epoch
    RETURN:
    :param P: user embedding [m, embed_dim] 
    :param Q: item embedding [embed_dim, n]
    :param error_list: list
    '''

    ######################### fill in ##########################
    m, n = rating_mat.shape
    P = np.random.rand(m, embed_dim)
    Q = np.random.rand(embed_dim, n)
    loss = []
    for s in range(steps):
        for i in range(m):
            for j in range(n):
                if rating_mat[i][j] > 0:
                    rij = rating_mat[i][j] - np.dot(P[i,:], Q[:,j])
                    P[i] += gamma * (rij * Q[:,j] - lamda * P[i])
                    Q[:,j] += gamma * (rij * P[i] - lamda * Q[:,j])
        loss.append(get_loss(rating_mat, embed_dim, lamda, P, Q.T))
        print("Training step:  {}  Loss on the training datasets: {:.10f}".format(s, loss[s]))
    ############################################################
    return P, Q, loss



def test(test_rating, P, Q, all_user, all_item):
    '''
    INPUT:
    :param test_rating:
    :param all_user: the all_user lists
    :param all_item: the all_item lists
    :param P: user embedding [m, embed_dim]
    :param Q: item embedding [n, embed_dim]
    RETURN: the mse and rmse on the test samples.
    '''

    ######################### fill in ##########################
    # evaluate the well-trained model on the test datasets
    mse = 0
    rmse = 0
    for i in range(len(test_rating)):
        user = int(test_rating.iloc[i]['userId'])
        item = int(test_rating.iloc[i]['movieId'])
        score = float(test_rating.iloc[i]['rating'])
        user_id = np.where(all_user == user)[0][0]
        item_id = np.where(all_item == item)[0][0]
        prediction = np.dot(P[user_id, :], Q[item_id, :])
        loss = score - prediction
        mse += loss ** 2
        rmse += loss ** 2
    mse /= len(test_rating)
    rmse = np.sqrt(rmse / len(test_rating))
    ############################################################
    return mse, rmse

def non_negative_matrix_factorization(rating_mat, embed_dim, gamma, lamda, steps):
    '''
    INPUT:
    :param rating_mat: [m, n]
    :param embed_dim: dimension of the embeddings
    :param gamma: learning rate
    :param lamda: balanced hyper parameters
    :param steps: training epoch
    RETURN:
    :param P: user embedding [m, embed_dim] 
    :param Q: item embedding [embed_dim, n]
    :param error_list: list
    '''
    
    ######################### fill in ##########################
    m, n = rating_mat.shape
    P = np.random.rand(m, embed_dim)
    Q = np.random.rand(embed_dim, n)
    loss = []
    for s in range(steps):
        for i in range(m):
            for j in range(n):
                if rating_mat[i][j] > 0:
                    rij = rating_mat[i][j] - np.dot(P[i,:], Q[:,j])
                    P[i] = np.maximum(np.zeros(embed_dim), P[i] + gamma * (rij * Q[:,j] - lamda * P[i]))
                    Q[:,j] = np.maximum(np.zeros(embed_dim), Q[:,j] + gamma * (rij * P[i] - lamda * Q[:,j]))
        loss.append(get_loss(rating_mat, embed_dim, lamda, P, Q.T))
        print("Training step:  {}  Loss on the training datasets: {:.10f}".format(s, loss[s]))
    ############################################################
    return P, Q, loss

def draw(error_list, mse, rmse, embed_dim, gamma, lamda):
    plt.plot(range(len(error_list)), error_list)
    plt.xlabel("epoch")
    plt.ylabel("loss")
    plt.title("loss curve")
    plt.text(0.5, 0.85, f"Test MSE: {mse:.4f}", transform=plt.gca().transAxes, fontsize=13, color='red')
    plt.text(0.5, 0.75, f"Test RMSE: {rmse:.4f}", transform=plt.gca().transAxes, fontsize=13, color='red')
    plt.text(0.5, 0.65, f"Test embed_dim: {embed_dim:.3f}", transform=plt.gca().transAxes, fontsize=13)
    plt.text(0.5, 0.55, f"Test γ: {gamma:.3f}", transform=plt.gca().transAxes, fontsize=13)
    plt.text(0.5, 0.45, f"Test lamda: {lamda:.3f}", transform=plt.gca().transAxes, fontsize=13)
    plt.savefig("loss curve.png")

def train(rating_mat, all_user, all_item, embed_dim, gamma, lamda, steps):
    P, Q, loss = matrix_factorization(rating_mat, embed_dim, gamma, lamda, steps)
    mse, rmse = test(test_rating, P, Q.T, all_user, all_item)
    print('Test MSE: ', mse, 'Test RMSE: ', rmse)
    draw(loss, mse, rmse, embed_dim, gamma, lamda)

# 使用seaborn绘制MSE与lamda和gamma的关系三维图
def threeD():
    lamda_values = [0.001, 0.01, 0.1, 1, 10]
    gamma_values = [0.0001, 0.001, 0.01]
    mse_results = []
    for lamda in lamda_values:
        for gamma in gamma_values:
            P, Q, loss = matrix_factorization(rating_mat, embed_dim=64, gamma=gamma, lamda=lamda, steps=20)
            mse, _ = test(test_rating, P, Q.T, all_user, all_item)
            mse_results.append((lamda, gamma, mse))
    mse_df = pd.DataFrame(mse_results, columns=["lamda", "gamma", "mse"])
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.scatter(mse_df['lamda'], mse_df['gamma'], mse_df['mse'], c=mse_df['mse'], cmap='viridis')
    ax.set_xlabel('lamda')
    ax.set_ylabel('gamma')
    ax.set_zlabel('MSE')
    plt.title("MSE vs lamda and gamma")
    plt.savefig("MSE_vs_lamda_gamma.png")

# train(rating_mat, all_user, all_item, embed_dim = 64, gamma = 0.001, lamda = 0.01, steps = 20)
threeD()

