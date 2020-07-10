clear;close all;
tic
format long
%%
gridType    = 1;        % 0-��һ��Ԫ����1-��ϵ�Ԫ����
Sp          = 1;      % ���񲽳�  % Sp = sqrt(3.0)/2.0;  %0.866
al          = 3.0;      % �ڼ�����Χ������
coeff       = 0.6;      % ����ѡ�����е�Ĳ�����Pbest����������ϵ��
outGridType = 0;        % 0-����ͬ������1-������������
dt          = 0.0001;   % ��ͣʱ��
stencilType = 'random';
nn_fun = @net_cylinder_quad5;
% nn_fun = @net_naca0012_quad;
%%
[AFT_stack,Coord,Grid]  = read_grid('../grid/inv_cylinder/quad/inv_cylinder_quad.cas', gridType);
% [AFT_stack,Coord,~]  = read_grid('../grid/naca0012/tri/naca0012-tri-quadBC.cas', gridType);
%%
nodeList = AFT_stack(:,1:2);
node_num = max( max(nodeList)-min(nodeList)+1 );%�߽��ĸ��������ߣ���ʼ�������
xCoord_AFT = Coord(1:node_num,1);                %��ʼ���������
yCoord_AFT = Coord(1:node_num,2);

PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);

%%
% ѡ����С���棬����Pbest
nCells_AFT = 0;
nCells_quad = 0;
nCells_tri = 0;
Grid_stack = [];
node_best = node_num;     %��ʼʱ��ѵ�Pbest�����

%%  �Ƚ��߽������ƽ�
for i =1:size(AFT_stack,1)
    AFT_stack(i,5) = 0.00001* AFT_stack(i,5);
%     AFT_stack(i,5) = 1E5* AFT_stack(i,5);
end
%%
AFT_stack_sorted = sortrows(AFT_stack, 5);
% AFT_stack_sorted = AFT_stack_sorted(end:-1:1,:);
% AFT_stack_sorted = sortrows(AFT_stack, 5, 'descend');
%%
while size(AFT_stack_sorted,1)>0
    Sp = StepSize(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Grid);
    
    %%
    %���������ı��Σ�������ɵ��ı�������̫����������������� 
    size0 = size(AFT_stack_sorted,1);
    %%
    if nCells_AFT ==390
        kkk = 1;
    end  
    %%
    [node_select,coordX, coordY, flag_best] = GenerateQuads(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun, stencilType);
    if sum(node_select) ~= -2
        xCoord_AFT = [xCoord_AFT;coordX];
        yCoord_AFT = [yCoord_AFT;coordY];
        node_best = node_best + sum(flag_best);
        
        tmp = nCells_AFT;
        [AFT_stack_sorted,nCells_AFT] = UpdateQuadCells(AFT_stack_sorted, nCells_AFT, outGridType, xCoord_AFT, yCoord_AFT, node_select, flag_best); 
        
        nCells_quad = nCells_quad + nCells_AFT - tmp;
        
    elseif sum(node_select) == -2            
        [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun, stencilType);
        
        while node_select == -1 
            al = 2 * al;
            [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun, stencilType);
        end
        
        if( flag_best == 1 )
            xCoord_AFT = [xCoord_AFT;coordX];
            yCoord_AFT = [yCoord_AFT;coordY];
            node_best = node_best + 1;
        end  
            tmp = nCells_AFT;
            [AFT_stack_sorted,nCells_AFT] = UpdateTriCells(AFT_stack_sorted, nCells_AFT, xCoord_AFT, yCoord_AFT, node_select, flag_best);     
            nCells_tri = nCells_tri + nCells_AFT - tmp;
    end

    %% ==============================================
    size1 = size(AFT_stack_sorted,1);
    PLOT_NEW_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, size1-size0);
    pause(dt);
    hold on;

    interval = 100;
    if(mod(nCells_AFT,interval)==0)
        disp('================================');
        disp('==========�ƽ�������...==========');
        disp(['nCells = ', num2str(nCells_AFT)]);
        disp(['nCells_quad = ', num2str(nCells_quad)]);
        disp(['nCells_tri  = ', num2str(nCells_tri)]);
        disp(['����ʵʱ���ȣ�', num2str(size(AFT_stack_sorted,1))]);
        disp(['������������',num2str(size1-size0)]);
    end
    %%
    %�ҳ��ǻ�Ծ���棬��ɾ��
    [AFT_stack_sorted, Grid_stack] = DeleteInactiveFront(AFT_stack_sorted, Grid_stack);

    AFT_stack_sorted = sortrows(AFT_stack_sorted, 5);
%     AFT_stack_sorted = AFT_stack_sorted(end:-1:1,:);
    % AFT_stack_sorted = sortrows(AFT_stack, 5, 'descend');
end
disp(['�����ƽ���ɣ���Ԫ����', num2str(nCells_AFT)]);
disp(['�����ƽ���ɣ�quad��Ԫ����', num2str(nCells_quad)]);
disp(['�����ƽ���ɣ�tri��Ԫ����', num2str(nCells_tri)]);
disp(['�����ƽ���ɣ��ڵ�����', num2str(length(xCoord_AFT))]);
disp(['�����ƽ���ɣ��������', num2str(size(Grid_stack,1))]);
toc








