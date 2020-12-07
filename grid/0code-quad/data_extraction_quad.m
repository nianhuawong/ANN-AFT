clc;clear;
% gridName       = '../inv_cylinder/tri/inv_cylinder-40.cas'
% fileName       = '../inv_cylinder/tri/inv_cylinder-40.mat'
% gridName       = '../inv_cylinder/quad/inv_cylinder_quad3.cas'
% fileName       = '../inv_cylinder/tri/inv_cylinder_quad.mat'
% gridName       = 'f:/ANN_Grid/grid/naca0012/tri/naca0012-tri.cas'
% fileName       = 'f:/ANN_Grid/grid/naca0012/tri/naca0012-tri.mat'
gridName       = '../naca0012/quad/naca0012-quad-quadBC.cas'
fileName       = '../naca0012/quad/naca0012-quad-quadBC.mat'
% gridName       = '../airfoil-training/quad/naca0012-quad.cas'
% fileName       = '../airfoil-training/quad/naca0012-q5.mat'
% gridName       = '../airfoil-training/tri-fine/naca0012-fine.cas'
% fileName       = '../airfoil-training/tri-fine/naca0012-t.mat'
% gridName       = '../airfoil-training/tri/naca0012.cas'
% fileName       = '../airfoil-training/tri/naca0012.mat'

global standardlizeCoord standardlizeSp;
standardlizeCoord = 1;     %坐标是否进行归一化
standardlizeSp    = 0;     %Sp是否归一化
gridType          = 1;    % 0-单一单元网格，1-混合单元网格
stencilType       = 'all'; % random-只随机取一种；%all-取所有可能
targetType        = 2;     %1-1个目标点；2-2个目标点
mode              = 5;     % 0-只输出4个点的坐标；1-输出基准面到物面的距离；2-输出基准面长度；3-输出基准面与水平面夹角；4-输出步长
perturb           = 0;
[input,target] = data_extraction_fun(gridName, gridType, fileName, stencilType, targetType, mode, perturb);

% frame = getframe(1,[400 100 1200 800]);
% im = frame2im(frame);
% imwrite(im,'mesh.png');