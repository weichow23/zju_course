from pynput import keyboard
import socket

# 创建一个 socket 对象
s = socket.socket()
# 获取本地主机名
host = socket.gethostname()
# 设置端口号
port = 11245
# 连接到进程B
s.connect((host, port))
def on_press(key):
    try:
        # 将按键转换为字符串并发送到进程B
        s.send(key.char.encode())
    except AttributeError:
        # 处理特殊按键（如空格、回车等）
        if key == keyboard.Key.space:
            s.send(b' ')
        elif key == keyboard.Key.enter:
            s.send(b'\n')
# 监听键盘输入
with keyboard.Listener(on_press=on_press) as listener:
    listener.join()
# 关闭连接
s.close()