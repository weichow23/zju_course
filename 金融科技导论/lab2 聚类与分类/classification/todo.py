import numpy as np
from scipy.optimize import minimize

'''
Classification algorithm.

Input:  X: Training sample features, P-by-N
        y: Training sample labels, 1-by-N

Output: w: learned parameters, (P+1)-by-1
'''
# 实现了线性回归，感知机回归，svm回归
def func(X, y, type = "linear"):
    P, N = X.shape
    w = np.zeros((P+1, 1))
    # svm, 使用scipy.optimize.minimize来求解
    if type == "svm":
        func = lambda t: np.dot(t, t)
        cons = ({'type': 'ineq', 'fun': lambda t: np.dot(np.dot(t, np.vstack((np.ones((1, N)), X))), y.T) - 1})
        w = minimize(func, w, constraints=cons).x
    # 感知机回归
    elif type == 'perceptron':
        max_iter = 1000
        alpha = 0.1

        X = np.vstack((np.ones((1, N)), X))
        y = y.reshape(1, -1)

        for _ in range(max_iter):
            misclassified = False
            for i in range(N):
                if np.sign(np.dot(w.T, X[:, i])) != y[:, i]:
                    w += alpha * y[:, i] * X[:, i].reshape(-1, 1)
                    misclassified = True
            if not misclassified:
                break
    # 默认为线性回归， w = (X.T * X)^-1 * X.T .* y
    else:
        A = np.vstack((np.ones((1, N)), X)).T
        w = np.dot(np.dot(np.linalg.inv(np.dot(A.T, A)), A.T), y.T)

    return w