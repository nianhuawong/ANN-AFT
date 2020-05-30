# -*- coding: utf-8 -*-
from __future__ import division
import matplotlib.pyplot as plt
import tensorflow as tf
import math
from codes import nngen_backward_air
from codes import nngen_forward_step
from codes import tools
import numpy as np
# import os
# import random
# import pandas as pd

plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文标签
plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号

TEST_INTERVAL_SECS = 1
BATCH_SIZE = 1
# plt.figure(figsize=(9, 9))

with open(r'../grid/J10/20191121_J10_2.cas', 'r') as data_file:
    lines = data_file.readlines()

# 寻找含有"(13"，这是从line中搜索是一个字符字符所在的行#########
face_ln = []
nn = 0
for line1 in lines:  # 把lines中的每一行提出来，放在line1中
    nn = nn + 1  # 记录行数
    zi = "(13"  # 记录行数需要查找的字符串
    elements = line1.split()  # 把每一行打散
    if zi in elements:  # 打散的字符串中查找是否有需要的字符串
        face_ln.append(nn)  # 如果有把，其相应的行数记录下来
print(face_ln)

###################################################
filelen = len(lines)
K = 1
M = 1
Dimension = lines[4 - K].split()[3][:-2]  # 去掉最后的分号和括号
Dimension = int(Dimension)

# get the string of first ten row 第六个空格后的数据 ,but cancel the last 2 character,at last string turn into int
Number_of_Faces = int(lines[10 - K].split()[6][:-2])
Number_of_Nodes = int(lines[7 - K].split()[5][:-2])

# 取第八行第四个空格后的字符串，取出最后两位，然后强制转化为int
Number_of_Boundary_Faces = lines[11 - K].split()[5]
Number_of_Boundary_Faces = int(Number_of_Boundary_Faces[:-2])

Number_of_Interior_Faces = lines[12 - K].split()[5]
Number_of_Interior_Faces = int(Number_of_Interior_Faces[:-2])

Number_of_Cells = lines[15 - K].split()[6]
Number_of_Cells = int(Number_of_Cells[:-2])

Node_x = []  # 点的x坐标
Node_y = []
Node_x_new = []
Node_y_new = []

Face_Node_Number_new = []
Face_Node_Index_new = []
Left_Cell_Index_new = []
Right_Cell_Index_new = []
style_new_node = 8  # 新生成点相交性判断以后的模式，有可能直接生成，有可能也是和左右直接相连

p2p = []
delay = 1
Face_Node_Number = []
Face_Node_Index = []

Left_Cell_Index = []
Right_Cell_Index = []

Cell_Node_Number = []
Cell_Node_Index = []

temp_Cell = []
temp_node_face = []
count = 0
columns = 4  # lie
Node_Face = []
Cun_nearbynode_nearbynode = []
Cun_nearbynode_nearbynode_1 = []
train_data_output = []
traindata_out = []

node_to_face = []
node_num = 0
Node_x = []
Node_y = []  # 为了防止后面调用出错，将原始点数据信息清空
# Node_Face=[]
m1 = []
n1 = []

# ======================Node_x,Node_y====================================
for i in range(Number_of_Nodes):  # 读取文件第22行开始的25个点的数据
    data = lines[i + 21].split()[0]  # 读取文件第22行的第0个空格后数据
    Node_x.append(float(data))  # 将data字符串形式转化为浮点型,点从x【0】开始
    data1 = lines[i + 21].split()[1]  # 读取文件第22行的空格第一个数据
    Node_y.append(float(data1))

# ==========Face_Node_Number  Face_Node_Index  Left_Cell_Index  Right_Cell_Index=================
for i in range(Number_of_Boundary_Faces):  # 16 boundary Face
    Face_Node_Number.append(2)

    data2 = lines[i + face_ln[2]].split()[0]  # face_ln[2]表示（13字符串出现第三次所在的行
    Face_Node_Index.append(int(data2, 16))

    data3 = lines[i + face_ln[2]].split()[1]  # 读取
    Face_Node_Index.append(int(data3, 16))

    data4 = lines[i + face_ln[2]].split()[2]  # 读取
    Left_Cell_Index.append(int(data4, 16))

    data5 = lines[i + face_ln[2]].split()[3]  # 读取
    Right_Cell_Index.append(int(data5, 16))

for i in range(Number_of_Interior_Faces):  # 16 boundary Face
    Face_Node_Number.append(2)

    data2 = lines[i + face_ln[1]].split()[0]  # face_ln[1]表示（13字符串出现第2次所在的行
    Face_Node_Index.append(int(data2, 16))

    data3 = lines[i + face_ln[1]].split()[1]  # 读取
    Face_Node_Index.append(int(data3, 16))

    data4 = lines[i + face_ln[1]].split()[2]  # 读取
    Left_Cell_Index.append(int(data4, 16))

    data5 = lines[i + face_ln[1]].split()[3]  # 读取
    Right_Cell_Index.append(int(data5, 16))

# ===================由已知数据提取边界和相关点,构成阵面推进的数据结构===================

for i in range(Number_of_Boundary_Faces):  # 60 boundary Face

    Face_Node_Index_new.append(Face_Node_Index[2 * i])
    Face_Node_Index_new.append(Face_Node_Index[2 * i + 1])
    Left_Cell_Index_new.append(-1)
    Right_Cell_Index_new.append(0)

for i in range(Number_of_Boundary_Faces):  # 60 个点的数量

    Node_x_new.append(Node_x[i])
    Node_y_new.append(Node_y[i])

aaa = 0
# dispaly1()
ccc = 0

node1_new_node_x = []
node1_new_node_y = []
new_node_node2_x = []
new_node_node2_y = []
New_node_nearby = []  # 清空存放相邻点的二维list
New_face_nearby = []

# plt.figure(figsize=(100, 100))  # 固定输入照片的大小，900*900


# ============================
def step(node_x, node_y):  # 求实际步长的
    temp1 = []
    num_boundary = len(boundary_stank)
    out_boundary = boundary_stank[0][4]  # 外部边等长，找0-49都可以
    for i in range(59, num_boundary, 1):  # 构建每个阵面的步长分布，按指数函数来进行,第49条外部face后才是内部face

        inside_boundary = boundary_stank[i][4]  # 内部根据实际的来，因为内部不均匀
        mid_x = (Node_x_new[boundary_stank[i][0] - 1] + Node_x_new[boundary_stank[i][1] - 1]) / 2  # 内部各个face的中心点
        mid_y = (Node_y_new[boundary_stank[i][0] - 1] + Node_y_new[boundary_stank[i][1] - 1]) / 2
        len_aft2aft = math.sqrt(((node_x - mid_x) ** 2) + ((node_y - mid_y) ** 2))
        # 严格来将 这里因该是每个内face中心到圆的距离，如果圆足够大，则不影响，我们这里影响大，因为外圆不够大，每个face到外圆距离差别大
        # m=math.pow(out_boundary/inside_boundary,1) #0.1表示0.1涨到外部边那么长

        # y=inside_boundary*math.pow(m,len_aft2aft)
        y = inside_boundary + len_aft2aft * (out_boundary - inside_boundary) / 12
        temp1.append(y)
    temp2 = min(temp1)
    return temp2


def mid_advance(node1, node2):
    node1_x = Node_x_new[node1 - 1]
    node1_y = Node_y_new[node1 - 1]
    node2_x = Node_x_new[node2 - 1]
    node2_y = Node_y_new[node2 - 1]


def node2_nearby_adv(node, face_num_temp, ref_node):  # 在阵面中寻找第2个点的临点，以及阵面的编号
    rr = []
    k = 0
    num = 0
    temp_point = 0
    max_jiaodu = 360
    ref_node_x = ref_node[0]
    ref_node_y = ref_node[1]
    for i in range(len(AFT_stack)):
        if node == AFT_stack[i][0]:
            rr.append([])
            # rr.append(Right_Cell_Index_new[(AFT_stack[i][5])-1]) # 防止出现一个点出现左右两边都有空的计算域，也算是分开计算域，就是不要选择三角形自己的边
            # tt.append(Right_Cell_Index_new[AFT_stack[0][5]-1]) #
            node_ref_len = math.sqrt(((Node_x_new[AFT_stack[i][1] - 1] - ref_node_x) ** 2) + (
                    (Node_y_new[AFT_stack[i][1] - 1] - ref_node_y) ** 2))
            rr[num].append(AFT_stack[i][1])
            rr[num].append(AFT_stack[i][5])
            rr[num].append(node_ref_len)  # 改变两个点的临点的临点有多个的情况，在某个点直接连接了三个阵面及以上的情况（因为空心存在）
            num = num + 1
    rr = sorted(rr, key=lambda fff: fff[2])  # 按照第3个元素重新排序，让最短的阵面在最上方
    if len(rr) >= 2:
        # display()  #显示边界
        # node_num_display(Node_x_new, Node_y_new)
        # plt.axis("equal")
        # plt.show()

        point1 = Face_Node_Index_new[2 * (face_num_temp - 1)]
        point2 = Face_Node_Index_new[2 * (face_num_temp - 1) + 1]
        if node != point2:
            temp_point = point1
            point1 = point2
            point2 = temp_point
        for i in range(len(rr)):

            a = [Node_x_new[point1 - 1], Node_y_new[point1 - 1]]
            b = [Node_x_new[point2 - 1], Node_y_new[point2 - 1]]
            c = [Node_x_new[rr[i][0] - 1], Node_y_new[rr[i][0] - 1]]

            x = [a[0] - b[0], a[1] - b[1]]
            y = [c[0] - b[0], c[1] - b[1]]
            # 两个向量
            jiaodu = tools.getangle(x[0], x[1], y[0], y[1])
            # https://blog.csdn.net/hy3316597/article/details/52732963  reference file
            if jiaodu < max_jiaodu:
                max_jiaodu = jiaodu
                k = i

        # 找新点附近的阵面，后面判断相交性；将新点的临近阵元的编号号存在New_face_nearby这个list里面，按新点与临近阵元中心

    a = rr[k][0]
    b = rr[k][1]

    return [a, b]


def len_node2node(node1, node2):
    node1_x = Node_x_new[node1 - 1]
    node1_y = Node_y_new[node1 - 1]
    node2_x = Node_x_new[node2 - 1]
    node2_y = Node_y_new[node2 - 1]
    node12_len = math.sqrt(((node2_x - node1_x) ** 2) + ((node2_y - node1_y) ** 2))
    node12_len = round(node12_len, 3)
    return node12_len


def node1_nearby_adv(node, face_num_temp, ref_node):  # 在阵面中寻找第一个点的临点，以及阵面的编号
    rr = []
    num = 0
    ref_node_x = ref_node[0]
    ref_node_y = ref_node[1]

    for i in range(len(AFT_stack)):
        if node == AFT_stack[i][1]:
            rr.append([])
            # rr.append(Right_Cell_Index_new[(AFT_stack[i][5])-1]) # 防止出现一个点出现左右两边都有空的计算域，也算是分开计算域，就是不要选择三角形自己的边
            # tt.append(Right_Cell_Index_new[AFT_stack[0][5]-1]) #
            node_ref_len = math.sqrt(((Node_x_new[AFT_stack[i][0] - 1] - ref_node_x) ** 2) + (
                    (Node_y_new[AFT_stack[i][0] - 1] - ref_node_y) ** 2))
            rr[num].append(AFT_stack[i][0])
            rr[num].append(AFT_stack[i][5])
            rr[num].append(node_ref_len)  # 改变两个点的临点的临点有多个的情况，在某个点直接连接了三个阵面及以上的情况（因为空心存在）
            num = num + 1
    rr = sorted(rr, key=lambda fff: fff[2])  # 按照第3个元素重新排序，让最短的阵面在最上方
    a = rr[0][0]
    b = rr[0][1]
    return [a, b]


def Node_zuobiao(number):
    zuobiao = []
    zuobiao.append(Node_x_new[2 * number])
    zuobiao.append(Node_y_new[2 * number + 1])
    return zuobiao


def dispaly1():
    ########################以下显示边界点信息####################################
    for i in range(0, Number_of_Boundary_Faces):  # 16 boundary Face 只显示年华画的内部边界
        jkl = Face_Node_Index[2 * i]  # 存的一条边起点序号
        hhj = Face_Node_Index[2 * i + 1]  # 存的一条边终点序号
        gx = [Node_x[Face_Node_Index[2 * i] - 1], Node_x[Face_Node_Index[2 * i + 1] - 1]]  # 存的理论点号与实际存的点号相差1
        gy = [Node_y[Face_Node_Index[2 * i] - 1], Node_y[Face_Node_Index[2 * i + 1] - 1]]  # 存的理论点号与实际存的点号相差1

        plt.plot(gx, gy, 'g-s', color='g', markerfacecolor='g', marker='o')
    #########################以下显示内部边信息##################################
    for i in range(Number_of_Interior_Faces):  # 16 boundary Face
        # jkl = Face_Node_Index[2 * (i + Number_of_Boundary_Faces)]  # 存的一条边起点序号
        # hhj = Face_Node_Index[2 * (i + Number_of_Boundary_Faces) + 1]  # 存的一条边终点序号
        gix = [Node_x[Face_Node_Index[2 * (i + Number_of_Boundary_Faces)] - 1],
               Node_x[Face_Node_Index[2 * (i + Number_of_Boundary_Faces) + 1] - 1]]
        giy = [Node_y[Face_Node_Index[2 * (i + Number_of_Boundary_Faces)] - 1],
               Node_y[Face_Node_Index[2 * (i + Number_of_Boundary_Faces) + 1] - 1]]

        plt.plot(gix, giy, 'g--', color='g', markerfacecolor='g', marker='*')
    #############################以下显示所有的点号##################################
    # x = np.array(Node_x_new)
    # y = np.array(Node_y_new)
    # i = 0
    # for a, b in zip(x, y):
    # i = i + 1
    # plt.annotate('%s' % (i), xy=(a, b), color='k', xytext=(0, 0), textcoords='offset points')
    # plt.show()
    return


def display():
    # def display(node11, node22, new_node):
    for i in range(Number_of_Boundary_Faces):  #
        node1 = Face_Node_Index_new[2 * i]  #
        node2 = Face_Node_Index_new[2 * i + 1]  #
        temp_taindata_x = [Node_x_new[node1 - 1], Node_x_new[node2 - 1]]
        temp_taindata_y = [Node_y_new[node1 - 1], Node_y_new[node2 - 1]]
        plt.plot(temp_taindata_x, temp_taindata_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')

    #
    # plt.xlim(-0.01, 1.01)
    # plt.ylim(-0.05, 0.05)
    # plt.xlim(-0.1, 0.1)
    # plt.ylim(-0.1, 0.1)
    # plt.xlim(Node_x_new[node1 - 1]-0.3, Node_x_new[node1 - 1]+0.3)
    # plt.ylim(Node_y_new[node1 - 1]-0.3, Node_y_new[node1 - 1]+0.3)
    # plt.show()   #用于显示，为了加快仿真，采用上方的保存方式，免得出现后去关闭


def display3():
    plt.plot(Node_x_new, Node_y_new, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')

    plt.xlim(-90, 90)
    plt.ylim(-60, 60)
    # plt.show()   #用于显示，为了加快仿真，采用上方的保存方式，免得出现后去关闭


# ===============Advancing Front Technique==================================
AFT_stack = []
# 用于存放活动阵面的堆栈，构建二维数组，关系到数组的按元素大小存放，
# 删除首个元素，添加元素，比较等操作格式：[起点，终点，左单元，右单元，阵面长度，编号]，
# 因为所有活动阵面都没有左单元，因此设置为-1
#
# Out_Number_of_Boundary_Faces=86
# Inside_Number_of_Boundary_Faces=14
for i in range(Number_of_Boundary_Faces):
    AFT_stack.append([])
    AFT_stack[i].append(Face_Node_Index_new[2 * i + 1])  # 和以前不一样，反着存的，不然就像方形外面长了
    AFT_stack[i].append(Face_Node_Index_new[2 * i])
    AFT_stack[i].append(-1)  # -1
    AFT_stack[i].append(0)  # 0.边界face的右边单元为0
    AFT_stack[i].append(len_node2node(AFT_stack[i][0], AFT_stack[i][1]))  # 边界face的右边单元为0
    AFT_stack[i].append(i + 1)  # 把编号存进去，因为后期会被打乱，所以存入编号

boundary_stank = AFT_stack  # 因为后面AFT_stack会打乱顺序以及删除，保留初始边界信息

# for i in range(Out_Number_of_Boundary_Faces,Number_of_Boundary_Faces):
#     AFT_stack.append([])
#     AFT_stack[i].append(Face_Node_Index_new[2 * i+ 1]) #和以前不一样，反着存的，不然就像方形外面长了
#     AFT_stack[i].append(Face_Node_Index_new[2 * i ])
#     AFT_stack[i].append(-1)  # -1
#     AFT_stack[i].append(0)  # 0.边界face的右边单元为0
#     AFT_stack[i].append(len_node2node(AFT_stack[i][0], AFT_stack[i][1]))  # 边界face的右边单元为0
#     AFT_stack[i].append(i + 1)  # 把编号存进去，因为后期会被打乱，所以存入编号


# AFT_stack= sorted(AFT_stack, key=lambda fff: fff[4])  #按照第5个元素重新排序，让最短的阵面在最上方

JJ = len(AFT_stack)

k = 0
numk = 0
cell_num = 0
face_num = len(AFT_stack)
# dispaly1()  显示原始ponitwise的图形
erro_test = 8000  # 完成是1053
Qqq = 1
real_step = 0
# AFT_stack = sorted(AFT_stack, key=lambda fff: fff[4])  # 按照第5个元素重新排序，让最短的阵面在最上方
while len(AFT_stack) > 0:
    nearby_combine_flag = 3
    cross_flag_1 = 3
    cross_flag_2 = 3
    style_new_node = 8  # 新生成点相交性判断以后的模式，有可能直接生成，有可能也是和左右直接相连

    # if AFT_stack[len(AFT_stack) - 1][0] == 2485 and AFT_stack[len(AFT_stack) - 1][1] == 2625:
    #     display()
    #     node_num_display(Node_x_new, Node_y_new)
    #     plt.axis("equal")
    #     plt.show()
    # if AFT_stack[len(AFT_stack) - 2][0] == 2485 and AFT_stack[len(AFT_stack) - 2][1] == 2625:
    #     display()
    #     node_num_display(Node_x_new, Node_y_new)
    #     plt.axis("equal")
    #     plt.show()
    #
    # if AFT_stack[len(AFT_stack) - 2][0] == 2527 and AFT_stack[len(AFT_stack) - 2][1] == 2524:
    #     display()
    #     node_num_display(Node_x_new, Node_y_new)
    #     plt.axis("equal")
    #     plt.show()

    numk = numk + 1
    print("numk,real_step,Q", numk, real_step, Qqq)
    if numk > 1:
        AFT_stack.remove(AFT_stack[0])  # 删除上一次的最短阵面，放到前面方便调试
    AFT_stack = sorted(AFT_stack, key=lambda fff: fff[4])  # 按照第5个元素重新排序，让最短的阵面在最上方
    if numk >= erro_test or len(AFT_stack) == 0:
        display()  # 显示边界
        tools.node_num_display(Node_x_new, Node_y_new)
        plt.axis("equal")
        plt.show()
        break
    #
    #
    # if AFT_stack[0][0] == 2535 and AFT_stack[0][1] == 2625:
    #     display()
    #     node_num_display(Node_x_new, Node_y_new)
    #     plt.axis("equal")
    #     plt.show()
    # if AFT_stack[0][0] == 2537 and AFT_stack[0][1] == 2535:
    #     display()
    #     node_num_display(Node_x_new, Node_y_new)
    #     plt.axis("equal")
    #     plt.show()
    # if AFT_stack[0][0] == 2535 and AFT_stack[0][1] == 2491:
    #     display()
    #     node_num_display(Node_x_new, Node_y_new)
    #     plt.axis("equal")
    #     plt.show()
    # if AFT_stack[0][0] == 1325 and AFT_stack[0][1] == 1300:
    #     display()
    #     node_num_display(Node_x_new, Node_y_new)
    #     plt.show()
    # if AFT_stack[0][0] == 387 and AFT_stack[0][1] == 388:
    #     display()
    #     node_num_display(Node_x_new, Node_y_new)
    #     plt.show()

    node1 = AFT_stack[0][0]
    node2 = AFT_stack[0][1]
    node12_len = math.sqrt(
        ((Node_x_new[node1 - 1] - Node_x_new[node2 - 1]) ** 2) + ((Node_y_new[node1 - 1] - Node_y_new[node2 - 1]) ** 2))
    node2_xy_1 = tools.Translation(Node_x_new[node2 - 1], Node_y_new[node2 - 1], Node_x_new[node1 - 1], Node_y_new[node1 - 1])
    m_flag = 1.5
    ref_node = [0.5, (3 ** 0.5 / 2) * m_flag]  # 注意这里/除2是浮点型除法，整数除法是// two,往外推点，防止突发情况
    ref_node = tools.Anti_Rotation(node2_xy_1[0], node2_xy_1[1], ref_node[0], ref_node[1])
    ref_node = tools.Anti_Scaling(Node_x_new[node1 - 1], Node_y_new[node1 - 1], Node_x_new[node2 - 1], Node_y_new[node2 - 1],
                            ref_node[0], ref_node[1])
    ref_node = tools.Anti_Translation(ref_node[0], ref_node[1], Node_x_new[node1 - 1], Node_y_new[node1 - 1])

    node0 = node1_nearby_adv(AFT_stack[0][0], AFT_stack[0][5], ref_node)[0]  # 取第一个阵面，找其函数返回两个值，取第一个
    node3 = node2_nearby_adv(AFT_stack[0][1], AFT_stack[0][5], ref_node)[0]

    mid_aft_x = (Node_x_new[node1 - 1] + Node_x_new[node2 - 1]) / 2  # 阵面中心x，y坐标
    mid_aft_y = (Node_y_new[node1 - 1] + Node_y_new[node2 - 1]) / 2

    real_step = step(mid_aft_x, mid_aft_y)
    if real_step >= 1.95:
        real_step = 1.95
    # print "node12_len", node12_len
    # print "real_step",real_step

    two_ponit_len = math.sqrt(
        ((Node_x_new[node1 - 1] - Node_x_new[node2 - 1]) ** 2) + ((Node_y_new[node1 - 1] - Node_y_new[node2 - 1]) ** 2))

    node0_xy = tools.Translation(Node_x_new[node0 - 1], Node_y_new[node0 - 1], Node_x_new[node1 - 1], Node_y_new[node1 - 1])
    node0_xy = tools.Scaling(Node_x_new[node1 - 1], Node_y_new[node1 - 1], Node_x_new[node2 - 1], Node_y_new[node2 - 1],
                       node0_xy[0], node0_xy[1])
    node0_xy = tools.Rotation(node2_xy_1[0], node2_xy_1[1], node0_xy[0], node0_xy[1])

    node1_xy = tools.Translation(Node_x_new[node1 - 1], Node_y_new[node1 - 1], Node_x_new[node1 - 1], Node_y_new[node1 - 1])
    node1_xy = tools.Scaling(Node_x_new[node1 - 1], Node_y_new[node1 - 1], Node_x_new[node2 - 1], Node_y_new[node2 - 1],
                       node1_xy[0], node1_xy[1])
    node1_xy = tools.Rotation(node2_xy_1[0], node2_xy_1[1], node1_xy[0], node1_xy[1])

    node2_xy = tools.Translation(Node_x_new[node2 - 1], Node_y_new[node2 - 1], Node_x_new[node1 - 1], Node_y_new[node1 - 1])
    node2_xy = tools.Scaling(Node_x_new[node1 - 1], Node_y_new[node1 - 1], Node_x_new[node2 - 1], Node_y_new[node2 - 1],
                       node2_xy[0], node2_xy[1])
    node2_xy = tools.Rotation(node2_xy_1[0], node2_xy_1[1], node2_xy[0], node2_xy[1])

    node3_xy = tools.Translation(Node_x_new[node3 - 1], Node_y_new[node3 - 1], Node_x_new[node1 - 1], Node_y_new[node1 - 1])
    node3_xy = tools.Scaling(Node_x_new[node1 - 1], Node_y_new[node1 - 1], Node_x_new[node2 - 1], Node_y_new[node2 - 1],
                       node3_xy[0], node3_xy[1])
    node3_xy = tools.Rotation(node2_xy_1[0], node2_xy_1[1], node3_xy[0], node3_xy[1])

    test_data_nn = [
        [node0_xy[0], node0_xy[1], node1_xy[0], node1_xy[1], node2_xy[0], node2_xy[1], node3_xy[0], node3_xy[1]]]

    with tf.Graph().as_default() as g:

        x_data = tf.placeholder(tf.float32, [None, nngen_forward_step.INPUT_NODE], name='x_input')

        final_output = nngen_forward_step.forward(x_data, None)

        saver = tf.train.Saver()

        with tf.Session() as sess:
            ckpt = tf.train.get_checkpoint_state(nngen_backward_air.MODEL_SAVE_PATH)

            if ckpt and ckpt.model_checkpoint_path:
                saver.restore(sess, ckpt.model_checkpoint_path)
                global_step = ckpt.model_checkpoint_path.split('/')[-1].split('-')[-1]
                final_output1 = sess.run(final_output, feed_dict={x_data: test_data_nn})
                # print("input data",test_data_nn)
                # print("result",final_output1)
                # return final_output1
            else:
                print('No checkpoint file found')
                # return -1
        model = round(final_output1[0][2] - 0.08)  # 0,为左边点连接答案点，不生成新点，将阵面第二点与第0点连接，作为答案点，生成新一条阵面，更改数据结构

    # print("model", final_output1[0][2],model)

    Qqq = real_step * (2 / (3 ** 0.5)) / node12_len

    # print "Q=",Qqq
    new_node = [0.5, (3 ** 0.5 / 2) * Qqq]  # 注意这里/除2是浮点型除法，整数除法是// two
    # two_ponit_len=(3 ** 0.5 / 2)*Q*1.05

    # 新生成的点反归一化##def Translation(x,y,x0,y0):#x,y表示要任何要平移的点，x0，y0表示将以何点为圆心作为参考点
    ##缩放函数，归一化处理x_start,y_start,x_end,y_end,x,y分别表示坐标系x轴起点与终点坐标值，xy为任意需要变换的点
    # #def Scaling(x_start,y_start,x_end,y_end,x,y):  #注意xy是经过平移的点
    # def Rotation(x_end,y_end,x_rot,y_rot):#x_end,y_end为第一步平移后face另外一个点的值以便求与全局坐标系求夹角ceta，
    #     # xrot yrot为任意需要旋转的坐标
    #     # 相当于勾股定理，求得斜线的长度
    new_node = tools.Anti_Rotation(node2_xy_1[0], node2_xy_1[1], new_node[0], new_node[1])
    new_node = tools.Anti_Scaling(Node_x_new[node1 - 1], Node_y_new[node1 - 1], Node_x_new[node2 - 1], Node_y_new[node2 - 1],
                            new_node[0], new_node[1])
    new_node = tools.Anti_Translation(new_node[0], new_node[1], Node_x_new[node1 - 1], Node_y_new[node1 - 1])

    node1_nearby = node1_nearby_adv(AFT_stack[0][0], AFT_stack[0][5], ref_node)  # 包含两个原变量，一个是点，和face的编号
    node2_nearby = node2_nearby_adv(AFT_stack[0][1], AFT_stack[0][5], ref_node)
    ccc = node1_nearby[0]
    ddd = node2_nearby[0]

    node2_xy_1 = tools.Translation(Node_x_new[node2 - 1], Node_y_new[node2 - 1], Node_x_new[node1 - 1], Node_y_new[node1 - 1])

    ref_node = [0.5, (3 ** 0.5 / 2) * m_flag]  # 注意这里/除2是浮点型除法，整数除法是// two
    node2_xy_2 = tools.Translation(Node_x_new[node1 - 1], Node_y_new[node1 - 1], Node_x_new[ccc - 1],
                             Node_y_new[ccc - 1])  # 左边face的标准，以便恢复所用
    ref_node = tools.Anti_Rotation(node2_xy_1[0], node2_xy_1[1], ref_node[0], ref_node[1])
    ref_node = tools.Anti_Scaling(Node_x_new[ccc - 1], Node_y_new[ccc - 1], Node_x_new[node1 - 1], Node_y_new[node1 - 1],
                            ref_node[0], ref_node[1])  # 比例尺寸就是ccc到node1的长度
    ref_node = tools.Anti_Translation(ref_node[0], ref_node[1], Node_x_new[ccc - 1], Node_y_new[ccc - 1])  # ccc是起点，圆点参考点

    node1_node1_nearby = node1_nearby_adv(ccc, node1_nearby[1], ref_node)
    eee = node1_node1_nearby[0]

    ref_node2 = [0.5, (3 ** 0.5 / 2) * m_flag]  # 注意这里/除2是浮点型除法，整数除法是// two   求ddd到node2这face的中心，为了找到fff
    node2_xy_3 = tools.Translation(Node_x_new[ddd - 1], Node_y_new[ddd - 1], Node_x_new[node2 - 1],
                             Node_y_new[node2 - 1])  # 左边face的标准，以便恢复所用
    ref_node2 = tools.Anti_Rotation(node2_xy_3[0], node2_xy_3[1], ref_node2[0], ref_node2[1])
    ref_node2 = tools.Anti_Scaling(Node_x_new[ddd - 1], Node_y_new[ddd - 1], Node_x_new[node2 - 1], Node_y_new[node2 - 1],
                             ref_node2[0], ref_node2[1])  # 比例尺寸就是ddd到node2的长度
    ref_node2 = tools.Anti_Translation(ref_node2[0], ref_node2[1], Node_x_new[ccc - 1], Node_y_new[ccc - 1])  # ccc是起点，圆点参考点

    node2_node2_nearby = node2_nearby_adv(ddd, node2_nearby[1], ref_node2)
    fff = node2_node2_nearby[0]

    # eee = node1_nearby_adv(node1_nearby_adv(AFT_stack[0][0], AFT_stack[0][5],ref_node)[0],node1_nearby_adv(AFT_stack[0][0], AFT_stack[0][5],ref_node)[1])[0]
    # fff = node2_nearby_adv(node2_nearby_adv(AFT_stack[0][1], AFT_stack[0][5])[0],
    #                        node2_nearby_adv(AFT_stack[0][1], AFT_stack[0][5])[1])[0]
    if model == 3:
        model = 2
    if model == -1:
        model = 0
    if model == 0:  # 不需要建立新点，只需要将node2与node0连接起来，更改face的各项数据结构（完善阵面的左边cell，node0-node1边的左cell
        # ，新face 的右边cell）
        # ，阵面数据结构需要删除两个阵面数据，增加一个阵面（前面的face）

        if fff != ccc:  # 判断是不是有四个点组成的小区域，不是就按普通的来，是就要删除四个点组成的连通域组成的阵面，见else代码
            aaa = 0
            cell_num = cell_num + 1  # 多一个cell
            face_num = face_num + 1  # 多1个face,

            # 完善以前face的左边cell
            Left_Cell_Index_new[AFT_stack[0][5] - 1] = cell_num  # 补充阵面的左单元
            Left_Cell_Index_new[
                node1_nearby[1] - 1] = cell_num  # 补充node0-node1face的左单元，node1_nearby_adv函数返回两个值，第2个是face编号

            ##新face数据结构######################
            Face_Node_Index_new.append(node0)
            Face_Node_Index_new.append(node2)
            Left_Cell_Index_new.append(-1)
            Right_Cell_Index_new.append(cell_num)
            len_Right_Cell_Index_new = len(Right_Cell_Index_new)  # 测试用
            ##########更新活动阵面数据结构######################
            len_aft = len(AFT_stack)
            AFT_stack.append([])
            len_aft = len(AFT_stack)
            AFT_stack[len_aft - 1].append(node0)
            AFT_stack[len_aft - 1].append(node2)
            AFT_stack[len_aft - 1].append(-1)  # -1
            AFT_stack[len_aft - 1].append(cell_num)  # 0.边界face的右边单元为0
            AFT_stack[len_aft - 1].append(len_node2node(node0, node2))  # 边界face的右边单元为0
            AFT_stack[len_aft - 1].append(face_num)  # 把编号存进去，因为后期会被打乱，所以存入编号

            mm = node1_nearby[1]  # AFT_stack[0][0]表示阵面的0个行第0个元素，也就是输入神经网络的node1，通过送到node1_nearby_adv，返回的【1】为face号
            AFT_stack = tools.del_adv_elemnt(AFT_stack, mm)
            # AFT_stack.remove(AFT_stack[0])  # 将刚开始弹出的最短阵面删除

            node0_node2_x = [Node_x_new[node0 - 1], Node_x_new[node2 - 1]]
            node0_node2_y = [Node_y_new[node0 - 1], Node_y_new[node2 - 1]]
            plt.plot(node0_node2_x, node0_node2_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')
            ccc = ccc + 1

            # AFT_stack = sorted(AFT_stack, key=lambda fff: fff[4])  # 按照第5个元素重新排序，让最短的阵面在最上方
        else:  # 4个点组成一个连通域，属于特殊情况
            cell_num = cell_num + 1  # 多两个cell，这里暂时先加第一个
            face_num = face_num + 1  # 多1个face,除了自己本身不生成阵面，还得少4个阵面

            # 完善以前face的左边cell
            Left_Cell_Index_new[AFT_stack[0][5] - 1] = cell_num  # 补充阵面的左单元
            Left_Cell_Index_new[
                node1_nearby[1] - 1] = cell_num  # 补充node0-node1face的左单元，node1_nearby_adv函数返回两个值，第2个是face编号

            ##新face数据结构######################
            Face_Node_Index_new.append(node0)
            Face_Node_Index_new.append(node2)
            Left_Cell_Index_new.append(cell_num + 1)  # 因为4点构成封闭连通域，face 的左边已经构成一个新的cell
            Right_Cell_Index_new.append(cell_num)
            len_Right_Cell_Index_new = len(Right_Cell_Index_new)  # 测试用

            # 新的face不生成活动阵面
            cell_num = cell_num + 1  # 多两个cell，这里加第2个
            right_node = node2_nearby
            right_node1 = right_node[1]
            right_node1_point = right_node[0]
            Left_Cell_Index_new[right_node1 - 1] = cell_num  #
            right_node2 = node2_node2_nearby[1]
            Left_Cell_Index_new[right_node2 - 1] = cell_num  #
            # 删除4个阵面
            # AFT_stack[0][0]表示阵面的0个行第0个元素，也就是输入神经网络的node1，通过送到node1_nearby_adv，返回的【1】为face号,
            mm = node1_nearby[1]
            AFT_stack = tools.del_adv_elemnt(AFT_stack, mm)  # 删除0-1点的阵面
            AFT_stack = tools.del_adv_elemnt(AFT_stack, right_node1)  # 删除2-3点的阵面
            AFT_stack = tools.del_adv_elemnt(AFT_stack, right_node2)  # 删除3-0点的阵面

            # AFT_stack.remove(AFT_stack[0])  # 将刚开始弹出的最短阵面删除

            node0_node2_x = [Node_x_new[node0 - 1], Node_x_new[node2 - 1]]
            node0_node2_y = [Node_y_new[node0 - 1], Node_y_new[node2 - 1]]
            plt.plot(node0_node2_x, node0_node2_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')
            ccc = ccc + 1

            # AFT_stack = sorted(AFT_stack, key=lambda fff: fff[4])  # 按照第5个元素重新排序，让最短的阵面在最上方



    elif model == 1:  # 1,可能会生成新点，将阵面第1\2点与新点连接，生成2阵面，更改数据结构
        New_node_nearby = []  # 清空存放相邻点的二维list
        New_face_nearby = []
        ######先将新点存储下来，好与临近点一起做循环处理，后面如果不选择新点，直接通过
        # node_num=len(Node_x_new)+1 #新点序号Node_x_new.pop()弹出

        Node_x_new.append(new_node[0])
        Node_y_new.append(new_node[1])
        Counter_New_node_nearby = 0
        Counter_New_face_nearby = 0
        #######################################################
        # 临近点的坐标存在New_node_nearby这个list里面
        for i in range(len(AFT_stack)):
            # def nearby_combine(node1x, node1y, R, node2x, node2y):  # 判断node2x,node2y是不是在以node1x,node1y为圆心,R为半径的圆以内，是返回1，不是返回0
            if tools.nearby_combine(new_node[0], new_node[1], 1 * two_ponit_len, Node_x_new[AFT_stack[i][0] - 1],
                              Node_y_new[AFT_stack[i][0] - 1]):  # 返回值为1，说明了阵面有点在新生成点的附近

                New_node_nearby.append([])  # 建立了一个二维的数组，存放临近点，作所以做成2维，主要是因为后期的每个临近点要根据阵面质量来排序
                New_node_nearby[Counter_New_node_nearby].append(AFT_stack[i][0])
                Counter_New_node_nearby = Counter_New_node_nearby + 1
        for i in range(len(AFT_stack)):
            # def nearby_combine(node1x, node1y, R, node2x, node2y):  # 判断node2x,node2y是不是在以node1x,node1y为圆心,R为半径的圆以内，是返回1，不是返回0

            if tools.nearby_combine(new_node[0], new_node[1], 1 * two_ponit_len, Node_x_new[AFT_stack[i][1] - 1],
                              Node_y_new[AFT_stack[i][1] - 1]):
                New_node_nearby.append([])
                New_node_nearby[Counter_New_node_nearby].append(AFT_stack[i][1])
                Counter_New_node_nearby = Counter_New_node_nearby + 1
        # 将New_node_nearby里面重复的点去掉放在list2，然后list2再赋值给New_node_nearby，然后还要去掉阵面上的两个点
        list2 = []
        for i in New_node_nearby:
            if i not in list2:
                if (i != [AFT_stack[0][0]]) and (i != [AFT_stack[0][1]]):  # 不能是阵面上的点
                    list2.append(i)
        New_node_nearby = list2

        # 将新点坐标也放进去，后面会根据三角形生成质量整体排序

        New_node_nearby.append([])
        New_node_nearby[len(New_node_nearby) - 1].append(len(Node_x_new))  # len(Node_x_new)为最后一个点的号数，从1开始的,在找点的时候要对前值减一

        # AFT_Centor_x=0.5*(Node_x_new[node1-1]+Node_x_new[node2-1])
        # AFT_Centor_y=0.5*(Node_y_new[node1-1]+Node_y_new[node2-1])

        # 找新点附近的阵面，后面判断相交性；将新点的临近阵元的编号号存在New_face_nearby这个list里面，按新点与临近阵元中心
        for i in range(1, len(AFT_stack)):  # i从1开始，去掉了生成新点的阵面
            AFT_i_Centor_x = 0.5 * (Node_x_new[AFT_stack[i][0] - 1] + Node_x_new[AFT_stack[i][1] - 1])  # 阵面i的中心坐标x
            AFT_i_Centor_y = 0.5 * (Node_y_new[AFT_stack[i][0] - 1] + Node_y_new[AFT_stack[i][1] - 1])  # 阵面i的中心坐标y
            if tools.nearby_combine(new_node[0], new_node[1], 2 * two_ponit_len,
                              AFT_i_Centor_x, AFT_i_Centor_y):  # 返回值为1，说明了阵面有点在新生成点的附近
                New_face_nearby.append(i)  # 存的在AFT中的编号

        # 网格质量排序，将二维list中所有的临近点与阵面AB两点构成的三角形生成的质量通过函数判断正三角形的质量系数排序
        # Triangle_Quality_Judgment(x1, y1, x2, y2, x3, y3): 内部参数分别是是三个点的xy坐标值
        for i in range(len(New_node_nearby)):
            test6 = New_node_nearby[i][0]
            test7 = node1
            test8 = node2
            test_temp = tools.Triangle_Quality_Judgment(Node_x_new[New_node_nearby[i][0] - 1],
                                                  Node_y_new[New_node_nearby[i][0] - 1],
                                                  Node_x_new[node1 - 1], Node_y_new[node1 - 1], Node_x_new[node2 - 1],
                                                  Node_y_new[node2 - 1])
            if New_node_nearby[i][0] == len(Node_x_new):  # 新生成最好的点需要乘以一个质量系数
                test_temp = 0.7 * test_temp

            New_node_nearby[i].append(test_temp)

        New_node_nearby = sorted(New_node_nearby, key=lambda fff: fff[1], reverse=True)  # 按第二个元素降序排序
        # sorted（key,reverse=True or Flase）在key后面可以指定一个参数，就是正序和降序的选择

        # 以下是相交性判断
        for i in range(len(New_node_nearby)):
            cross_flag_1 = 0  # 默认不相交，如果相交会让他置1
            near_flag_1 = 0  # 默认不临近，如果候选点与阵面很接近，会让他置1
            on_aft_flag_1 = 0  # 默认不临近，如果候选点与阵面很接近，会让他置1

            for j in range(len(New_face_nearby)):

                test1 = AFT_stack[0][0]
                test2 = AFT_stack[0][1]
                test3 = New_node_nearby[i][0]
                test4 = AFT_stack[New_face_nearby[j]][0]
                test5 = AFT_stack[New_face_nearby[j]][1]
                test9 = AFT_stack[New_face_nearby[j]][0]
                test10 = AFT_stack[New_face_nearby[j]][1]

                p1 = tools.point(Node_x_new[AFT_stack[0][0] - 1], Node_y_new[AFT_stack[0][0] - 1])
                p11 = tools.point(Node_x_new[AFT_stack[0][1] - 1], Node_y_new[AFT_stack[0][1] - 1])
                p2 = tools.point(Node_x_new[New_node_nearby[i][0] - 1],
                           Node_y_new[New_node_nearby[i][0] - 1])  # 相邻点质量排序点

                p3 = tools.point(Node_x_new[AFT_stack[New_face_nearby[j]][0] - 1],
                           Node_y_new[AFT_stack[New_face_nearby[j]][0] - 1])
                p4 = tools.point(Node_x_new[AFT_stack[New_face_nearby[j]][1] - 1],
                           Node_y_new[AFT_stack[New_face_nearby[j]][1] - 1])

                r_left = tools.IsIntersec(p1, p2, p3, p4)
                r_right = tools.IsIntersec(p11, p2, p3, p4)
                if test3 != test4 and test3 != test5:  # 新点不是阵面上的点，这种都不等的情况就是说新点不是阵面上的点，要测算距离，而阵面上的点距离为零不用测
                    len_node2aft = tools.node_aft_len(p2, p3, p4)
                    tempm = real_step / 3.5
                    if len_node2aft < tempm:
                        near_flag_1 = 1

                if r_left == 1 or r_right == 1 or near_flag_1 == 1:
                    cross_flag_1 = 1  # 只要预选的某个点和一个临近阵面相交，则选下一个候选点从新循环
                    break
                else:
                    cross_flag_1 = 0  # 质量最好的点和所有阵面都不想交，所以要跳出两个循环
                    Pbest_num = New_node_nearby[i]

            if cross_flag_1 == 0:
                Pbest_num = New_node_nearby[i]
                break

        if cross_flag_1 == 1:  # 只要预选的某个点和一个临近阵面相交，则选下一个候选点从新循环
            print ("所有点都要和相邻阵面相交，可以换一个最短阵面来试，有些地方可以考虑挖一个洞")
            print ("阵面左边点，阵面右边点"), AFT_stack[0][0], AFT_stack[0][1]
            print ("新点xy"), new_node[0], new_node[1]
            new_node

            display()  # 显示边界
            tools.node_num_display(Node_x_new, Node_y_new)
            plt.axis("equal")
            plt.show()

        if cross_flag_1 == 0:  # nearnode1_nearby_adv
            # ccc = node1_nearby_adv(AFT_stack[0][0], AFT_stack[0][5])[0]
            # ddd = node2_nearby_adv(AFT_stack[0][1], AFT_stack[0][5])[0]
            # eee = node1_nearby_adv(node1_nearby_adv(AFT_stack[0][0], AFT_stack[0][5])[0],
            #                        node1_nearby_adv(AFT_stack[0][0], AFT_stack[0][5])[1])[0]
            # fff = node2_nearby_adv(node2_nearby_adv(AFT_stack[0][1], AFT_stack[0][5])[0],
            #                        node2_nearby_adv(AFT_stack[0][1], AFT_stack[0][5])[1])[0]
            if ccc == Pbest_num[0] and fff != Pbest_num[0]:  # 看新点是不是阵面左点的临近点，如果是，则最佳点不是新生成的点，这时新生成的点还没有构建face数据结构
                style_new_node = 0  # 后面要写成函数，现在暂时
                # 因为此种状态不生成新点，所以需要把为了上次循环处理方便，加进去的点的坐标处理干净
                Node_x_new.pop()
                Node_y_new.pop()

                aaa = 0
                cell_num = cell_num + 1  # 多一个cell
                face_num = face_num + 1  # 多1个face,

                # 完善以前face的左边cell
                Left_Cell_Index_new[AFT_stack[0][5] - 1] = cell_num  # 补充阵面的左单元
                Left_Cell_Index_new[
                    node1_nearby[1] - 1] = cell_num  # 补充node0-node1face的左单元，node1_nearby_adv函数返回两个值，第2个是face编号

                ##新face数据结构######################
                Face_Node_Index_new.append(node0)
                Face_Node_Index_new.append(node2)
                Left_Cell_Index_new.append(-1)
                Right_Cell_Index_new.append(cell_num)
                len_Right_Cell_Index_new = len(Right_Cell_Index_new)  # 测试用
                ##########更新活动阵面数据结构######################
                len_aft = len(AFT_stack)
                AFT_stack.append([])
                len_aft = len(AFT_stack)
                AFT_stack[len_aft - 1].append(node0)
                AFT_stack[len_aft - 1].append(node2)
                AFT_stack[len_aft - 1].append(-1)  # -1
                AFT_stack[len_aft - 1].append(cell_num)  # 0.边界face的右边单元为0
                AFT_stack[len_aft - 1].append(len_node2node(node0, node2))  # 边界face的右边单元为0
                AFT_stack[len_aft - 1].append(face_num)  # 把编号存进去，因为后期会被打乱，所以存入编号

                mm = node1_nearby[
                    1]  # AFT_stack[0][0]表示阵面的0个行第0个元素，也就是输入神经网络的node1，通过送到node1_nearby_adv，返回的【1】为face号
                AFT_stack = tools.del_adv_elemnt(AFT_stack, mm)
                # AFT_stack.remove(AFT_stack[0])  # 将刚开始弹出的最短阵面删除

                node0_node2_x = [Node_x_new[node0 - 1], Node_x_new[node2 - 1]]
                node0_node2_y = [Node_y_new[node0 - 1], Node_y_new[node2 - 1]]
                plt.plot(node0_node2_x, node0_node2_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')
                ccc = ccc + 1

                # AFT_stack = sorted(AFT_stack, key=lambda fff: fff[4])  # 按照第5个元素重新排序，让最短的阵面在最上方
            elif ccc == Pbest_num[0] and fff == Pbest_num[0]:
                Node_x_new.pop()
                Node_y_new.pop()

                cell_num = cell_num + 1  # 多两个cell，这里暂时先加第一个
                face_num = face_num + 1  # 多1个face,除了自己本身不生成阵面，还得少4个阵面
                node2
                # 完善以前face的左边cell
                Left_Cell_Index_new[AFT_stack[0][5] - 1] = cell_num  # 补充阵面的左单元
                Left_Cell_Index_new[
                    node1_nearby[1] - 1] = cell_num  # 补充node0-node1face的左单元，node1_nearby_adv函数返回两个值，第2个是face编号

                ##新face数据结构######################
                Face_Node_Index_new.append(node0)
                Face_Node_Index_new.append(node2)
                Left_Cell_Index_new.append(cell_num + 1)  # 因为4点构成封闭连通域，face 的左边已经构成一个新的cell
                Right_Cell_Index_new.append(cell_num)
                len_Right_Cell_Index_new = len(Right_Cell_Index_new)  # 测试用

                # 新的face不生成活动阵面
                cell_num = cell_num + 1  # 多两个cell，这里加第2个
                right_node = node2_nearby
                right_node1 = right_node[1]
                right_node1_point = right_node[0]
                Left_Cell_Index_new[right_node1 - 1] = cell_num  #
                right_node2 = node2_node2_nearby[1]
                Left_Cell_Index_new[right_node2 - 1] = cell_num  #
                # 删除4个阵面
                # AFT_stack[0][0]表示阵面的0个行第0个元素，也就是输入神经网络的node1，通过送到node1_nearby_adv，返回的【1】为face号,
                mm = node1_nearby[1]
                AFT_stack = tools.del_adv_elemnt(AFT_stack, mm)  # 删除0-1点的阵面
                AFT_stack = tools.del_adv_elemnt(AFT_stack, right_node1)  # 删除2-3点的阵面
                AFT_stack = tools.del_adv_elemnt(AFT_stack, right_node2)  # 删除3-0点的阵面

                # AFT_stack.remove(AFT_stack[0])  # 将刚开始弹出的最短阵面删除

                node0_node2_x = [Node_x_new[node0 - 1], Node_x_new[node2 - 1]]
                node0_node2_y = [Node_y_new[node0 - 1], Node_y_new[node2 - 1]]
                plt.plot(node0_node2_x, node0_node2_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')
                ccc = ccc + 1

            elif ddd == Pbest_num[0] and eee != Pbest_num[0]:
                style_new_node = 1  # 后面要写成函数，现在暂时
                # 因为此种状态不生成新点，所以需要把为了上次循环处理方便，加进去的点的坐标处理干净
                Node_x_new.pop()
                Node_y_new.pop()

                aaa = 2
                cell_num = cell_num + 1  # 多一个cell
                face_num = face_num + 1  # 多1个face,

                # 完善以前face的左边cell
                Left_Cell_Index_new[AFT_stack[0][5] - 1] = cell_num  # 补充阵面的左单元
                Left_Cell_Index_new[
                    node2_nearby[
                        1] - 1] = cell_num  # 补充node2-node3face的左单元，node1_nearby_adv函数返回两个值，第2个是face编号

                ##新face数据结构######################
                Face_Node_Index_new.append(node1)
                Face_Node_Index_new.append(node3)
                Left_Cell_Index_new.append(-1)
                Right_Cell_Index_new.append(cell_num)
                len_Right_Cell_Index_new = len(Right_Cell_Index_new)  # 测试用
                ##########更新活动阵面数据结构######################
                len_aft = len(AFT_stack)
                AFT_stack.append([])
                len_aft = len(AFT_stack)
                AFT_stack[len_aft - 1].append(node1)
                AFT_stack[len_aft - 1].append(node3)
                AFT_stack[len_aft - 1].append(-1)  # -1
                AFT_stack[len_aft - 1].append(cell_num)  # 0.边界face的右边单元为0
                AFT_stack[len_aft - 1].append(len_node2node(node1, node3))  # 边界face的右边单元为0
                AFT_stack[len_aft - 1].append(face_num)  # 把编号存进去，因为后期会被打乱，所以存入编号

                mm = node2_nearby[1]
                # AFT_stack[0][0]表示阵面的0个行第0个元素，也就是输入神经网络的node1，
                # 通过送到node1_nearby_adv，返回的【1】为face号,在阵面中删除这个face号的信息，因为为非活动阵面
                AFT_stack = tools.del_adv_elemnt(AFT_stack, mm)
                # AFT_stack.remove(AFT_stack[0])  # 将刚开始弹出的最短阵面删除

                node1_node3_x = [Node_x_new[node1 - 1], Node_x_new[node3 - 1]]
                node1_node3_y = [Node_y_new[node1 - 1], Node_y_new[node3 - 1]]
                plt.plot(node1_node3_x, node1_node3_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')


            # 如果最好的点是阵面起点的左边临点的左边临点，则直接构成一个三角形，会删除三个阵面，增加两个face
            elif ddd == Pbest_num[0] and eee == Pbest_num[0]:

                Node_x_new.pop()
                Node_y_new.pop()
                cell_num = cell_num + 1  # 多两个cell，这里暂时先加第一个
                face_num = face_num + 1  # 多1个face,除了自己本身不生成阵面，还得少4个阵面

                # 完善以前face的左边cell
                Left_Cell_Index_new[AFT_stack[0][5] - 1] = cell_num  # 补充阵面的左单元

                Left_Cell_Index_new[
                    node2_nearby[
                        1] - 1] = cell_num  # 补充node0-node1face的左单元，node1_nearby_adv函数返回两个值，第2个是face编号

                CCC = Left_Cell_Index_new[
                    node1_nearby[1] - 1]
                ##新ce数据结构######################
                Face_Node_Index_new.append(node1)
                Face_Node_Index_new.append(node3)
                Left_Cell_Index_new.append(cell_num + 1)  # 因为4点构成封闭连通域，face 的左边已经构成一个新的cell
                Right_Cell_Index_new.append(cell_num)
                len_Right_Cell_Index_new = len(Right_Cell_Index_new)  # 测试用
                print ("四边形")
                # 新的face不生成活动阵面
                cell_num = cell_num + 1  # 多两个cell，这里加第2个
                left_node = node1_nearby
                left_node1 = left_node[1]  # 临点face编号
                left_node1_point = left_node[0]  # 临点点号
                Left_Cell_Index_new[left_node1 - 1] = cell_num  #
                left_node2 = node1_node1_nearby[1]
                Left_Cell_Index_new[left_node2 - 1] = cell_num  #
                # 删除4个阵面
                # AFT_stack[0][0]表示阵面的0个行第0个元素，也就是输入神经网络的node1，通过送到node1_nearby_adv，返回的【1】为face号,
                mm = node2_nearby[1]
                AFT_stack = tools.del_adv_elemnt(AFT_stack, mm)  # 删除0-1点的阵面
                print("1")
                AFT_stack = tools.del_adv_elemnt(AFT_stack, left_node1)  # 删除2-3点的阵面
                print("2")
                AFT_stack = tools.del_adv_elemnt(AFT_stack, left_node2)  # 删除3-0点的阵面
                print("3")

                # AFT_stack.remove(AFT_stack[0])  # 将刚开始弹出的最短阵面删除

                node0_node2_x = [Node_x_new[node1 - 1], Node_x_new[node3 - 1]]
                node0_node2_y = [Node_y_new[node1 - 1], Node_y_new[node3 - 1]]
                plt.plot(node0_node2_x, node0_node2_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')

            # 不是五条边形
            elif eee == Pbest_num[0] and fff != Pbest_num[0]:
                mm = 1
                # yinwei node1——nearby这个函数返回两个值，第一个是临点，第二个是阵面face号，后面优化的时候可以把
                # 临点和临点face号写出来，不要每次都去搜索
                # 因为此种状态不生成新点，所以需要把为了上次循环处理方便，加进去的点的坐标处理干净
                Node_x_new.pop()
                Node_y_new.pop()

                aaa = 0
                cell_num = cell_num + 1  # 多2个cell,先加第1个
                face_num = face_num + 1  # 多2个face,先加第1个

                # 完善以前face的左边cell
                Left_Cell_Index_new[AFT_stack[0][5] - 1] = cell_num  # 补充阵面的左单元
                # Left_Cell_Index_new[node1_nearby_adv(AFT_stack[0][0])[1] - 1] = cell_num

                ##新face数据结构######################在figure——1-5.png中，是31-117
                Face_Node_Index_new.append(Pbest_num[0])
                Face_Node_Index_new.append(node2)
                Left_Cell_Index_new.append(-1)
                Right_Cell_Index_new.append(cell_num)
                len_Right_Cell_Index_new = len(Right_Cell_Index_new)  # 测试用
                ##########更新活动阵面数据结构######################
                len_aft = len(AFT_stack)
                AFT_stack.append([])
                len_aft = len(AFT_stack)
                AFT_stack[len_aft - 1].append(Pbest_num[0])
                AFT_stack[len_aft - 1].append(node2)
                AFT_stack[len_aft - 1].append(-1)  # -1
                AFT_stack[len_aft - 1].append(cell_num)  # 0.边界face的右边单元为0
                AFT_stack[len_aft - 1].append(len_node2node(Pbest_num[0], node2))  # 边界face的右边单元为0
                AFT_stack[len_aft - 1].append(face_num)  # 把编号存进去，因为后期会被打乱，所以存入编号

                cell_num = cell_num + 1  # 多2个cell,先加第2个
                face_num = face_num + 1  # 多2个face,先加第2个

                # 完善以前原始阵面的左边face（也是阵面);30点-29点
                mm1 = node1_nearby
                node1_near_face_num = mm1[1]
                node1_near_node_num = mm1[0]
                Left_Cell_Index_new[node1_near_face_num - 1] = cell_num  # 补充的左单元

                AFT_stack = tools.del_adv_elemnt(AFT_stack, node1_near_face_num)  # 删除以前的阵面

                # 完善以前原始阵面的左边临点的临点查找;31点-30点
                mm2 = node1_node1_nearby

                node1_near_face_num = mm2[1]
                node1_near_node_num = mm2[0]
                Left_Cell_Index_new[node1_near_face_num - 1] = cell_num  # 补充的左单元

                AFT_stack = tools.del_adv_elemnt(AFT_stack, node1_near_face_num)  # 删除以前的阵面

                # 新face的形成（29点-31点）figure——1-5.png中
                Face_Node_Index_new.append(node1)
                Face_Node_Index_new.append(Pbest_num[0])
                Left_Cell_Index_new.append(cell_num)
                Right_Cell_Index_new.append(cell_num - 1)  # 因为同时生成了两个cell。把这条face包围
                len_Right_Cell_Index_new = len(Right_Cell_Index_new)  # 测试用

                # AFT_stack.remove(AFT_stack[0])  # 将刚开始弹出的最短阵面删除

                node0_node2_x = [Node_x_new[Pbest_num[0] - 1], Node_x_new[node1 - 1]]
                node0_node2_y = [Node_y_new[Pbest_num[0] - 1], Node_y_new[node1 - 1]]
                plt.plot(node0_node2_x, node0_node2_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')

                node0_node2_x = [Node_x_new[Pbest_num[0] - 1], Node_x_new[node2 - 1]]
                node0_node2_y = [Node_y_new[Pbest_num[0] - 1], Node_y_new[node2 - 1]]
                plt.plot(node0_node2_x, node0_node2_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')

                ccc = ccc + 1

                # AFT_stack = sorted(AFT_stack, key=lambda fff: fff[4])  # 按照第5个元素重新排序，让最短的阵面在


            elif fff == Pbest_num[0] and eee != Pbest_num[0]:
                mm = 2
                Node_x_new.pop()
                Node_y_new.pop()

                aaa = 0
                cell_num = cell_num + 1  # 多2个cell,先加第1个
                face_num = face_num + 1  # 多2个face,先加第1个

                # 完善以前face的左边cell
                Left_Cell_Index_new[AFT_stack[0][5] - 1] = cell_num  # 补充阵面的左单元

                ##新face数据结构######################与在figure——1-5.png中，是31-117相似
                Face_Node_Index_new.append(node1)
                Face_Node_Index_new.append(Pbest_num[0])
                Left_Cell_Index_new.append(-1)
                Right_Cell_Index_new.append(cell_num)
                len_Right_Cell_Index_new = len(Right_Cell_Index_new)  # 测试用
                ##########更新活动阵面数据结构######################
                len_aft = len(AFT_stack)
                AFT_stack.append([])
                len_aft = len(AFT_stack)
                AFT_stack[len_aft - 1].append(node1)
                AFT_stack[len_aft - 1].append(Pbest_num[0])
                AFT_stack[len_aft - 1].append(-1)  # -1
                AFT_stack[len_aft - 1].append(cell_num)  # 0.边界face的右边单元为0
                AFT_stack[len_aft - 1].append(len_node2node(node1, Pbest_num[0]))  # 边界face的右边单元为0
                AFT_stack[len_aft - 1].append(face_num)  # 把编号存进去，因为后期会被打乱，所以存入face的编号

                cell_num = cell_num + 1  # 多2个cell,先加第2个
                face_num = face_num + 1  # 多2个face,先加第2个

                # 完善以前原始阵面的左边face（也是阵面);与30点-29点  相似
                mm1 = node2_nearby  # 找阵面第二点也就是右边那个点的右边相邻点
                node2_near_face_num = mm1[1]
                node2_near_node_num = mm1[0]
                Left_Cell_Index_new[node2_near_face_num - 1] = cell_num  # 补充的左单元

                AFT_stack = tools.del_adv_elemnt(AFT_stack, node2_near_face_num)  # 删除以前的阵面

                # 完善以前原始阵面的左边临点的临点查找;31点-30点
                mm2 = node2_node2_nearby

                node2_near_face_num = mm2[1]
                node2_near_node_num = mm2[0]
                Left_Cell_Index_new[node2_near_face_num - 1] = cell_num  # 补充的左单元

                AFT_stack = tools.del_adv_elemnt(AFT_stack, node2_near_face_num)  # 删除以前的阵面

                # 新face的形成（29点-31点）figure——1-5.png中
                Face_Node_Index_new.append(Pbest_num[0])
                Face_Node_Index_new.append(node2)
                Left_Cell_Index_new.append(cell_num)
                Right_Cell_Index_new.append(cell_num - 1)  # 因为同时生成了两个cell。把这条face包围
                len_Right_Cell_Index_new = len(Right_Cell_Index_new)  # 测试用

                # AFT_stack.remove(AFT_stack[0])  # 将刚开始弹出的最短阵面删除

                node0_node2_x = [Node_x_new[Pbest_num[0] - 1], Node_x_new[node1 - 1]]
                node0_node2_y = [Node_y_new[Pbest_num[0] - 1], Node_y_new[node1 - 1]]
                plt.plot(node0_node2_x, node0_node2_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')

                node0_node2_x = [Node_x_new[Pbest_num[0] - 1], Node_x_new[node2 - 1]]
                node0_node2_y = [Node_y_new[Pbest_num[0] - 1], Node_y_new[node2 - 1]]
                plt.plot(node0_node2_x, node0_node2_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')

                ccc = ccc + 1

                # AFT_stack = sorted(AFT_stack, key=lambda fff: fff[4])  # 按照第5个元素重新排序，让最短的阵面在

            elif fff == Pbest_num[0] and eee == Pbest_num[0]:
                mm = 2
                Node_x_new.pop()
                Node_y_new.pop()

                aaa = 0
                cell_num = cell_num + 1  # 多3个cell,先加第1个
                face_num = face_num + 1  # 多2个face,先加第1个

                # 完善以前face的左边cell
                Left_Cell_Index_new[AFT_stack[0][5] - 1] = cell_num  # 补充阵面的左单元

                ##新face数据结构######################与在figure——1-5.png中，是31-117相似
                Face_Node_Index_new.append(node1)
                Face_Node_Index_new.append(Pbest_num[0])
                Left_Cell_Index_new.append(cell_num + 1)
                Right_Cell_Index_new.append(cell_num)
                len_Right_Cell_Index_new = len(Right_Cell_Index_new)  # 测试用

                ##新face数据结构######################与在figure——1-5.png中，是31-117相似
                Face_Node_Index_new.append(Pbest_num[0])
                Face_Node_Index_new.append(node2)
                Left_Cell_Index_new.append(cell_num + 2)
                Right_Cell_Index_new.append(cell_num)
                len_Right_Cell_Index_new = len(Right_Cell_Index_new)  # 测试用

                # 完善以前原始阵面的左边1face（也是阵面);与30点-29点  相似
                mm1 = node1_nearby  # 找阵面第二点也就是右边那个点的右边相邻点
                node1_near_face_num = mm1[1]
                node1_near_node_num = mm1[0]
                Left_Cell_Index_new[node1_near_face_num - 1] = cell_num + 1  # 补充的左单元

                AFT_stack = tools.del_adv_elemnt(AFT_stack, node1_near_face_num)  # 删除以前的阵面

                # 完善以前原始阵面的左边2face（也是阵面);与30点-29点  相似
                mm1 = node1_node1_nearby  # 找阵面第二点也就是右边那个点的右边相邻点
                node1_near_face_num = mm1[1]
                node1_near_node_num = mm1[0]
                Left_Cell_Index_new[node1_near_face_num - 1] = cell_num + 1  # 补充的左单元

                AFT_stack = tools.del_adv_elemnt(AFT_stack, node1_near_face_num)  # 删除以前的阵面

                # 完善以前原始阵面的右边face（也是阵面);与30点-29点  相似
                mm1 = node2_nearby  # 找阵面第二点也就是右边那个点的右边相邻点
                node2_near_face_num = mm1[1]
                node2_near_node_num = mm1[0]
                Left_Cell_Index_new[node2_near_face_num - 1] = cell_num + 2  # 补充的左单元

                AFT_stack = tools.del_adv_elemnt(AFT_stack, node2_near_face_num)  # 删除以前的阵面
                # 完善以前原始阵面的右边临点的临点查找;31点-30点
                mm2 = node2_node2_nearby

                node2_near_face_num = mm2[1]
                node2_near_node_num = mm2[0]
                Left_Cell_Index_new[node2_near_face_num - 1] = cell_num + 2  # 补充的左单元

                AFT_stack = tools.del_adv_elemnt(AFT_stack, node2_near_face_num)  # 删除以前的阵面

                cell_num = cell_num + 2  # 多3个cell,先加第1个
                face_num = face_num + 1  # 多2个face,先加第1个

                # AFT_stack.remove(AFT_stack[0])  # 将刚开始弹出的最短阵面删除

                node0_node2_x = [Node_x_new[Pbest_num[0] - 1], Node_x_new[node1 - 1]]
                node0_node2_y = [Node_y_new[Pbest_num[0] - 1], Node_y_new[node1 - 1]]
                plt.plot(node0_node2_x, node0_node2_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')

                node0_node2_x = [Node_x_new[Pbest_num[0] - 1], Node_x_new[node2 - 1]]
                node0_node2_y = [Node_y_new[Pbest_num[0] - 1], Node_y_new[node2 - 1]]
                plt.plot(node0_node2_x, node0_node2_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')

                ccc = ccc + 1

                # AFT_stack = sorted(AFT_stack, key=lambda fff: fff[4])  # 按照第5个元素重新排序，让最短的阵面在



            elif Pbest_num[0] <= len(Node_x_new) - 1:  # 判断最优点是不是在阵面上，如果在，直接连接，如果不在，则直接走到else中去
                ccc = 1
                Node_x_new.pop()
                Node_y_new.pop()
                cell_num = cell_num + 1  # 多一个cell
                face_num = face_num + 1  # 多两个face,先加第一个

                Left_Cell_Index_new[AFT_stack[0][5] - 1] = cell_num  # 补充阵面的左单元

                ##更新face数据结构######################
                Face_Node_Index_new.append(Pbest_num[0])
                Face_Node_Index_new.append(node2)
                Left_Cell_Index_new.append(-1)
                Right_Cell_Index_new.append(cell_num)
                len_Right_Cell_Index_new = len(Right_Cell_Index_new)
                ##########更新活动阵面数据结构######################
                len_aft = len(AFT_stack)
                AFT_stack.append([])
                len_aft = len(AFT_stack)
                AFT_stack[len_aft - 1].append(Pbest_num[0])
                AFT_stack[len_aft - 1].append(node2)
                AFT_stack[len_aft - 1].append(-1)  # -1
                AFT_stack[len_aft - 1].append(cell_num)  # 0.边界face的右边单元为0
                AFT_stack[len_aft - 1].append(len_node2node(Pbest_num[0], node2))  # 边界face的右边单元为0
                AFT_stack[len_aft - 1].append(face_num)  # 把编号存进去，因为后期会被打乱，所以存入编号

                face_num = face_num + 1  # 多两个face,在更新另一个face信息，以及相应的阵面信息

                ##更新face数据结构######################
                Face_Node_Index_new.append(node1)
                Face_Node_Index_new.append(Pbest_num[0])
                Left_Cell_Index_new.append(-1)
                Right_Cell_Index_new.append(cell_num)
                len_Right_Cell_Index_new = len(Right_Cell_Index_new)
                ##########更新活动阵面数据结构######################
                len_aft = len(AFT_stack)
                AFT_stack.append([])
                len_aft = len(AFT_stack)
                AFT_stack[len_aft - 1].append(node1)
                AFT_stack[len_aft - 1].append(Pbest_num[0])
                AFT_stack[len_aft - 1].append(-1)  # -1
                AFT_stack[len_aft - 1].append(cell_num)  # 0.边界face的右边单元为0
                AFT_stack[len_aft - 1].append(len_node2node(node1, Pbest_num[0]))  # 边界face的右边单元为0
                AFT_stack[len_aft - 1].append(face_num)  # 把编号存进去，因为后期会被打乱，所以存入编号

                # AFT_stack.remove(AFT_stack[0])  # 删除最短阵面

                node0_node2_x = [Node_x_new[Pbest_num[0] - 1], Node_x_new[node1 - 1]]
                node0_node2_y = [Node_y_new[Pbest_num[0] - 1], Node_y_new[node1 - 1]]
                plt.plot(node0_node2_x, node0_node2_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')

                node0_node2_x = [Node_x_new[Pbest_num[0] - 1], Node_x_new[node2 - 1]]
                node0_node2_y = [Node_y_new[Pbest_num[0] - 1], Node_y_new[node2 - 1]]
                plt.plot(node0_node2_x, node0_node2_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')

                ccc = ccc + 1

                # AFT_stack = sorted(AFT_stack, key=lambda fff: fff[4])  # 按照第5个元素重新排序，让最短的阵面在

            else:

                style_new_node = 2  # 后面要写成函数，现在暂时
                # 因为此种状态不生成新点，所以需要把为了上次循环处理方便，加进去的点的坐标处理干净
                new_node_x_last = Node_x_new[Pbest_num[0] - 1]
                new_node_y_last = Node_y_new[Pbest_num[0] - 1]

                Node_x_new.pop()
                Node_y_new.pop()

                cell_num = cell_num + 1  # 多一个cell
                face_num = face_num + 1  # 多两个face,先加第一个

                node_num = len(Node_x_new) + 1  # 新点序号

                Node_x_new.append(new_node_x_last)
                Node_y_new.append(new_node_y_last)

                Left_Cell_Index_new[AFT_stack[0][5] - 1] = cell_num  # 补充阵面的左单元
                ##更新face数据结构######################
                Face_Node_Index_new.append(node1)
                Face_Node_Index_new.append(node_num)
                Left_Cell_Index_new.append(-1)
                Right_Cell_Index_new.append(cell_num)
                len_Right_Cell_Index_new = len(Right_Cell_Index_new)
                ##########更新活动阵面数据结构######################
                len_aft = len(AFT_stack)
                AFT_stack.append([])
                len_aft = len(AFT_stack)
                AFT_stack[len_aft - 1].append(node1)
                AFT_stack[len_aft - 1].append(node_num)
                AFT_stack[len_aft - 1].append(-1)  # -1
                AFT_stack[len_aft - 1].append(cell_num)  # 0.边界face的右边单元为0
                AFT_stack[len_aft - 1].append(len_node2node(node1, node_num))  # 边界face的右边单元为0
                AFT_stack[len_aft - 1].append(face_num)  # 把编号存进去，因为后期会被打乱，所以存入编号

                face_num = face_num + 1  # 多两个face

                ##更新face2数据结构######################
                Face_Node_Index_new.append(node_num)
                Face_Node_Index_new.append(node2)
                Left_Cell_Index_new.append(-1)
                Right_Cell_Index_new.append(cell_num)
                len_Right_Cell_Index_new = len(Right_Cell_Index_new)
                ##########更新活动阵面数据结构######################
                AFT_stack.append([])
                len_aft = len(AFT_stack)
                AFT_stack[len_aft - 1].append(node_num)
                AFT_stack[len_aft - 1].append(node2)
                AFT_stack[len_aft - 1].append(-1)  # -1
                AFT_stack[len_aft - 1].append(cell_num)  # 0.边界face的右边单元为0
                AFT_stack[len_aft - 1].append(len_node2node(node_num, node2))  # 边界face的右边单元为0
                AFT_stack[len_aft - 1].append(face_num)  # 把编号存进去，因为后期会被打乱，所以存入编号

                # AFT_stack.remove(AFT_stack[0])  # 删除最短阵面
                # AFT_stack1 = sorted(AFT_stack, key=lambda fff: fff[5])  #测试代码

                # plt.show()   #用于显示，为了加快仿真，采用上方的保存方式，免得出现后去关闭
                # display()
                node1_new_node_x = [Node_x_new[node1 - 1], new_node_x_last]
                node1_new_node_y = [Node_y_new[node1 - 1], new_node_y_last]
                new_node_node2_x = [new_node_x_last, Node_x_new[node2 - 1]]
                new_node_node2_y = [new_node_y_last, Node_y_new[node2 - 1]]
                plt.plot(node1_new_node_x, node1_new_node_y, 'g-s', linewidth=2, color='b', markerfacecolor='b',
                         marker='o')
                plt.plot(new_node_node2_x, new_node_node2_y, 'g-s', linewidth=2, color='b', markerfacecolor='b',
                         marker='o')

                # AFT_stack = sorted(AFT_stack, key=lambda fff: fff[4])  # 按照第5个元素重新排序，让最短的阵面在最上方
                ccc = ccc + 1



    elif model == 2:  # 2为右边点连接答案点，不生成新点，将阵面第二点与第0点连接，作为答案点，生成新一条阵面，更改数据结构
        if eee != ddd:
            aaa = 2
            cell_num = cell_num + 1  # 多一个cell
            face_num = face_num + 1  # 多1个face,

            # 完善以前face的左边cell
            Left_Cell_Index_new[AFT_stack[0][5] - 1] = cell_num  # 补充阵面的左单元
            Left_Cell_Index_new[
                node2_nearby[1] - 1] = cell_num  # 补充node2-node3face的左单元，node1_nearby_adv函数返回两个值，第2个是face编号

            ##新face数据结构######################
            Face_Node_Index_new.append(node1)
            Face_Node_Index_new.append(node3)
            Left_Cell_Index_new.append(-1)
            Right_Cell_Index_new.append(cell_num)
            len_Right_Cell_Index_new = len(Right_Cell_Index_new)  # 测试用
            ##########更新活动阵面数据结构######################
            len_aft = len(AFT_stack)
            AFT_stack.append([])
            len_aft = len(AFT_stack)
            AFT_stack[len_aft - 1].append(node1)
            AFT_stack[len_aft - 1].append(node3)
            AFT_stack[len_aft - 1].append(-1)  # -1
            AFT_stack[len_aft - 1].append(cell_num)  # 0.边界face的右边单元为0
            AFT_stack[len_aft - 1].append(len_node2node(node1, node3))  # 边界face的右边单元为0
            AFT_stack[len_aft - 1].append(face_num)  # 把编号存进去，因为后期会被打乱，所以存入编号

            mm = node2_nearby[1]
            # AFT_stack[0][0]表示阵面的0个行第0个元素，也就是输入神经网络的node1，
            # 通过送到node1_nearby_adv，返回的【1】为face号,在阵面中删除这个face号的信息，因为为非活动阵面
            AFT_stack = tools.del_adv_elemnt(AFT_stack, mm)
            # AFT_stack.remove(AFT_stack[0])  # 将刚开始弹出的最短阵面删除

            node1_node3_x = [Node_x_new[node1 - 1], Node_x_new[node3 - 1]]
            node1_node3_y = [Node_y_new[node1 - 1], Node_y_new[node3 - 1]]
            plt.plot(node1_node3_x, node1_node3_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')

            ccc = ccc + 1

            # AFT_stack = sorted(AFT_stack, key=lambda fff: fff[4])  # 按照第5个元素重新排序，让最短的阵面在最上方
        else:  # 4个点组成一个连通域，属于特殊情况
            cell_num = cell_num + 1  # 多两个cell，这里暂时先加第一个
            face_num = face_num + 1  # 多1个face,除了自己本身不生成阵面，还得少4个阵面

            # 完善以前face的左边cell
            Left_Cell_Index_new[AFT_stack[0][5] - 1] = cell_num  # 补充阵面的左单元

            if numk == 1052:
                ggg = 1
                FFF = node2_nearby[0]

                BBB = node2_nearby[1]
                AAA = Left_Cell_Index_new[node2_nearby[1] - 1]

            Left_Cell_Index_new[
                node2_nearby[1] - 1] = cell_num  # 补充node0-node1face的左单元，node1_nearby_adv函数返回两个值，第2个是face编号

            CCC = Left_Cell_Index_new[
                node1_nearby[1] - 1]
            ##新face数据结构######################
            Face_Node_Index_new.append(node1)
            Face_Node_Index_new.append(node3)
            Left_Cell_Index_new.append(cell_num + 1)  # 因为4点构成封闭连通域，face 的左边已经构成一个新的cell
            Right_Cell_Index_new.append(cell_num)
            len_Right_Cell_Index_new = len(Right_Cell_Index_new)  # 测试用

            # 新的face不生成活动阵面
            cell_num = cell_num + 1  # 多两个cell，这里加第2个
            left_node = node1_nearby
            left_node1 = left_node[1]  # 临点face编号
            left_node1_point = left_node[0]  # 临点点号
            Left_Cell_Index_new[left_node1 - 1] = cell_num  #
            left_node2 = node1_node1_nearby[1]
            Left_Cell_Index_new[left_node2 - 1] = cell_num  #
            # 删除4个阵面
            # AFT_stack[0][0]表示阵面的0个行第0个元素，也就是输入神经网络的node1，通过送到node1_nearby_adv，返回的【1】为face号,
            mm = node2_nearby[1]
            AFT_stack = tools.del_adv_elemnt(AFT_stack, mm)  # 删除0-1点的阵面
            AFT_stack = tools.del_adv_elemnt(AFT_stack, left_node1)  # 删除2-3点的阵面
            AFT_stack = tools.del_adv_elemnt(AFT_stack, left_node2)  # 删除3-0点的阵面

            # AFT_stack.remove(AFT_stack[0])  # 将刚开始弹出的最短阵面删除

            node0_node2_x = [Node_x_new[node1 - 1], Node_x_new[node3 - 1]]
            node0_node2_y = [Node_y_new[node1 - 1], Node_y_new[node3 - 1]]
            plt.plot(node0_node2_x, node0_node2_y, 'g-s', linewidth=2, color='b', markerfacecolor='b', marker='o')
            ccc = ccc + 1

            # AFT_stack = sorted(AFT_stack, key=lambda fff: fff[4])  # 按照第5个元素重新排序，让最短的阵面在最上方
    else:
        print ("error=", model)

k = ' '
# 参考 https://blog.csdn.net/u010305706/article/details/47837861
jg = open(r'../grid/J10/TEXT_20191129_j10.txt', 'w+')
jg.truncate()  # 清空文件
jg.write('Zone 1  Number of Nodes: ' + str(len(Node_x_new)) + '\n')
for i in range(len(Node_x_new)):
    jg.write(str(Node_x_new[i]) + k + str(Node_y_new[i]) + '\n')

jg.write('Zone 2  Number of Face: ' + str(len(Left_Cell_Index_new)) + '\n')
for i in range(len(Left_Cell_Index_new)):
    if i < Number_of_Boundary_Faces:
        jg.write(str(Left_Cell_Index_new[i]) + k + str(Right_Cell_Index_new[i]) + k + str(
            Face_Node_Index_new[2 * i + 1]) + k + str(Face_Node_Index_new[2 * i]) + '\n')
    else:

        jg.write(str(Left_Cell_Index_new[i]) + k + str(Right_Cell_Index_new[i]) + k + str(
            Face_Node_Index_new[2 * i]) + k + str(Face_Node_Index_new[2 * i + 1]) + '\n')


jg.close()
print ("THE END")
print ("THE END")
