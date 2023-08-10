
from numpy import sqrt
import numpy as np
import math

class DWA:
    # heading for the target point
    def heading_cost(self, from_x, from_y, to_x, to_y, robot_info_temp,):
        angleCost = np.arctan2((to_y - from_y),(to_x - from_x)) - robot_info_temp[2]
        now_dist = np.sqrt((to_x - from_x)**2 + (to_y - from_y)**2)
        return 2*np.abs(angleCost)+now_dist
        #+0.095 * np.abs(robot_info[4])
    
    # don't torch the obstacles
    def dist_cost(self,dwaconfig, midpos,robot_info, planning_obs, radius):
        dist = 100000
        for i in range(int(dwaconfig.predict_time / dwaconfig.dt)):
            for obs in planning_obs:
                now_dist = np.sqrt((obs[0] - robot_info[0])**2 + (obs[1] - robot_info[1])**2) - radius
                if now_dist < 0:
                    return 100000
                else:
                    dist = min(dist, now_dist)
            robot_info = self.motion(robot_info, dwaconfig)
        return 1 / dist

    # velocity fasten
    def velocity_cost(self, now_v, max_v):
        delta=(max_v - now_v )
        return delta

    def motion(self, robot_info, dwaconfig):
        # don't care obstacle's moving
        new_robot_info = []
        new_robot_info.append(robot_info[0] + robot_info[3] * dwaconfig.dt * np.cos(robot_info[2] + robot_info[4] * dwaconfig.dt))
        new_robot_info.append(robot_info[1] + robot_info[3] * dwaconfig.dt * np.sin(robot_info[2] + robot_info[4] * dwaconfig.dt))
        new_robot_info.append(robot_info[2] + robot_info[4] * dwaconfig.dt)
        new_robot_info.append(robot_info[3])
        new_robot_info.append(robot_info[4])
        return new_robot_info
    #  robot info : [x, y, theta, vx, vw]
    #  dwaconfig : {robot_radius, obs_radius, dt, max_speed, min_speed, max_accel, v_reso, max_yawrate, max_dyawrate, yawrate_reso, predict_time, to_goal_cost_gain, speed_cost_gain, obstacle_cost_gain, tracking_dist, arrive_dist}
    def plan(self, robot_info, dwaconfig, midpos, planning_obs):
        nvx = 0.0
        nvw = 0.0
        all_u = []
        all_traj = []
        best_traj = []

        # DWA inital
        minV = max(dwaconfig.min_speed, robot_info[3] - dwaconfig.max_accel*dwaconfig.dt)
        maxV = min(dwaconfig.max_speed, robot_info[3] + dwaconfig.max_accel*dwaconfig.dt)
        minW = max(-dwaconfig.max_yawrate, robot_info[4] - dwaconfig.max_dyawrate*dwaconfig.dt)
        maxW = min(dwaconfig.max_yawrate, robot_info[4] + dwaconfig.max_dyawrate*dwaconfig.dt)
        possibleV_num = int((maxV - minV)/dwaconfig.v_reso) + 1
        possibleW_num = int((maxW - minW)/dwaconfig.yawrate_reso) + 1
        possibleV = np.linspace(minV, maxV, possibleV_num)
        possibleW = np.linspace(minW, maxW, possibleW_num)
        if dwaconfig.arrive_dist > np.sqrt((robot_info[0]-midpos[0])**2+(robot_info[1]-midpos[1])**2):
            return [0,0],best_traj,all_traj,all_u
        tot = 100000.0
        tot_info=robot_info
        cost = np.zeros((possibleV_num, possibleW_num))
        for vw in possibleW:
            for vx in possibleV:
                traj = []
                robot_info_temp = [robot_info[0], robot_info[1], robot_info[2], vx, vw]
                robot_info_temp = self.motion(robot_info_temp, dwaconfig)
                # cost
                cost1 = self.heading_cost(robot_info_temp[0], robot_info_temp[1], midpos[0], midpos[1], robot_info_temp)
                cost2 = self.dist_cost(dwaconfig, midpos,robot_info_temp, planning_obs, 0.1)
                cost3 = self.velocity_cost(robot_info_temp[3], dwaconfig.max_speed)
                cost = cost1 * dwaconfig.to_goal_cost_gain + cost2 * dwaconfig.obstacle_cost_gain + cost3 * dwaconfig.speed_cost_gain
                print(vx, vw, cost1, cost2, cost3, cost)
                if(cost < tot):
                    tot = cost
                    nvx = vx
                    nvw = vw
        return [nvx, nvw],best_traj,all_traj,all_u
