clear;clc;close all;format long;
tstart0 = tic;
%%
global num_label flag_label cellNodeTopo epsilon standardlize SpDefined countMode useANN outGridType tolerance crossCount;  
al          = 3.0;      % �ڼ�����Χ������
coeff       = 0.8;      % ����ѡ�����е�Ĳ�����Pbest����������ϵ��
outGridType = 0;        % 0-����ͬ������1-������������
stencilType = 'all';    % ��ANN���ɵ�ʱ�����ȡ��ǰ�����������ģ�壬�������ȡ1�����������п��ܶ�ȡ�����ƽ��
epsilon     = 0.9;      % ��������Ҫ��, ֵԽ��Ҫ��Խ��
useANN      = 1;        % �Ƿ�ʹ��ANN��������
tolerance   = 0.2;      % ANN����ģʽ�жϵ��ݲ�
cd ./nets;
nn_fun = @net_naca0012_20201104; 
cd ../;
standardlize = 1;   %�Ƿ���������һ��
isSorted     = 1;   %�Ƿ��������������ƽ�
num_label    = 0;   %�Ƿ���ͼ�������ı��    
SpDefined    = 1;   % 0-δ���岽����ֱ�Ӳ�������㣻1-�����˲����ļ���2-ANN����˲���
% stepSizeFile     = '../grid/simple/quad2.cas';
% stepSizeFile     = '../grid/simple/pentagon3.cas';
% stepSizeFile     = '../grid/simple/quad_quad.cas';
% stepSizeFile     = '../grid/simple/rectan.cas';
% stepSizeFile     = '../grid/inv_cylinder/tri/inv_cylinder-50.cas';
% stepSizeFile     = '../grid/naca0012/tri/naca0012-tri.cas';
% stepSizeFile     = '../grid/ANW/anw.cas';
% stepSizeFile     = '../grid/RAE2822/rae2822.cas';
stepSizeFile     = '../grid/30p30n/30p30n-fine.cas';
sizeFileType     = 0;   %���벽���ļ������ͣ�0-����������1-�������
boundaryGrid     = stepSizeFile; 
boundaryGridType = 0;   % 0-��һ��Ԫ����1-��ϵ�Ԫ����
crossCount       = 0;
%%
[AFT_stack,Coord,Grid,wallNodes]  = read_grid(stepSizeFile, sizeFileType);
nodeList = AFT_stack(:,1:2);
node_num = max( max(nodeList)-min(nodeList)+1 );%�߽��ĸ��������ߣ���ʼ�������
xCoord_AFT = Coord(1:node_num,1);                %��ʼ���������
yCoord_AFT = Coord(1:node_num,2);

fig = figure;
fig.Color = 'white'; hold on;
flag_label  = zeros(1,10000);
PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);

%%
% ѡ����С���棬����Pbest
nCells_AFT = 0;
Grid_stack = [];cellNodeTopo = [];
node_best = node_num;     %��ʼʱ��ѵ�Pbest�����

%%  �Ƚ��߽������ƽ�
for i =1:size(AFT_stack,1)
%     if AFT_stack(i,7) == 3      
         AFT_stack(i,5) = 0.00001* AFT_stack(i,5);  
%          AFT_stack(i,5) = 1e5* AFT_stack(i,5);
%     end
end

if SpDefined == 1
    [SpField, backGrid, backCoord] = StepSizeField(stepSizeFile, sizeFileType);
end

if isSorted == 0
    AFT_stack_sorted = AFT_stack;
elseif isSorted == 1
    AFT_stack_sorted = sortrows(AFT_stack, 5);
end

countMode = 0;
generateTime = 0; updateTime = 0; plotTime = 0;
while size(AFT_stack_sorted,1)>0
    if SpDefined == 1
        Sp = StepSize(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, SpField, backGrid, backCoord);
    end
    
    node1_base = AFT_stack_sorted(1,1);         
    node2_base = AFT_stack_sorted(1,2);      
    if nCells_AFT >= 5671
        if node1_base == 742 && node2_base == 743 || node1_base == 748 && node2_base == 743|| ...
                node1_base == 580 && node2_base == 468
            kkk = 1;      
%             PLOT_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, 1);
        end
%         PLOT_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, 1);
        kkk = 1;      
    end

    size0 = size(AFT_stack_sorted,1);   
    
    tstart1 = tic;
    [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun, stencilType,Grid);   
    while node_select == -1
        al = 1.2 * al;
        [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun, stencilType,Grid);
    end
    telapsed1 = toc(tstart1);
    generateTime = generateTime + telapsed1;
    
    tstart2 = tic;
    if( flag_best == 1 )
        xCoord_AFT = [xCoord_AFT;coordX];
        yCoord_AFT = [yCoord_AFT;coordY];
        node_best = node_best + 1;
    end
    
    [AFT_stack_sorted,nCells_AFT] = UpdateTriCells(AFT_stack_sorted, nCells_AFT, xCoord_AFT, yCoord_AFT, node_select, flag_best);
    
    telapsed2 = toc(tstart2);
    updateTime = updateTime + telapsed2;
    
    tstart3 = tic;
    size1 = size(AFT_stack_sorted,1);
    numberOfNewFronts = size1-size0;
    PLOT_NEW_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, numberOfNewFronts, flag_best);
    
    telapsed3 = toc(tstart3);
    plotTime = plotTime + telapsed3;
    
    interval = 500;
    if(mod(nCells_AFT,interval)==0)
        DisplayResults(nCells_AFT, size(AFT_stack_sorted,1), -1, numberOfNewFronts,...
        countMode,generateTime,updateTime,plotTime,'midRes');
        toc(tstart0);
    end
  %%  
  %�ҳ��ǻ�Ծ���棬��ɾ��
    [AFT_stack_sorted, Grid_stack] = DeleteInactiveFront(AFT_stack_sorted, Grid_stack);

    if isSorted == 1      
        AFT_stack_sorted = sortrows(AFT_stack_sorted, 5);
    end
end

DisplayResults(nCells_AFT, size(Grid_stack,1), length(xCoord_AFT), -1,...
        countMode,generateTime,updateTime,plotTime,'finalRes');

toc(tstart0);
% PLOT(Grid_stack, xCoord_AFT, yCoord_AFT)
%%
GridQualitySummary(Grid_stack, xCoord_AFT, yCoord_AFT, cellNodeTopo);

disp(['crossCount    = ', num2str(crossCount)]);

%%
% PLOT(Grid, Coord(:,1), Coord(:,2))
% triMesh_pw = DelaunayMesh(Coord(:,1),Coord(:,2),wallNodes);
% GridQualitySummaryDelaunay(triMesh_pw, wallNodes);
% hold off;
%%
% triMesh = DelaunayMesh(xCoord_AFT,yCoord_AFT,wallNodes);
% % GridQualitySummaryDelaunay(triMesh, wallNodes);
% hold off;
%%

% [xCoord, yCoord] = SpringOptimize(triMesh,wallNodes,3);
% GridQualitySummaryDelaunay(triMesh, wallNodes, xCoord, yCoord)
% hold off;
% toc

    
    






