% restart = 0;
% if restart == 0
close all;format long;clear;
tstart0 = tic;
global num_label flag_label cellNodeTopo epsilon nCells_quad nCells_tri ...
stencilType outGridType standardlize SpDefined useANN crossCount countMode_quad countMode_tri tolerance nn_fun_quad nn_fun_tri; 
%%
al          = 3.0;      % �ڼ�����Χ������
coeff       = 0.8;     % ����ѡ�����е�Ĳ�����Pbest����������ϵ��
outGridType = 1;        % 0-���������� 1-�������
stencilType = 'all';    % ��ANN���ɵ�ʱ�����ȡ��ǰ�����������ģ�壬�������ȡ1�����������п��ܶ�ȡ�����ƽ��
epsilon     = 0.8;     % �ı�����������Ҫ��, ֵԽ��Ҫ��Խ��
useANN      = 1;        % �Ƿ�ʹ��ANN��������
tolerance   = 0.0000002;      % ANN����ģʽ�жϵ��ݲ�
cd ./net;
nn_fun_quad = @net_hybrid_20201130;  %net_naca0012_quad;net_airfoil_hybrid;net_cylinder_quad3
nn_fun_tri  = @net_naca0012_20201104; 
cd ../;
standardlize = 1;       %�Ƿ���������һ��
isSorted     = 1;       %�Ƿ��������������ƽ�
isPlotNew    = 0;       %�Ƿ�plot���ɹ���
num_label    = 0;       %�Ƿ���ͼ�������ı��
SpDefined    = 1;       % 0-δ���岽����ֱ�Ӳ�������㣻1-�����˲����ļ���2-ANN����˲���
% stepSizeFile     = '../grid/simple/quad2.cas';
% stepSizeFile     = '../grid/simple/pentagon3.cas';
% stepSizeFile     = '../grid/simple/quad_quad.cas';
% stepSizeFile     = '../grid/simple/special.cas';
stepSizeFile     = '../grid/inv_cylinder/tri/inv_cylinder-50.cas';
% stepSizeFile     = '../grid/naca0012/tri/naca0012-tri.cas';
% stepSizeFile     = '../grid/ANW/anw.cas';
% stepSizeFile     = '../grid/RAE2822/rae2822.cas';
% stepSizeFile     = '../grid/30p30n/30p30n-fine.cas';
sizeFileType     = 0;   %���벽���ļ������ͣ�0-����������1-�������
% boundaryGrid     = stepSizeFile; 
% boundaryGridType = 0;   % 0-��һ��Ԫ����1-��ϵ�Ԫ����
crossCount       = 0;
%%
[AFT_stack,Coord,Grid,wallNodes]  = read_grid(stepSizeFile, sizeFileType);
% [AFT_stack,Coord,Grid,wallNodes]  = read_grid(boundaryGrid, boundaryGridType);
%%
nodeList = AFT_stack(:,1:2);
node_num = max( max(nodeList)-min(nodeList)+1 ); %�߽��ĸ��������ߣ���ʼ�������
xCoord_AFT = Coord(1:node_num,1);                %��ʼ���������
yCoord_AFT = Coord(1:node_num,2);

fig = figure;
fig.Color = 'white'; axis off; hold on;
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
% end
%% ==============================================    
countMode_quad = 0; countMode_tri = 0;
generateTime = 0; updateTime = 0; plotTime = 0;
while size(AFT_stack_sorted,1)>0   
    if SpDefined == 1
        Sp = StepSize(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, SpField, backGrid, backCoord);
    else
        Sp = 1;
    end
    
%% ==============================================        
    node1_base = AFT_stack_sorted(1,1);         
    node2_base = AFT_stack_sorted(1,2);        

    if nCells_AFT >=2000
        if node1_base == 2455 && node2_base == 2464 || node1_base == 375 && node2_base == 167|| ...
                node1_base == 313 && node2_base == 314
        PLOT_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, 1);
        end
%         PLOT_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, 1);    
    end  
%% ==============================================         
    tstart1 = tic;
    [node_select,coordX, coordY, flag_best] = GenerateQuads_mode(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, Grid_stack); 
    telapsed1 = toc(tstart1);
    generateTime = generateTime + telapsed1;
    
    if  sum(flag_best==1) > 0 
        xCoord_AFT = [xCoord_AFT;coordX];
        yCoord_AFT = [yCoord_AFT;coordY]; 
    end
    
    size0 = size(AFT_stack_sorted,1);
    tstart2 = tic;
    if length(node_select) == 2
        [AFT_stack_sorted,nCells_AFT] = UpdateQuadCells(AFT_stack_sorted, nCells_AFT, xCoord_AFT, yCoord_AFT, node_select, flag_best);
    elseif length(node_select) == 1
        [AFT_stack_sorted,nCells_AFT] = UpdateTriCells(AFT_stack_sorted, nCells_AFT, xCoord_AFT, yCoord_AFT, node_select, flag_best);
    end
    telapsed2 = toc(tstart2); 
    updateTime = updateTime + telapsed2;
    
%% ==============================================    
    size1 = size(AFT_stack_sorted,1);
    numberOfNewFronts = size1- size0;
    
    tstart3 = tic;
    if isPlotNew == 1
        PLOT_NEW_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, numberOfNewFronts);
    end
    telapsed3 = toc(tstart3);
    plotTime = plotTime + telapsed3;
    
    interval = 500;
    if(mod(nCells_AFT,interval)==0)
        DisplayResultsHybrid(nCells_AFT, size(AFT_stack_sorted,1), -1, numberOfNewFronts, generateTime,updateTime,plotTime,tstart0,'midRes');
    end
%% ==============================================    
    [AFT_stack_sorted, Grid_stack] = DeleteInactiveFront(AFT_stack_sorted, Grid_stack);
    
    if isSorted == 1      
        AFT_stack_sorted = sortrows(AFT_stack_sorted, 5);
    end
end
%% ============================================== 
DisplayResultsHybrid(nCells_AFT, size(Grid_stack,1), length(xCoord_AFT), -1, generateTime,updateTime,plotTime, tstart0, 'finalRes');
if isPlotNew == 0   
    PLOT(Grid_stack, xCoord_AFT, yCoord_AFT)
end
%% ============================================== 
% GridQualitySummary(cellNodeTopo, xCoord_AFT, yCoord_AFT, Grid_stack);
% %% Delaunay�Խ��߱任֮�������������
[triMesh,invalidCellIndex] = DelaunayMesh(xCoord_AFT,yCoord_AFT,wallNodes);
% GridQualitySummaryDelaunay(triMesh, invalidCellIndex);
%%
% %% ���ɷ��Ż��������������
[xCoord, yCoord] = SpringOptimize(triMesh,invalidCellIndex,wallNodes,3);
GridQualitySummaryDelaunay(triMesh, invalidCellIndex, xCoord, yCoord)

%%
% %% ����������ϲ����ı���
% combinedMesh = CombineMesh(triMesh,wallNodes,epsilon);
% �ñ����Ż��������ϲ�
combinedMesh = CombineMesh(triMesh,invalidCellIndex,wallNodes,0.5, xCoord, yCoord);
GridQualitySummary(combinedMesh, xCoord, yCoord);
% toc








