import socket
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import json
import threading
import math
matplotlib.use('Qt5Agg')

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_address = ('localhost', 10011)
print('connecting to %s port %s' % server_address)
sock.connect(server_address)

vel = {
    "x": 0.0,
    "w": 0.0
}
pos = {
    "x": 50.0,
    "y": 50.0,
    "theta": 0.0
}
x_traj = []
y_traj = []
dt = 0.1


def transformation_matrix(theta):
    return np.array([
        [math.cos(theta), -math.sin(theta), 0],
        [math.sin(theta), math.cos(theta), 0],
        [0, 0, 1]
    ])

def plot_vehicle():
    plt.xlim(0, 100)
    plt.ylim(0, 100)
    global pos, x_traj, y_traj, dt
    p1_i = np.array([0.5, 0, 1]).T
    p2_i = np.array([-0.5, 0.25, 1]).T
    p3_i = np.array([-0.5, -0.25, 1]).T
    # 旋转
    T = transformation_matrix(pos['theta'])
    p1 = np.matmul(T, p1_i)
    p2 = np.matmul(T, p2_i)
    p3 = np.matmul(T, p3_i)
    # 平移
    p1 += [pos['x'], pos['y'], 0]
    p2 += [pos['x'], pos['y'], 0]
    p3 += [pos['x'], pos['y'], 0]

    plt.plot([p1[0], p2[0]], [p1[1], p2[1]], 'k-', color='deepskyblue')
    plt.plot([p2[0], p3[0]], [p2[1], p3[1]], 'k-', color='red')
    plt.plot([p3[0], p1[0]], [p3[1], p1[1]], 'k-')

    pos['x'] += vel['x'] * math.cos(pos['theta']) * dt
    pos['y'] += vel['x'] * math.sin(pos['theta']) * dt
    pos['theta'] += vel['w'] *dt
    plt.pause(0.2) # 没做快捷方式退出的情况下pause时间久一点
    print(pos['x'],pos['y'],pos['theta'])

def receive():
    global vel
    while True:
        data = sock.recv(1024)
        data = data.decode()
        vel = json.loads(data)
        if data:
            print(data)
        else:
            print('no data from server, closing connection')
            sock.close()
            break

# 如果是主模块，则创建新线程
if __name__ == "__main__":
    t = threading.Thread(target=receive)
    t.start()
    while True:
        plot_vehicle()