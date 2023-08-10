import socket
import sys
from pynput import keyboard
import json
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_address = ('localhost', 10011)
sock.bind(server_address)
sock.listen(1)
# 等待连接
print('not connected')
connection, client_address = sock.accept()
print('connection from', client_address)
# 监听键盘输入并发送到客户端
inputs = [sys.stdin, connection]

vel = {
    "x": 0.0,  # m/s
    "w": 0.0,  # rad/s
}


def on_press(key):
    global connection
    global vel
    try:
        sendif = False
        if key.char == 'w':
            vel['x'] += 0.2
            sendif = 1
        elif key.char == 's':
            vel['x'] -= 0.2
            sendif = 1
        elif key.char == 'a':
            vel['w'] += 0.2
            sendif = 1
        elif key.char == 'd':
            vel['w'] -= 0.2
            sendif = 1
        if(sendif):
            print(json.dumps(vel))
            connection.sendto(json.dumps(vel).encode('utf-8'),server_address)

    except AttributeError:
        print("connection is closed")
        connection.close()
        sock.close()
        return False


def on_release(key):
    #print('{0} released'.format(key))
    if key == keyboard.Key.esc:
        return False

# Collect events until released
with keyboard.Listener(on_press=on_press, on_release=on_release) as listener:
    listener.join()