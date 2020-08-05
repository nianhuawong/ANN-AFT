clear;clc;
% gridName       = '../inv_cylinder/tri/inv_cylinder-20.cas'
% fileName       = '../inv_cylinder/tri/inv_cylinder-20.mat'
% gridName       = '../inv_cylinder/quad/inv_cylinder_quad3.cas'
% fileName       = '../inv_cylinder/tri/inv_cylinder_quad.mat'
% gridName       = 'f:/ANN_Grid/grid/naca0012/tri/naca0012-tri-quadBC.cas'
% fileName       = 'f:/ANN_Grid/grid/naca0012/tri/naca.mat'
% gridName       = '../airfoil-training/quad/naca0012-quad.cas'
% fileName       = '../airfoil-training/quad/naca0012-q5.mat'
gridName       = '../airfoil-training/tri-fine/naca0012-fine.cas'
fileName       = '../airfoil-training/tri-fine/naca0012-t.mat'
global standardlize;
gridType       = 0;    % 0-单一单元网格，1-混合单元网格
stencilType    = 'all'; % random-只随机取一种；%all-取所有可能
targetType     = 1;     %1-1个目标点；2-2个目标点
standardlize   = 1;     %是否进行归一化
mode           = 4;     % 0-只输出4个点的坐标；1-输出基准面到物面的距离；2-输出基准面长度；3-输出基准面与水平面夹角；4-输出步长
perturb        = 0;
[input,target] = data_extraction_fun(gridName, gridType, fileName, stencilType, targetType, mode, perturb);

% frame = getframe(1,[400 100 1200 800]);
% im = frame2im(frame);
% imwrite(im,'mesh.png');