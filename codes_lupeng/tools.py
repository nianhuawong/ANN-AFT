# #coding:utf-8
import numpy as np
import math
from matplotlib.pyplot import annotate


class point():
    def __init__(self, x, y):
        self.x = x
        self.y = y


def cross(p1, p2, p3):  # 跨立实验
    x1 = p2.x - p1.x
    y1 = p2.y - p1.y
    x2 = p3.x - p1.x
    y2 = p3.y - p1.y
    return x1 * y2 - x2 * y1


def IsIntersec(p1, p2, p3, p4):  # 判断两线段是否相交
    # 快速排斥，以l1、l2为对角线的矩形必相交，否则两线段不相交
    if (max(p1.x, p2.x) >= min(p3.x, p4.x)  # 矩形1最右端大于矩形2最左端
            and max(p3.x, p4.x) >= min(p1.x, p2.x)  # 矩形2最右端大于矩形最左端
            and max(p1.y, p2.y) >= min(p3.y, p4.y)  # 矩形1最高端大于矩形最低端
            and max(p3.y, p4.y) >= min(p1.y, p2.y)):  # 矩形2最高端大于矩形最低端

        # 若通过快速排斥则进行跨立实验
        if cross(p1, p2, p3) * cross(p1, p2, p4) <= 0 and cross(p3, p4, p1) * cross(p3, p4, p2) <= 0:
            if (p1.x != p3.x and p1.y != p3.y) and (p1.x != p4.x and p1.y != p4.y) and (
                    p2.x != p3.x and p2.y != p3.y) and (p2.x != p4.x and p2.y != p4.y):
                D = 1  # 对于端点来说,所有点不相等才是算相交
            else:
                D = 0

        else:
            D = 0
    else:
        D = 0  # 相交为1，不相交为0
    return D


def Translation(x, y, x0, y0):  # x,y表示要任何要平移的点，x0，y0表示将以何点为圆心作为参考点
    x_new = x - x0
    y_new = y - y0
    return [x_new, y_new]


def Anti_Translation(x, y, x0, y0):  # x,y表示要任何要anti平移的点，x0，y0表示将以何点为圆心作为参考点
    x_new = x + x0
    y_new = y + y0
    return [x_new, y_new]


# 缩放函数，归一化处理x_start,y_start,x_end,y_end,x,y分别表示坐标系x轴起点与终点坐标值，xy为任意需要变换的点
def Scaling(x_start, y_start, x_end, y_end, x, y):  # 注意xy是经过平移的点
    len = math.sqrt(((x_end - x_start) ** 2) + ((y_end - y_start) ** 2))
    x_new = (1 / len) * x
    y_new = (1 / len) * y
    return [x_new, y_new]


def Anti_Scaling(x_start, y_start, x_end, y_end, x, y):  # 注意xy是经过反旋转的的点
    len = math.sqrt(((x_end - x_start) ** 2) + ((y_end - y_start) ** 2))
    x_new = (len) * x
    y_new = (len) * y
    return [x_new, y_new]


def Rotation(x_end, y_end, x_rot, y_rot):  # x_end,y_end为第一步平移后face另外一个点的值以便求与全局坐标系求夹角ceta，
    # xrot yrot为任意需要旋转的坐标
    # 相当于勾股定理，求得斜线的长度
    x = np.array([x_end, y_end])  # 向量1  x'
    y = np.array([1, 0])  # 全局坐标系x
    # jj = x.dot(x)  # 向量点乘
    Lx = np.sqrt(x.dot(x))  # 向量点乘
    Ly = np.sqrt(y.dot(y))  # 向量点乘
    # kk = x.dot(y)  # 向量点乘
    cos_angle = x.dot(y) / (Lx * Ly)
    sin_angle = y_end / (Lx * Ly)
    # 说明https://zhidao.baidu.com/question/1705964907383367940.html
    x_new = round(cos_angle * x_rot + sin_angle * y_rot, 2)
    y_new = round(-sin_angle * x_rot + cos_angle * y_rot, 2)
    return [x_new, y_new]


def Anti_Rotation(x_end, y_end, x_rot, y_rot):  # x_end,y_end为第一步平移后face另外一个点的值以便求与全局坐标系求夹角ceta，x_rot,y_rot是需要反旋转的量
    # xrot yrot为任意需要旋转的坐标
    # 相当于勾股定理，求得斜线的长度
    x = np.array([x_end, y_end])  # 向量1  x'
    y = np.array([1, 0])  # 全局坐标系x
    Lx = np.sqrt(x.dot(x))  # 向量点乘
    Ly = np.sqrt(y.dot(y))  # 向量点乘
    cos_angle = x.dot(y) / (Lx * Ly)
    sin_angle = y_end / (Lx * Ly)
    # 说明https://zhidao.baidu.com/question/1705964907383367940.html
    x_new = round(cos_angle * x_rot - sin_angle * y_rot, 2)
    y_new = round(sin_angle * x_rot + cos_angle * y_rot, 2)

    return [x_new, y_new]


def nearby_combine(node1x, node1y, R, node2x, node2y):  # 判断node2x,node2y是不是在以node1x,node1y为圆心,R为半径的圆以内，是返回1，不是返回0
    if (node2x - node1x) ** 2 + (node2y - node1y) ** 2 < R:
        return 1
    else:
        return 0


def node_num_display(Node_x_new, Node_y_new):
    x = np.array(Node_x_new)
    y = np.array(Node_y_new)
    i = 0
    for a, b in zip(x, y):
        i = i + 1
        # annotate('%s' % (i), xy=(a, b), color='k', xytext=(0, 0), textcoords='offset points')
    c = 0
    # https://blog.csdn.net/you_are_my_dream/article/details/53454549


def getangle(x1, y1, x2, y2):
    epsilon = 0.000001
    nyPI = math.acos(-1.0)
    dist = math.sqrt(x1 * x1 + y1 * y1)
    x1 /= dist
    y1 /= dist
    dist = math.sqrt(x2 * x2 + y2 * y2)
    x2 /= dist
    y2 /= dist

    # dot    product
    dot = x1 * x2 + y1 * y2
    if abs(dot - 1.0) <= epsilon:
        angle = 0.0
    elif abs(dot + 1.0) <= epsilon:
        angle = nyPI
    else:
        angle = math.acos(dot)

        cross = x1 * y2 - x2 * y1

        if (cross < 0):
            angle = 2 * nyPI - angle

    degree1 = angle * 180.0 / nyPI
    degree = 360 - degree1
    return degree


def del_adv_elemnt(adv, elemnt):  # 删除阵面中，第5个元素（face编号），删除阵面堆栈中的非活跃边，通过编号收缩取去删除
    two_len = len(adv)
    flag = 0
    for i in range(two_len):
        if adv[i][5] == elemnt:
            adv.remove(adv[i])
            flag = 1
            break
    if flag == 0:
        print("没有要删除的阵面")
    return adv


def Triangle_Quality_Judgment(x1, y1, x2, y2, x3, y3):
    a = float(math.sqrt((x2 - x3) ** 2 + (y2 - y3) ** 2))
    b = float(math.sqrt((x1 - x3) ** 2 + (y1 - y3) ** 2))
    c = float(math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2))
    if y1 == y2 and y2 == y3:  # 三个点在一条直线的情况
        Q = 0.0001
    else:
        s = (a + b + c) / 2  # 半周长
        S = (s * (s - a) * (s - b) * (s - c))  # 面积，海伦公式
        if S == 0:
            S = 0.001
        if S < 0:
            S = 0.001
        S = S ** 0.5  # 面积，海伦公式
        r = S / s  # 参考https://blog.csdn.net/fourierFeng/article/details/14000915
        R = a * b * c / (4 * S)
        Q = r / R
    return Q


def node_aft_len(p, a, b):  # p表示候选点，a表示临近阵面第一点，b表示临近阵面第二点，下面的b.x,b.y属于向量表示
    abx = b.x - a.x
    aby = b.y - a.y
    apx = p.x - a.x
    apy = p.y - a.y
    len_ab = abx * abx + aby * aby  # 线段ab的长度的平方
    len_pa = math.sqrt((apx ** 2) + (apy ** 2))
    len_pb = math.sqrt(((p.x - b.x) ** 2) + ((p.y - b.y) ** 2))
    t = abx * apx + aby * apy
    t = t / len_ab
    if t <= 0:
        return len_pa
    if t >= 1:
        return len_pb
    if 0 < t < 1:
        ap = np.array([apx, apy, 0])
        ab = np.array([abx, aby, 0])

        len_ac = np.linalg.norm(np.cross(ap, ab) / np.linalg.norm(ab))  # 求垂线距离
        return len_ac


def judge(a, b, c, d):
    if min(a[0], b[0]) <= max(c[0], d[0]) and min(c[1], d[1]) <= max(a[1], b[1]) and min(c[0], d[0]) <= max(a[0], b[
        0]) and min(a[1], b[1]) <= max(c[1], d[1]):
        if a != c and a != d and b != c and b != d:
            return 1
        else:
            return 0
    else:
        return 0
