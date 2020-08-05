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
gridType       = 0;    % 0-��һ��Ԫ����1-��ϵ�Ԫ����
stencilType    = 'all'; % random-ֻ���ȡһ�֣�%all-ȡ���п���
targetType     = 1;     %1-1��Ŀ��㣻2-2��Ŀ���
standardlize   = 1;     %�Ƿ���й�һ��
mode           = 4;     % 0-ֻ���4��������ꣻ1-�����׼�浽����ľ��룻2-�����׼�泤�ȣ�3-�����׼����ˮƽ��нǣ�4-�������
perturb        = 0;
[input,target] = data_extraction_fun(gridName, gridType, fileName, stencilType, targetType, mode, perturb);

% frame = getframe(1,[400 100 1200 800]);
% im = frame2im(frame);
% imwrite(im,'mesh.png');