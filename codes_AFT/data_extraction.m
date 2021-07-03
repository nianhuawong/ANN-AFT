clear;clc;close all;format long;tstart0 = tic;
%% ȫ�ֱ���
global outGridType epsilon num_label useANN tolerance flag_label ...
       cellNodeTopo standardlize SpDefined countMode crossCount  ... 
       rectangularBoudanryNodes gridDim dx dy;  
addpath(genpath('./')); % ���õ�ǰĿ¼����Ŀ¼Ϊ����Ŀ¼
%% �����ƽ����Ʋ���
al          = 3.0;      % �ڼ�����Χ������
coeff       = 0.8;      % ����ѡ�����е�Ĳ�����Pbest����������ϵ��
outGridType = 0;        % 0-����ͬ������1-������������
epsilon     = 0.9;      % ��������Ҫ��, ֵԽ��Ҫ��Խ��
isSorted    = 1;        % �Ƿ��������������ƽ�
%% ��ͼ��ز���
isPlotNew    = 0;   % �Ƿ�plot���ɹ���
num_label    = 0;   % �Ƿ���ͼ�������ı��
flag_label   = zeros(1,10000);
%% ANN���Ʋ���
useANN       = 0;        % �Ƿ�ʹ��ANN��������
tolerance    = 0.2;      % ANN����ģʽ�жϵ��ݲ� 
stencilType  = 'all';    % ��ANN���ɵ�ʱ�����ȡ��ǰ�����������ģ�壬�������ȡ1�����������п��ܶ�ȡ�����ƽ��
standardlize = 1;        % �Ƿ���������һ��
nn_fun       = @net_naca0012_20201104; 
nn_step_size = @nn_mesh_size_naca_3;
%% ���񲽳����Ʋ���
SpDefined    = 1;   % 1-ANN�����ܶȣ�2-�ǽṹ���������ļ���3-���α���������Դ�������ܣ�4-RBF��ֵ��������
gridDim      = 401;
sampleType   = 3;   % ANN�������ƣ�1-(x,y,h); 2-(x,y,d1,dx1,h); 3-(x,y,d1,dx1,d2,dx2,h)
% stepSizeFile     = '../grid/simple/quad2.cas';
% stepSizeFile     = '../grid/simple/pentagon3.cas';
% stepSizeFile     = '../grid/simple/quad_quad.cas';
% stepSizeFile     = '../grid/simple/rectan.cas';
% stepSizeFile     = '../grid/inv_cylinder/tri/inv_cylinder-30.cas';
rectangularBoudanryNodes =1*4-4;  % ������߽��ϵĽڵ��������ܻ�仯
stepSizeFile     = '../grid/naca0012/tri/naca0012-tri.cas'; %-quadBC
% stepSizeFile     = '../grid/ANW/anw.cas';
% stepSizeFile     = '../grid/RAE2822/rae2822.cas';
% stepSizeFile     = '../grid/30p30n/30p30n-small.cas';%
sizeFileType     = 0;   %���벽���ļ������ͣ�0-����������1-�������
%% ����߽����漰�߽�ڵ����Ϣ
[AFT_stack,Coord,Grid,wallNodes]  = read_grid(stepSizeFile, sizeFileType);
nodeList = AFT_stack(:,1:2);
node_num = max( max(nodeList)-min(nodeList)+1 ); %�߽��ĸ��������ߣ���ʼ�������
xCoord_AFT = Coord(1:node_num,1);                %��ʼ���������
yCoord_AFT = Coord(1:node_num,2);

if isPlotNew == 1 || SpDefined == 3 || SpDefined == 4
    PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);
end
% [triMesh_pw,invalidCellIndex_pw]= DelaunayMesh(Coord(:,1),Coord(:,2),wallNodes);
%% �������Ʒ�����1-ANN�����ܶȣ�2-�ǽṹ���������ļ���3-���α���������Դ��������
tstart = tic;
if SpDefined == 1 && sampleType == 3
    maxWdist = ComputeMaxWallDist(Grid, Coord);
elseif SpDefined == 2 
    [SpField, backGrid, backCoord] = StepSizeField(stepSizeFile, sizeFileType);
elseif SpDefined == 3   
        [range,xcoord,ycoord] = RectangularBackgroundMesh(AFT_stack,Coord);
%         PLOT_Background_Grid(xcoord,ycoord);
%         PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);
        SourceInfo = CalculateSourceInfo(AFT_stack,Coord,1);
%%
%          [~,SelectedSourcesIndex] = CalculateSpByRBF_Greedy(SourceInfo,range);    %̰���㷨
%         SourceInfo = SourceInfo(SelectedSourcesIndex,:);       
%%      
        [StepSize, LOWER, UPPER] = InitialValue(SourceInfo,range);
        SpField = Iterative_Solve(SourceInfo,StepSize,range, LOWER, UPPER);
%         SpField = StepSize;
elseif SpDefined == 4   
        [range,xcoord,ycoord] = RectangularBackgroundMesh(AFT_stack,Coord);
        SourceInfo = CalculateSourceInfo(AFT_stack,Coord,3);    
%         SpField = CalculateSpByRBF(SourceInfo,range);

        [SpField,SelectedSourcesIndex] = CalculateSpByRBF_Greedy(SourceInfo,range);    %̰���㷨
%         SelectedSources = SourceInfo(SelectedSourcesIndex,:);
end
telapsed = toc(tstart);
disp(['SpField time = ', num2str(telapsed)]);
%% �Ƚ��߽������ƽ�
AFT_stack_sorted = AFT_stack;
if isSorted == 1
    AFT_stack_sorted = Sort_AFT(AFT_stack);
end
%%
nCells_AFT   = 0;
Grid_stack   = []; cellNodeTopo = [];
countMode    = 0;  crossCount   = 0;
node_best    = node_num;   %��ʼʱ��ѵ�Pbest�����
generateTime = 0; spTime = 0; updateTime = 0; plotTime = 0;
%%
while size(AFT_stack_sorted,1)>0
    node1_base = AFT_stack_sorted(1,1);         
    node2_base = AFT_stack_sorted(1,2);  
    
%     if nCells_AFT >= 0
%         if node1_base == 47 && node2_base == 48 %|| node1_base == 748 && node2_base == 743|| ...
% %                 node1_base == 580 && node2_base == 468
% %             kkk = 1;      
%             PLOT_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, 1);
%         end
%         PLOT_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, 1);
%         kkk = 1;      
%     end
    xx = 0.5 * ( xCoord_AFT(node1_base) + xCoord_AFT(node2_base) );
    yy = 0.5 * ( yCoord_AFT(node1_base) + yCoord_AFT(node2_base) );
%%
    tstart1 = tic;
    if SpDefined == 1       % 1-ANN�����ܶ�
        Sp = StepSize_ANN(xx, yy, Grid, Coord, sampleType, nn_step_size, maxWdist);
    elseif SpDefined == 2   % 2-�ӱ��������ļ��ж�ȡSp     
        Sp = StepSize(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, SpField, backGrid, backCoord);
    elseif SpDefined == 3   % 3-���α���������Դ�������ܣ��˴��Ǵӱ��������ֵ����ʵ����
        Sp = Interpolate2Grid(xx, yy, SpField, range);
    elseif SpDefined == 4   % 4-���α�������RBF�������ܣ��˴��Ǵӱ��������ֵ����ʵ����
        Sp = Interpolate2Grid(xx, yy, SpField, range);
    end
    
    telapsed1 = toc(tstart1);
    spTime = spTime + telapsed1;
%%
    size0 = size(AFT_stack_sorted,1);     
    tstart2 = tic;
    [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun, stencilType);   
    while node_select == -1
        al = 1.2 * al;
        [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun, stencilType);
    end
    telapsed2 = toc(tstart2);
    generateTime = generateTime + telapsed2;
%%    
    tstart3 = tic;
    if( flag_best == 1 )
        xCoord_AFT = [xCoord_AFT;coordX];
        yCoord_AFT = [yCoord_AFT;coordY];
        node_best = node_best + 1;
    end
    
    [AFT_stack_sorted,nCells_AFT] = UpdateTriCells(AFT_stack_sorted, nCells_AFT, xCoord_AFT, yCoord_AFT, node_select, flag_best);
    
    telapsed3 = toc(tstart3);
    updateTime = updateTime + telapsed3;
%%    
    tstart4 = tic;
    size1 = size(AFT_stack_sorted,1);
    numberOfNewFronts = size1-size0;
    if isPlotNew == 1
        PLOT_NEW_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, numberOfNewFronts, flag_best);
    end
    telapsed4 = toc(tstart4);
    plotTime = plotTime + telapsed4;
%%    
    interval = 500;
    if(mod(nCells_AFT,interval)==0)
        DisplayResults(nCells_AFT, size(AFT_stack_sorted,1), -1, numberOfNewFronts,spTime,generateTime,updateTime,plotTime,tstart0,'midRes');
    end
%% �ҳ��ǻ�Ծ���棬��ɾ��
    [AFT_stack_sorted, Grid_stack] = DeleteInactiveFront(AFT_stack_sorted, Grid_stack);

    if isSorted == 1      
        AFT_stack_sorted = Sort_AFT(AFT_stack_sorted);
    end
end
%%
DisplayResults(nCells_AFT, size(Grid_stack,1), length(xCoord_AFT), -1,spTime,generateTime,updateTime,plotTime,tstart0,'finalRes');
if isPlotNew == 0   
    PLOT(Grid_stack, xCoord_AFT, yCoord_AFT)
end

%% ԭʼ���������������
% GridQualitySummary(cellNodeTopo, xCoord_AFT, yCoord_AFT,Grid_stack);

%% PW��������
% PLOT(Grid, Coord(:,1), Coord(:,2))
% [triMesh_pw,invalidCellIndex_pw]= DelaunayMesh(Coord(:,1),Coord(:,2),wallNodes);
% GridQualitySummaryDelaunay(triMesh_pw, invalidCellIndex_pw);

%% Delaunay�Խ��߱任֮�������������
[triMesh,invalidCellIndex] = DelaunayMesh(xCoord_AFT,yCoord_AFT,wallNodes);
% GridQualitySummaryDelaunay(triMesh, invalidCellIndex);

%%
[xCoord,yCoord] = SpringOptimize(triMesh,invalidCellIndex,wallNodes,3);
GridQualitySummaryDelaunay(triMesh, invalidCellIndex, xCoord, yCoord)

%% �ñ����Ż��������ϲ�
% combinedMesh = CombineMesh(triMesh, invalidCellIndex, wallNodes,0.5, xCoord, yCoord);
% GridQualitySummary(combinedMesh, xCoord, yCoord);  
