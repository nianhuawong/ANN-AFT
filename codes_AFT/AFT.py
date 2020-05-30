# -*- coding: utf-8 -*-
import math
import numpy
with open(r'./grid/bc.dat', 'r') as grid_file:
    lines = grid_file.readlines()

num_of_boundary_faces = 0
num_of_boundary_nodes = 0
num_of_boundary = 0
num_of_nodes_in_boundary = []

coor = numpy.zeros((32, 2))
filelen = len(lines)
line_num = 0
# iBoundary = 0
while line_num < filelen:
    nodes = int(lines[line_num])
    line_num = line_num + 1
    # iBoundary = iBoundary + 1

    for i in range(nodes):
        coor[num_of_boundary_nodes+i][0] = float(lines[i+line_num].split()[0])
        coor[num_of_boundary_nodes+i][1] = float(lines[i+line_num].split()[1])

    line_num = line_num + nodes
    num_of_boundary_nodes = num_of_boundary_nodes + nodes
    num_of_boundary_faces = num_of_boundary_faces + (nodes - 1)
    num_of_nodes_in_boundary.append(nodes)

num_of_boundary = len(num_of_nodes_in_boundary)

# 建立初始阵面数据, face ID及face的左右点
def area(node01, node02):
    return math.sqrt((node01[0]-node02[0])**2+(node01[1]-node02[1])**2)


node1 = numpy.zeros((num_of_boundary_faces, 2))
node2 = numpy.zeros((num_of_boundary_faces, 2))
nodeIndex = numpy.zeros((num_of_boundary_faces,2))
faceArea = numpy.zeros(num_of_boundary_faces)
iFace = 0
tmp = 0
for i in range(num_of_boundary):
    num_of_face = num_of_nodes_in_boundary[i] - 1
    for j in range(num_of_face):
        node1[iFace+j] = coor[iFace+j+tmp]
        node2[iFace+j] = coor[iFace+j+1+tmp]
        faceArea[iFace+j] = area(node1[iFace+j], node2[iFace+j])
        nodeIndex[iFace+j][0]= iFace+j+tmp
        nodeIndex[iFace+j][1]= iFace+j+tmp+1
    iFace = iFace + num_of_face
    tmp = tmp + 1


left_cell = numpy.zeros(num_of_boundary_faces)
right_cell = numpy.zeros(num_of_boundary_faces)
# 选择初始阵面
frontID = numpy.where(faceArea == min(faceArea))
node_of_front = nodeIndex[frontID[0][0]]

aaa=node_of_front[0]
neighbor_face1 = numpy.where(nodeIndex[:,0]==node_of_front[0])
neighbor_face2 = numpy.where(nodeIndex[:,1]==node_of_front[1])


a=[]