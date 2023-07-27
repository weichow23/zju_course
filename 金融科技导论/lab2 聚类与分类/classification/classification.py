import numpy as np
from gen_data import gen_data
from plot import plot
from todo import func
from sklearn.metrics import confusion_matrix
import seaborn as sns
import matplotlib.pyplot as plt

no_iter = 1000  # number of iteration
no_train = 80  # number of training data
no_test = 20  # number of testing data
no_data = 100  # number of all data

type_choice = ['linear', 'perceptron', 'svm']
ch = 1

assert (no_train + no_test == no_data)

cumulative_train_err = 0
cumulative_test_err = 0

for i in range(no_iter):
    X, y, w_gt = gen_data(no_data)
    X_train, X_test = X[:, :no_train], X[:, no_train:]
    y_train, y_test = y[:, :no_train], y[:, no_train:]
    w_l = func(X_train, y_train, type=type_choice[ch])

    train_a = np.vstack((np.ones((1, no_train)), X_train))
    test_a = np.vstack((np.ones((1, no_test)), X_test))

    train_pred = np.sign(np.dot(w_l.T, train_a))
    test_pred = np.sign(np.dot(w_l.T, test_a))

    train_err = np.sum(train_pred != y_train.flatten()) / no_train
    test_err = np.sum(test_pred != y_test.flatten()) / no_test

    cumulative_train_err += train_err
    cumulative_test_err += test_err

train_err = cumulative_train_err / no_iter
test_err = cumulative_test_err / no_iter

train_cm = confusion_matrix(y_train.flatten(), train_pred.flatten())
test_cm = confusion_matrix(y_test.flatten(), test_pred.flatten())

plot(X, y, w_gt, w_l, "Classification using " + type_choice[ch])

plt.figure(figsize=(8, 6))
plt.subplot(121)
sns.heatmap(train_cm, annot=True, cmap="Blues", fmt="d", cbar=False)
plt.title("Train Confusion Matrix")

plt.subplot(122)
sns.heatmap(test_cm, annot=True, cmap="Blues", fmt="d", cbar=False)
plt.title("Test Confusion Matrix")

plt.tight_layout()
plt.savefig('pic/Confusion Matrix '+ type_choice[ch])

print("Training error: %s" % train_err)
print("Testing error: %s" % test_err)

