clear;clc;
gridName       = '../inv_cylinder/quad/inv_cylinder_quad.cas'
fileName       = '../inv_cylinder/quad/cy-q28.mat'
% gridName       = 'f:/ANN_Grid/grid/naca0012/naca0012-quad.cas'
% fileName       = 'f:/ANN_Grid/grid/naca0012/naca-q5.mat'
% gridName       = '../naca0012/tri/naca0012-tri-quadBC.cas'
% fileName       = '../naca0012/tri/naca0012-tri-quadBC.mat'

gridType       = 1;    % 0-单一单元网格，1-混合单元网格
stencilType    = 'all'; % random-只随机取一种；%all-取所有可能
targetType     = 2;     %1-1个目标点；2-2个目标点
mode           = 4;     % 0-只输出4个点的坐标；1-输出基准面到物面的距离；2-输出基准面长度；3-输出基准面与水平面夹角；4-输出步长
perturb        = 1;
[input,target] = data_extraction_fun(gridName, gridType, fileName, stencilType, targetType, mode, perturb);
