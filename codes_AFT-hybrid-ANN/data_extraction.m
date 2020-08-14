clear;close all;tic;format long;
%%
global num_label flag_label cellNodeTopo epsilon nCells_quad nCells_tri stencilType outGridType standardlize SpDefined useANN; 
al          = 3.0;      % �ڼ�����Χ������
coeff       = 0.9;     % ����ѡ�����е�Ĳ�����Pbest����������ϵ��
outGridType = 0;        % 0-����ͬ������1-������������
dt          = 0.00001;  % ��ͣʱ��
stencilType = 'all';    % ��ANN���ɵ�ʱ�����ȡ��ǰ�����������ģ�壬�������ȡ1�����������п��ܶ�ȡ�����ƽ��
epsilon     = 0.50;     % �ı�����������Ҫ��, ֵԽ��Ҫ��Խ��
useANN      = 0;        % �Ƿ�ʹ��ANN��������
cd ./net;
nn_fun      = @net_naca0012_quad_fine;  %net_naca0012_quad;net_airfoil_hybrid;net_cylinder_quad3
cd ../;
standardlize = 1;       %�Ƿ���������һ��
isSorted     = 0;       %�Ƿ��������������ƽ�
num_label    = 0;       %�Ƿ���ͼ�������ı��
SpDefined    = 1;       % 0-δ���岽����ֱ�Ӳ�������㣻1-�����˲����ļ���2-ANN����˲���
% stepSizeFile     = '../grid/simple/tri.cas';
% stepSizeFile     = '../grid/simple/pentagon3.cas';
% stepSizeFile     = '../grid/simple/quad_quad3.cas';
stepSizeFile     = '../grid/simple/special.cas';
% stepSizeFile     = '../grid/inv_cylinder/tri/inv_cylinder-20.cas';
% stepSizeFile     = '../grid/naca0012/tri/naca0012-tri-quadBC.cas';
% stepSizeFile     = '../grid/ANW/anw.cas';
% stepSizeFile     = '../grid/RAE2822/rae2822.cas';
sizeFileType     = 0;   %���벽���ļ������ͣ�0-����������1-�������
boundaryGrid     = stepSizeFile; 
boundaryGridType = 0;   % 0-��һ��Ԫ����1-��ϵ�Ԫ����
%%
[AFT_stack,Coord,Grid,wallNodes]  = read_grid(stepSizeFile, sizeFileType);
% [AFT_stack,Coord,Grid,wallNodes]  = read_grid(boundaryGrid, boundaryGridType);
%%
nodeList = AFT_stack(:,1:2);
node_num = max( max(nodeList)-min(nodeList)+1 );%�߽��ĸ��������ߣ���ʼ�������
xCoord_AFT = Coord(1:node_num,1);                %��ʼ���������
yCoord_AFT = Coord(1:node_num,2);

flag_label  = zeros(10000,1);
PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);

%%
% ѡ����С���棬����Pbest
nCells_AFT = 0; nCells_quad = 0; nCells_tri = 0;
cellNodeTopo = []; Grid_stack = [];
node_best = node_num;     %��ʼʱ��ѵ�Pbest�����

%%  �Ƚ��߽������ƽ�
for i =1:size(AFT_stack,1)
%     if AFT_stack(i,7) == 3
        AFT_stack(i,5) = 0.00001* AFT_stack(i,5);
    %     AFT_stack(i,5) = 1e5* AFT_stack(i,5);
%     end
end
%%
if SpDefined == 1
    [SpField, backGrid, backCoord] = StepSizeField(stepSizeFile, sizeFileType);
end
%%
if isSorted == 0
    AFT_stack_sorted = AFT_stack;
elseif isSorted == 1
    AFT_stack_sorted = sortrows(AFT_stack, 5);
end
%%
while size(AFT_stack_sorted,1)>0
     size0 = size(AFT_stack_sorted,1);
     
    if SpDefined == 1
        Sp = StepSize(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, SpField, backGrid, backCoord);
    else
        Sp = 1;
    end
    
    node1_base = AFT_stack_sorted(1,1);         
    node2_base = AFT_stack_sorted(1,2);        
    
    %% 
    if nCells_AFT >= 240
        if node1_base == 169 && node2_base == 190 || node1_base == 126 && node2_base == 313|| ...
                node1_base == 313 && node2_base == 314
        PLOT_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, 1);
        end
        PLOT_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, 1);    
    end

%     if xCoord_AFT(node1_base) < 0.4 && xCoord_AFT(node1_base) > -0.4 && nCells_AFT < 300 && AFT_stack_sorted(1,7) ~= 9
%         N = randi(size0,1,1);
%         tmp = AFT_stack_sorted(1,:);
%         AFT_stack_sorted(1,:) = AFT_stack_sorted(N,:);
%         AFT_stack_sorted(N,:) = tmp;
%         continue;
%     end    
       
    %% ���������ı��Σ�������ɵ��ı�������̫�����������������
    [node_select,coordX, coordY, flag_best] = GenerateQuads(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun);
            
    if  sum(node_select) ~= -2 
        xCoord_AFT = [xCoord_AFT;coordX];
        yCoord_AFT = [yCoord_AFT;coordY];
        node_best = node_best + sum(flag_best);       
       
        [AFT_stack_sorted,nCells_AFT] = UpdateQuadCells(AFT_stack_sorted, nCells_AFT, xCoord_AFT, yCoord_AFT, node_select, flag_best);       
        
    elseif sum(node_select) == -2
        [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun);
        
        while node_select == -1 
            al = 2 * al;
            [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun);
        end
        
        if( flag_best == 1 )
            xCoord_AFT = [xCoord_AFT;coordX];
            yCoord_AFT = [yCoord_AFT;coordY];
            node_best = node_best + 1;
        end  
            [AFT_stack_sorted,nCells_AFT] = UpdateTriCells(AFT_stack_sorted, nCells_AFT, xCoord_AFT, yCoord_AFT, node_select, flag_best);     
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
        toc;
    end
    %%
    %�ҳ��ǻ�Ծ���棬��ɾ��
    [AFT_stack_sorted, Grid_stack] = DeleteInactiveFront(AFT_stack_sorted, Grid_stack);
    
    if isSorted == 1      
        AFT_stack_sorted = sortrows(AFT_stack_sorted, 5);
    end
end
disp(['�����ƽ���ɣ���Ԫ����', num2str(nCells_AFT)]);
disp(['�����ƽ���ɣ�quad��Ԫ����', num2str(nCells_quad)]);
disp(['�����ƽ���ɣ�tri��Ԫ����', num2str(nCells_tri)]);
disp(['�����ƽ���ɣ��ڵ�����', num2str(length(xCoord_AFT))]);
disp(['�����ƽ���ɣ��������', num2str(size(Grid_stack,1))]);
toc
%%
% GridQualitySummary(Grid_stack, xCoord_AFT, yCoord_AFT, cellNodeTopo);
%%
triMesh = DelaunayMesh(xCoord_AFT,yCoord_AFT,wallNodes);
% GridQualitySummaryDelaunay(triMesh, wallNodes);
hold off;
%%
[xCoord, yCoord] = SpringOptimize(triMesh,wallNodes,2);
% GridQualitySummaryDelaunay(triMesh, wallNodes, xCoord, yCoord)
% hold off;
%%
combinedMesh = CombineMesh(triMesh,wallNodes,epsilon);
% combinedMesh = CombineMesh(triMesh,wallNodes,epsilon, xCoord, yCoord);
toc








