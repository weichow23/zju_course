import socket

with open('file.txt', 'r') as f:
    file_content = f.read()

# 创建一个 socket 对象
s = socket.socket()
# 获取本地主机名
host = socket.gethostname()
# 设置端口号
port = 12340

# 连接服务端
s.connect((host, port))
# 发送数据
s.send(file_content.encode())
# 关闭连接
s.close()
