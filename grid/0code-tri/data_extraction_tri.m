clear;clc;
gridName       = './inv_cylinder/inv_cylinder.cas'
fileName       = './inv_cylinder/cy.mat'
gridType       = 0;    % 0-单一单元网格，1-混合单元网格
stencilType    = 'all'; % random-只随机取一种；%all-取所有可能
mode           = 0;     % 0-只输出4个点的坐标；1-输出基准面到物面的距离；2-输出基准面长度；3-输出基准面与水平面夹角;
perturb        = 0;
[input,target] = data_extraction_fun(gridName, gridType, fileName, stencilType, mode, perturb);
