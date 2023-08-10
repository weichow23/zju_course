#!/usr/bin/env python

import rospy
import numpy as np
import math

# structure of the nearest neighbor 
class NeighBor:
    def __init__(self):
        self.distances = []
        self.src_indices = []
        self.tar_indices = []

class ICP:
    def __init__(self):
        # max iterations
        self.max_iter = rospy.get_param('/icp/max_iter',10)
        # distance threshold for filter the matching points
        self.dis_th = rospy.get_param('/icp/dis_th',3)
        # tolerance to stop icp
        self.tolerance = rospy.get_param('/icp/tolerance',0)
        # min match
        self.min_match = rospy.get_param('/icp/min_match',2)
    
    # ICP process function
    # Waiting for Implementation 
    # return: T = (R, t), where T is 2*3, R is 2*2 and t is 2*1    
    def process(self,tar_pc,src_pc):
        A = src_pc
        B = tar_pc
        m = A.shape[1]
        # make points homogeneous, copy them to maintain the originals
        src = np.ones((m+1,A.shape[0]))
        dst = np.ones((m+1,B.shape[0]))
        src[:m,:] = np.copy(A.T)
        dst[:m,:] = np.copy(B.T)
        Transfrom_acc = np.identity(3)
        prev_error = 0.0
        iter_cnt = match_cnt = 0
        #main loop
        for i in range(self.max_iter * 2):
            # print('---iter:', i) #TODO
            if (np.NaN not in src_pc and np.NaN not in tar_pc):
                neigh_ = self.findNearest(src_pc.T, tar_pc.T)
                # src_pc_xy = np.ones((2, src_pc.shape[0]))
                src_pc_xy = np.ones((2, len(src_pc)))
                tar_chorder = np.ones((2, len(tar_pc)))
                for j in range(len(neigh_.src_indices)):
                    src_pc_xy[0:2, j] = src_pc[0:2, neigh_.src_indices[j]]
                    tar_chorder[0:2, j] = tar_pc[0:2, neigh_.tar_indices[j]]                
                Transfrom = self.getTransform(src_pc_xy.T, tar_chorder.T)
                Transfrom_acc = np.dot(Transfrom, Transfrom_acc)
                src_pc = np.dot(Transfrom, src_pc)
                mean_error = np.mean(neigh_.distances)
                if np.abs(prev_error - mean_error) < self.tolerance:
                    break
                prev_error = mean_error
            iter_cnt += 1
        return Transfrom_acc

    # find the nearest points & filter
    # return: neighbors of src and tar
    def findNearest(self,src,tar):
        neigh = NeighBor()
        min = 100.0
        index = 0
        dist_temp = 0.0
        row_src = np.size(src, 0)
        row_tar = np.size(tar, 0)
        for i in range(row_src):
            lst_src = src[i, 0:2].T
            min = 0x3f3f3f3f
            index = 0
            dist_temp = 0
            for j in range(row_tar):
                lst_tar = tar[j, 0:2].T
                dist_temp = np.hypot(lst_tar[0] - lst_src[0], lst_tar[1] - lst_src[1])
                if dist_temp < min:
                    min = dist_temp
                    index = j
    
            if min < self.dis_th:
                neigh.distances.append(min)
                neigh.src_indices.append(i)
                neigh.tar_indices.append(index)
        return neigh

    # Waiting for Implementation 
    # return: T = (R, t), where T is 2*3, R is 2*2 and t is 2*1
    def getTransform(self,src,tar):
        T = np.identity(3)
        num = src.shape[0]
        #归一化
        centroid_src = np.mean(src, axis = 0)
        centroid_tar = np.mean(tar, axis = 0)
        tar_ = tar - centroid_tar
        src_ = src - centroid_src
        H = np.dot(src_.T, tar_)
        U, S, Vt = np.linalg.svd(H)
        R = np.dot(Vt.T, U.T)
        t = centroid_tar - np.dot(R, centroid_src)
        T[:2, :2] = R
        T[:2, 2] = t
        return T

    def calcDist(self,a,b):
        dx = a[0] - b[0]
        dy = a[1] - b[1]
        return math.hypot(dx,dy)
