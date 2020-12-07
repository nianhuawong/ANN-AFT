% restart = 0;
% if restart == 0
close all;format long;clear;
tstart0 = tic;
global num_label flag_label cellNodeTopo epsilon nCells_quad nCells_tri ...
stencilType outGridType standardlize SpDefined useANN crossCount countMode_quad countMode_tri tolerance nn_fun_quad nn_fun_tri; 
%%
al          = 3.0;      % 在几倍范围内搜索
coeff       = 0.85;     % 尽量选择现有点的参数，Pbest质量参数的系数
outGridType = 0;        % 0-各向同性网格，1-各向异性网格
stencilType = 'all';    % 在ANN生成点时，如何取当前阵面的引导点模板，可以随机取1个，或者所有可能都取，最后平均
epsilon     = 0.8;     % 四边形网格质量要求, 值越大要求越高
useANN      = 1;        % 是否使用ANN生成网格
tolerance   = 0.4;      % ANN进行模式判断的容差
cd ./net;
nn_fun_quad = @net_hybrid_20201130;  %net_naca0012_quad;net_airfoil_hybrid;net_cylinder_quad3
nn_fun_tri  = @net_naca0012_20201104; 
cd ../;
standardlize = 1;       %是否进行坐标归一化
isSorted     = 1;       %是否对阵面进行排序推进
num_label    = 0;       %是否在图中输出点的编号
SpDefined    = 1;       % 0-未定义步长，直接采用网格点；1-定义了步长文件；2-ANN输出了步长
% stepSizeFile     = '../grid/simple/quad2.cas';
% stepSizeFile     = '../grid/simple/pentagon3.cas';
% stepSizeFile     = '../grid/simple/quad_quad.cas';
% stepSizeFile     = '../grid/simple/special.cas';
% stepSizeFile     = '../grid/inv_cylinder/tri/inv_cylinder.cas';
stepSizeFile     = '../grid/naca0012/tri/naca0012-tri-coarse.cas';
% stepSizeFile     = '../grid/ANW/anw.cas';
% stepSizeFile     = '../grid/RAE2822/rae2822.cas';
sizeFileType     = 0;   %输入步长文件的类型，0-三角形网格，1-混合网格
boundaryGrid     = stepSizeFile; 
boundaryGridType = 0;   % 0-单一单元网格，1-混合单元网格
crossCount       = 0;
%%
[AFT_stack,Coord,Grid,wallNodes]  = read_grid(stepSizeFile, sizeFileType);
% [AFT_stack,Coord,Grid,wallNodes]  = read_grid(boundaryGrid, boundaryGridType);
%%
nodeList = AFT_stack(:,1:2);
node_num = max( max(nodeList)-min(nodeList)+1 ); %边界点的个数，或者，初始阵面点数
xCoord_AFT = Coord(1:node_num,1);                %初始阵面点坐标
yCoord_AFT = Coord(1:node_num,2);

fig = figure;
fig.Color = 'white'; hold on;
flag_label  = zeros(10000,1);
PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);

%%
% 选择最小阵面，生成Pbest
nCells_AFT = 0; nCells_quad = 0; nCells_tri = 0;
cellNodeTopo = []; Grid_stack = [];
node_best = node_num;     %初始时最佳点Pbest的序号

%%  先将边界阵面推进
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

    if nCells_AFT >=101
        if node1_base == 1053 && node2_base == 1130 || node1_base == 375 && node2_base == 167|| ...
                node1_base == 313 && node2_base == 314
%         PLOT_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, 1);
        end
%         PLOT_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, 1);    
    end  
%% ==============================================         
    tstart1 = tic;
    [node_select,coordX, coordY, flag_best] = GenerateQuads_mode(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack);
    telapsed1 = toc(tstart1);
    generateTime = generateTime + telapsed1;
    
    if  sum(flag_best==1) > 0 
        xCoord_AFT = [xCoord_AFT;coordX];
        yCoord_AFT = [yCoord_AFT;coordY];
        node_best = node_best + sum(flag_best);   
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
%     PLOT_NEW_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, numberOfNewFronts);
    telapsed3 = toc(tstart3);
    plotTime = plotTime + telapsed3;
    
    interval = 500;
    if(mod(nCells_AFT,interval)==0)
        DisplayResultsHybrid(nCells_AFT, size(AFT_stack_sorted,1), -1, numberOfNewFronts,...
        nCells_quad,nCells_tri,generateTime,updateTime,plotTime,'midRes');
        toc(tstart0);
    end
%% ==============================================    
    [AFT_stack_sorted, Grid_stack] = DeleteInactiveFront(AFT_stack_sorted, Grid_stack);
    
    if isSorted == 1      
        AFT_stack_sorted = sortrows(AFT_stack_sorted, 5);
    end
end
%% ============================================== 
DisplayResultsHybrid(nCells_AFT, size(Grid_stack,1), length(xCoord_AFT), -1,...
        nCells_quad,nCells_tri,generateTime,updateTime,plotTime,'finalRes');
toc(tstart0);

%% ============================================== 
% GridQualitySummary(Grid_stack, xCoord_AFT, yCoord_AFT, cellNodeTopo);
% %% Delauna对角线变换之后，输出网格质量
% triMesh = DelaunayMesh(xCoord_AFT,yCoord_AFT,wallNodes);
% GridQualitySummaryDelaunay(triMesh, wallNodes);
% % hold off;
% %% 弹簧法优化后，输出网格质量
% [xCoord, yCoord] = SpringOptimize(triMesh,wallNodes,3);
% GridQualitySummaryDelaunay(triMesh, wallNodes, xCoord, yCoord)
% % hold off;
% %% 三角形网格合并成四边形
% combinedMesh = CombineMesh(triMesh,wallNodes,epsilon);
% 用变形优化后的网格合并
% combinedMesh = CombineMesh(triMesh,wallNodes,0.5, xCoord, yCoord);
% toc








