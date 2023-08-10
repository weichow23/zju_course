import select
import rospy
from geometry_msgs.msg import Twist
import sys, termios, tty


def getKey():
    tty.setraw(sys.stdin.fileno())
    rlist, _, _ = select.select([sys.stdin], [], [], 0.1)
    if rlist:
        key = sys.stdin.read(1)
    else:
        key = ''

    termios.tcsetattr(sys.stdin, termios.TCSADRAIN, settings)
    return key


def turtle_control():
    rospy.init_node('turtle_keyboard_control', anonymous=True)
    pub = rospy.Publisher('/turtle1/cmd_vel', Twist, queue_size=10)

    speed = 0.5
    turn = 1.0

    try:
        while (1):
            key = getKey()
            if key == 'w':
                move_cmd = Twist()
                move_cmd.linear.x = speed
                pub.publish(move_cmd)
            elif key == 's':
                move_cmd = Twist()
                move_cmd.linear.x = -speed
                pub.publish(move_cmd)
            elif key == 'a':
                move_cmd = Twist()
                move_cmd.angular.z = turn
                pub.publish(move_cmd)
            elif key == 'd':
                move_cmd = Twist()
                move_cmd.angular.z = -turn
                pub.publish(move_cmd)
            elif key == ' ':
                move_cmd = Twist()
                pub.publish(move_cmd)
            elif key == 'q' or key == '\x03':
                break

    except rospy.ROSInterruptException:
        pass


if __name__ == '__main__':
    settings = termios.tcgetattr(sys.stdin)
    turtle_control()
