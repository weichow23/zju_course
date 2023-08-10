# 进程 B
import socket

# 创建一个 socket 对象
s = socket.socket()
# 获取本地主机名
host = socket.gethostname()
# 设置端口号
port = 12340

# 绑定端口号和主机名
s.bind((host, port))
# 等待客户端连接，最多同时连接 5 个客户端。
s.listen(5)

while True:
    # 建立客户端连接。
    c, addr = s.accept()
    print('Got connection from', addr)
    # 接收数据并解码。
    data = c.recv(1024).decode()
    print(data)
    with open('received_file.txt', 'w') as f:            ####如果要进行修改，可以增加一个函数，该函数接受一个参数 data，表示需要修改的数据。您可以在该函数中添加自己的代码来实现对数据的修改。
        f.write(data)
    # 关闭连接。
    c.close()
