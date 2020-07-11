clear;clc;
gridName       = '../inv_cylinder/quad/inv_cylinder_quad.cas'
fileName       = '../inv_cylinder/quad/cy-q28.mat'
% gridName       = 'f:/ANN_Grid/grid/naca0012/naca0012-quad.cas'
% fileName       = 'f:/ANN_Grid/grid/naca0012/naca-q5.mat'
% gridName       = '../naca0012/tri/naca0012-tri-quadBC.cas'
% fileName       = '../naca0012/tri/naca0012-tri-quadBC.mat'

gridType       = 1;    % 0-��һ��Ԫ����1-��ϵ�Ԫ����
stencilType    = 'all'; % random-ֻ���ȡһ�֣�%all-ȡ���п���
targetType     = 2;     %1-1��Ŀ��㣻2-2��Ŀ���
mode           = 4;     % 0-ֻ���4��������ꣻ1-�����׼�浽����ľ��룻2-�����׼�泤�ȣ�3-�����׼����ˮƽ��нǣ�4-�������
perturb        = 1;
[input,target] = data_extraction_fun(gridName, gridType, fileName, stencilType, targetType, mode, perturb);
