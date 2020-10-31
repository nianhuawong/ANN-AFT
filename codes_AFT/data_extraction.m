clear;clc;close all;tic;format long;
%%
global num_label flag_label cellNodeTopo epsilon standardlize SpDefined countMode;
gridType    = 0;        % 0-��һ��Ԫ����1-��ϵ�Ԫ����
Sp          = 1.0;      % ���񲽳�  % Sp = sqrt(3.0)/2.0;  %0.866         
al          = 3.0;      % �ڼ�����Χ������
coeff       = 0.85;      % ����ѡ�����е�Ĳ�����Pbest����������ϵ��
epsilon     = 0.9;
dt          = 0.00001;   % ��ͣʱ��
stencilType = 'all';
outGridType = 0;        % 0-����ͬ������1-������������
nn_fun = @naca0012_20201030; %net_naca0012_quadBC_c;net_naca0012_tri_fine;net_airfoil_quadBC;net_rae2822_tri;net_cylinder_tri
num_label   = 0;
flag_label  = zeros(1,10000);
cellNodeTopo = [];
standardlize = 1;
SpDefined    = 1;   % 0-δ���岽����ֱ�Ӳ�������㣻1-�����˲����ļ���2-ANN����˲���
stepSizeFile = '../grid/inv_cylinder/tri/inv_cylinder-40.cas';
sizeFileType = 0;
%%
[AFT_stack,Coord, Grid, wallNodes]  = read_grid('../grid/inv_cylinder/tri/inv_cylinder-40.cas', gridType);
% [AFT_stack,Coord, Grid, wallNodes]  = read_grid('../grid/simple/pentagon3.cas', gridType);
% [AFT_stack,Coord, Grid, wallNodes]  = read_grid('../grid/simple/tri.cas', gridType);
% [AFT_stack,Coord, Grid, wallNodes]  = read_grid('../grid/simple/quad_quad2.cas', gridType);
% [AFT_stack,Coord, Grid, wallNodes]  = read_grid('../grid/naca0012/tri/naca0012-tri-quadBC.cas', gridType);
% [AFT_stack,Coord, Grid, wallNodes]  = read_grid('../grid/airfoil-training/tri/naca0012.cas', gridType);
% [AFT_stack,Coord, Grid,wallNodes]  = read_grid('../grid/airfoil-training/tri/rae2822.cas', gridType);
% [AFT_stack,Coord, Grid, wallNodes]  = read_grid('../grid/airfoil-training/tri/anw.cas', gridType);
nodeList = AFT_stack(:,1:2);
node_num = max( max(nodeList)-min(nodeList)+1 );%�߽��ĸ��������ߣ���ʼ�������
xCoord_AFT = Coord(1:node_num,1);                %��ʼ���������
yCoord_AFT = Coord(1:node_num,2);
% PLOT(Grid, Coord(:,1), Coord(:,2));
% pause();
PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);

%%
% ѡ����С���棬����Pbest
nCells_AFT = 0;
iFace = 1;
Grid_stack = [];
node_best = node_num;     %��ʼʱ��ѵ�Pbest�����

%%  �Ƚ��߽������ƽ�
for i =1:size(AFT_stack,1)
%     if AFT_stack(i,7) == 3      
         AFT_stack(i,5) = 0.00001* AFT_stack(i,5);  
%     else
%          AFT_stack(i,5) = 1e5* AFT_stack(i,5);
%     end
end

if SpDefined == 1
    [SpField, backGrid, backCoord] = StepSizeField(stepSizeFile, sizeFileType);
end

% AFT_stack_sorted = AFT_stack; 
AFT_stack_sorted = sortrows(AFT_stack, 5); 
countMode = 0;
while size(AFT_stack_sorted,1)>0
    if SpDefined == 1
        Sp = StepSize(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, SpField, backGrid, backCoord);
    end
    
    node1_base = AFT_stack_sorted(1,1);         
    node2_base = AFT_stack_sorted(1,2);      
    if nCells_AFT >= 4838
        if node1_base == 288 && node2_base == 290 || node1_base == 831 && node2_base == 630|| ...
                node1_base == 580 && node2_base == 468
            kkk = 1;          
        end
%         PLOT_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, 1);
        kkk = 1;      
    end

    size0 = size(AFT_stack_sorted,1);   
    [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun, stencilType,Grid);   
    while node_select == -1
        al = 1.2 * al;
        [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun, stencilType,Grid);
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
    
    interval = 500;
    if(mod(nCells_AFT,interval)==0)
        disp('================================');
        disp('==========�ƽ�������...==========');
        disp(['nCells = ', num2str(nCells_AFT)]);
        disp(['����ʵʱ���ȣ�', num2str(size(AFT_stack_sorted,1))]);
        disp(['������������',num2str(size1-size0)]);
        disp(['countMode = ', num2str(countMode)]);
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
disp(['countMode = ', num2str(countMode)]);
toc;
%%
% GridQualitySummary(Grid_stack, xCoord_AFT, yCoord_AFT, cellNodeTopo);
PLOT(Grid, Coord(:,1), Coord(:,2))
triMesh_pw = DelaunayMesh(Coord(:,1),Coord(:,2),wallNodes);
GridQualitySummaryDelaunay(triMesh_pw, wallNodes);
hold off;
%%
triMesh = DelaunayMesh(xCoord_AFT,yCoord_AFT,wallNodes);
% GridQualitySummaryDelaunay(triMesh, wallNodes);
hold off;
%%
[xCoord, yCoord] = SpringOptimize(triMesh,wallNodes,2);
GridQualitySummaryDelaunay(triMesh, wallNodes, xCoord, yCoord)
hold off;
toc

    
    






