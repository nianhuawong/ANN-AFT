clear;clc;
gridName       = './inv_cylinder/inv_cylinder.cas'
fileName       = './inv_cylinder/cy.mat'
gridType       = 0;    % 0-��һ��Ԫ����1-��ϵ�Ԫ����
stencilType    = 'all'; % random-ֻ���ȡһ�֣�%all-ȡ���п���
mode           = 0;     % 0-ֻ���4��������ꣻ1-�����׼�浽����ľ��룻2-�����׼�泤�ȣ�3-�����׼����ˮƽ��н�;
perturb        = 0;
[input,target] = data_extraction_fun(gridName, gridType, fileName, stencilType, mode, perturb);
