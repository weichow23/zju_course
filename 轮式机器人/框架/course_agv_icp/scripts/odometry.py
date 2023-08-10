#!/usr/bin/env python

import rospy
import tf
from sensor_msgs.msg import LaserScan
from nav_msgs.msg import Odometry
from geometry_msgs.msg import TransformStamped
from icp import ICP
import numpy as np
import math

class MyOdom:
    def __init__(self):
        self.icp = ICP()
        # robot init states
        self.robot_x = rospy.get_param('/icp/robot_x',0)
        self.robot_y = rospy.get_param('/icp/robot_y',0)
        self.robot_theta = rospy.get_param('/icp/robot_theta',0)
        self.sensor_sta = [self.robot_x,self.robot_y,self.robot_theta]

        self.isFirstScan = True

        self.laser_sub = rospy.Subscriber('/scan',LaserScan,self.laserCallback)
        self.odom_pub = rospy.Publisher('icp_odom',Odometry,queue_size=10)
        self.odom_broadcaster = tf.TransformBroadcaster()

        self.src_pc = []
        self.tar_pc = []
        
    def laserCallback(self,msg):
        print('------seq:  ',msg.header.seq)
        if self.isFirstScan:
            self.tar_pc = self.laserToNumpy(msg)
            self.isFirstScan = False
            return
        self.src_pc = self.laserToNumpy(msg)
        transform_acc = self.icp.process(self.tar_pc,self.src_pc)
        self.tar_pc = self.src_pc
        self.publishResult(transform_acc)
        pass

    def publishResult(self,T):
        # print("t: ",T)
        delta_yaw = math.atan2(T[1,0],T[0,0])
        # print("sensor-delta-xyt: ",T[0,2],T[1,2],delta_yaw)
        s = self.sensor_sta
        # print(s)
        self.sensor_sta[0] = s[0] + math.cos(s[2])*T[0,2] - math.sin(s[2])*T[1,2]
        self.sensor_sta[1] = s[1] + math.sin(s[2])*T[0,2] + math.cos(s[2])*T[1,2]
        self.sensor_sta[2] = s[2] + delta_yaw
        # print("sensor-global: ",self.sensor_sta)

        # tf
        s = self.sensor_sta
        q = tf.transformations.quaternion_from_euler(0,0,self.sensor_sta[2])
        self.odom_broadcaster.sendTransform((s[0],s[1],0.001),(q[0],q[1],q[2],q[3]),
                            rospy.Time.now(),"icp_odom","world_base")

        # odom
        odom = Odometry()
        odom.header.stamp = rospy.Time.now()
        odom.header.frame_id = "world_base"

        odom.pose.pose.position.x = s[0]
        odom.pose.pose.position.y = s[1]
        odom.pose.pose.position.z = 0.001
        odom.pose.pose.orientation.x = q[0]
        odom.pose.pose.orientation.y = q[1]
        odom.pose.pose.orientation.z = q[2]
        odom.pose.pose.orientation.w = q[3]

        self.odom_pub.publish(odom)
        pass

    # transform the ros msg to numpy matrix
    def laserToNumpy(self,msg):
        total_num = len(msg.ranges)
        pc = np.ones([3,total_num])
        range_l = np.array(msg.ranges)
        angle_l = np.linspace(msg.angle_min,msg.angle_max,total_num)
        points = np.vstack((np.multiply(np.cos(angle_l),range_l),np.multiply(np.sin(angle_l),np.arange(total_num))))
        pc[0:2,:] = np.vstack((np.multiply(np.cos(angle_l),range_l),np.multiply(np.sin(angle_l),range_l)))
        return pc
    
def main():
    rospy.init_node('icp_node')
    odom = MyOdom()
    rospy.spin()

if __name__ == '__main__':
    main()