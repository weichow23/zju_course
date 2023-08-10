# -*- coding: utf-8 -*-
import numpy as np
import math as m


class A_star:
    def __init__(self,obstacles_point, start_point, end_point, planning_minx,planning_miny,planning_maxx,planning_maxy,grid,dist):
        self.closed = []  
        self.unknown = []  
        self.now = 0       
        self.start_point = (int((start_point[0]-planning_minx)/grid),int((start_point[1]-planning_miny)/grid))
        self.end_point = (int((end_point[0]-planning_minx)/grid),int((end_point[1]-planning_miny)/grid))
        self.end_Vertex = self.Vertex(self.end_point, self.end_point, m.inf)
        self.max_iter = 50000
        self.grid = grid
        self.dist = dist
        self.planning_minx = planning_minx
        self.planning_miny = planning_miny
        self.planning_maxx = planning_maxx
        self.planning_maxy = planning_maxy
        self.width = int((planning_maxx - planning_minx)/grid+1)
        self.height = int((planning_maxy - planning_miny)/grid+1)
        self.map = np.empty([self.height, self.width], dtype=float)
        for i in range(self.height):
            for j in range(self.width):
                self.temp=np.hypot(obstacles_point[:,0]-(i*grid+planning_minx),obstacles_point[:,1]-(j*grid+planning_miny))
                self.map[i,j] = min(self.temp)
                if self.map[i,j] > dist:
                    self.map[i,j] = 0
                else:
                    self.map[i,j] = 1

    class Vertex:

        def __init__(self, point, endpoint, g):

            self.point = point      
            self.endpoint = endpoint 
            self.father = None       
            self.g = g                
            self.h =m.hypot((point[0]-endpoint[0]),(point[1]-endpoint[1]))
            self.f = self.g + self.h

        def search_next(self, vertical, horizontal):

            nextpoint =(self.point[0] + horizontal,
                              self.point[1] + vertical)
            if vertical != 0 and horizontal != 0:
                nearVertex = A_star.Vertex(
                    nextpoint, self.endpoint, self.g + 1.414)
            else:   
                nearVertex = A_star.Vertex(
                    nextpoint, self.endpoint, self.g + 1)
            return nearVertex

    def Process(self):

        start_Vertex = self.Vertex(self.start_point, self.end_point, 0)
        self.unknown.append(start_Vertex)
        arrive = 0
        count = 0
        while arrive != 1 and count < self.max_iter:
            self.now = self.min_cost_Vertex() 
            self.closed.append(self.now)   
            arrive = self.explore_next(self.now) 
            count += 1
        best_path_X = []
        best_path_Y = []
        temp_Vertex = self.end_Vertex  
        # while (temp_Vertex.point[0] != self.start_plloint[0] or temp_Vertex.point[1] != self.start_point[1]):
        while (temp_Vertex):
            best_path_X.append(temp_Vertex.point[0])
            best_path_Y.append(temp_Vertex.point[1])
            temp_Vertex = temp_Vertex.father
        best_path_X.reverse()
        best_path_Y.reverse()  
        best_path_X=[float(i)*self.grid+self.planning_minx for i in best_path_X]
        best_path_Y=[float(i)*self.grid+self.planning_miny for i in best_path_Y]
        # print(best_path_X,best_path_Y)
        return best_path_X,best_path_Y

    def min_cost_Vertex(self):
        Vertex_min = self.unknown[0]
        for Vertex_temp in self.unknown:
            if Vertex_temp.f < Vertex_min.f:
                Vertex_min = Vertex_temp
        self.unknown.remove(Vertex_min)
        return Vertex_min

    def is_unknown(self, Vertex):
        for Vertex_temp in self.unknown:
            if Vertex_temp.point == Vertex.point:
                return Vertex_temp
        return 0

    def is_closed(self, Vertex):
        for closeVertex_temp in self.closed:
            if closeVertex_temp.point[0] == Vertex.point[0] and closeVertex_temp.point[1] == Vertex.point[1]:
                return 1
        return 0

    def is_obstacle(self, Vertex):
        if self.map[Vertex.point[0]][Vertex.point[1]] == 1:
            return 1
        return 0

    def explore_next(self, Vertex):
        num = {-1, 0, 1}
        for vertical in num:
            for horizontal in num:
                if vertical == 0 and horizontal == 0:
                    continue
                if Vertex.point[0] + horizontal < 0:
                    continue
                if Vertex.point[0] + horizontal >= self.width:
                    continue
                if Vertex.point[1] + vertical < 0:
                    continue
                if Vertex.point[1] + vertical >= self.height:
                    continue
                Vertex_next = Vertex.search_next(vertical, horizontal)
                if Vertex_next.point[0] == self.end_point[0] and Vertex_next.point[1] == self.end_point[1]:
                    Vertex_next.father = Vertex
                    self.end_Vertex = Vertex_next
                    return 1
                if self.is_closed(Vertex_next):
                    continue
                if self.is_obstacle(Vertex_next):
                    continue
                if self.is_unknown(Vertex_next) == 0:
                    Vertex_next.father = Vertex
                    self.unknown.append(Vertex_next)
                else:
                    Vertex_old = self.is_unknown(Vertex_next)
                    if Vertex_next.f < Vertex_old.f:
                        self.unknown.remove(Vertex_old)
                        Vertex_next.father = Vertex
                        self.unknown.append(Vertex_next)
        return 0
