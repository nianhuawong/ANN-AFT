clear;clc;close all;tic;format long;
%%
global num_label flag_label cellNodeTopo epsilon;
gridType    = 0;        % 0-��һ��Ԫ����1-��ϵ�Ԫ����
Sp          = 1.0;      % ���񲽳�  % Sp = sqrt(3.0)/2.0;  %0.866         
al          = 3.0;      % �ڼ�����Χ������
coeff       = 0.9;      % ����ѡ�����е�Ĳ�����Pbest����������ϵ��
epsilon     = 1.49;
dt          = 0.00001;   % ��ͣʱ��
stencilType = 'all';
outGridType = 0;        % 0-����ͬ������1-������������
nn_fun = @net_naca0012_tri; %net_naca0012_quadBC_c;net_naca0012_tri_fine;net_airfoil_quadBC;net_rae2822_tri;net_cylinder_tri
num_label   = 0;
flag_label  = zeros(1,10000);
cellNodeTopo = [];
%%
% [AFT_stack,Coord,~, wallNodes]  = read_grid('../grid/inv_cylinder/tri/inv_cylinder-30.cas', gridType);
% [AFT_stack,Coord,~, wallNodes]  = read_grid('../grid/simple/pentagon3.cas', gridType);
% [AFT_stack,Coord,~, wallNodes]  = read_grid('../grid/simple/tri.cas', gridType);
% [AFT_stack,Coord,~, wallNodes]  = read_grid('../grid/simple/quad_quad2.cas', gridType);
% [AFT_stack,Coord,~, wallNodes]  = read_grid('../grid/naca0012/tri/naca0012-tri-quadBC.cas', gridType);
% [AFT_stack,Coord,~, wallNodes]  = read_grid('../grid/airfoil-training/tri/naca0012.cas', gridType);
% [AFT_stack,Coord,~,wallNodes]  = read_grid('../grid/airfoil-training/tri/rae2822.cas', gridType);
[AFT_stack,Coord,~,wallNodes]  = read_grid('../grid/airfoil-training/tri/anw.cas', gridType);
nodeList = AFT_stack(:,1:2);
node_num = max( max(nodeList)-min(nodeList)+1 );%�߽��ĸ��������ߣ���ʼ�������
xCoord_AFT = Coord(1:node_num,1);                %��ʼ���������
yCoord_AFT = Coord(1:node_num,2);
PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);

%%
% ѡ����С���棬����Pbest
nCells_AFT = 0;
iFace = 1;
Grid_stack = [];
node_best = node_num;     %��ʼʱ��ѵ�Pbest�����

%%  �Ƚ��߽������ƽ�
for i =1:size(AFT_stack,1)
    if AFT_stack(i,7) == 3      
         AFT_stack(i,5) = 0.00001* AFT_stack(i,5);  
    else
%          AFT_stack(i,5) = 1e5* AFT_stack(i,5);
    end
end

% AFT_stack_sorted = AFT_stack; 
AFT_stack_sorted = sortrows(AFT_stack, 5); 

while size(AFT_stack_sorted,1)>0
    
    if nCells_AFT ==48
        kkk = 1;
    end
    
    size0 = size(AFT_stack_sorted,1);
   
    [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun, stencilType);
    
    while node_select == -1 %&& al < 5.0
        al = 1.2 * al;
        [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun, stencilType);
    end
    
    if node_select == -1 
        fprintf('�޷����ɵ㣡���򼴽�����');
        pause();
    end
    
    if( flag_best == 1 )
        xCoord_AFT = [xCoord_AFT;coordX];
        yCoord_AFT = [yCoord_AFT;coordY];
        node_best = node_best + 1;
    end
    [AFT_stack_sorted,nCells_AFT] = UpdateTriCells(AFT_stack_sorted, nCells_AFT, xCoord_AFT, yCoord_AFT, node_select, flag_best);
        
    size1 = size(AFT_stack_sorted,1);
    PLOT_NEW_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, size1-size0, flag_best);
    pause(dt);
    
    interval = 100;
    if(mod(nCells_AFT,interval)==0)
        disp('================================');
        disp('==========�ƽ�������...==========');
        disp(['nCells = ', num2str(nCells_AFT)]);
        disp(['����ʵʱ���ȣ�', num2str(size(AFT_stack_sorted,1))]);
        disp(['������������',num2str(size1-size0)]);
        toc;
    end
  %%  
  %�ҳ��ǻ�Ծ���棬��ɾ��
    [AFT_stack_sorted, Grid_stack] = DeleteInactiveFront(AFT_stack_sorted, Grid_stack);

    AFT_stack_sorted = sortrows(AFT_stack_sorted, 5);
end
disp(['�����ƽ���ɣ���Ԫ����', num2str(nCells_AFT)]);
disp(['�����ƽ���ɣ��ڵ�����', num2str(length(xCoord_AFT))]);
disp(['�����ƽ���ɣ��������', num2str(size(Grid_stack,1))]);
toc;
%%
DelaunayMesh(xCoord_AFT,yCoord_AFT,wallNodes);
toc

    
    






