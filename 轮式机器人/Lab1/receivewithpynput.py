# -*- coding: utf-8 -*-
import socket
# 创建一个 socket 对象
s = socket.socket()
# 绑定地址和端口号
host = socket.gethostname()
port = 11245
s.bind((host, port))
# 监听连接请求
s.listen(5)
# 建立客户端连接
c, addr = s.accept()
print('Got connection from', addr)
while True:
    # 接收来自进程A的数据并显示在屏幕上
    data = c.recv(1024)
    print(data.decode(),end="")
# 关闭连接
c.close()
