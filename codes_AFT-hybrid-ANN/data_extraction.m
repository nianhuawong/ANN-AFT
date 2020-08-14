clear;close all;tic;format long;
%%
global num_label flag_label cellNodeTopo epsilon nCells_quad nCells_tri stencilType outGridType standardlize SpDefined useANN; 
al          = 3.0;      % 在几倍范围内搜索
coeff       = 0.9;     % 尽量选择现有点的参数，Pbest质量参数的系数
outGridType = 0;        % 0-各向同性网格，1-各向异性网格
dt          = 0.00001;  % 暂停时长
stencilType = 'all';    % 在ANN生成点时，如何取当前阵面的引导点模板，可以随机取1个，或者所有可能都取，最后平均
epsilon     = 0.50;     % 四边形网格质量要求, 值越大要求越高
useANN      = 0;        % 是否使用ANN生成网格
cd ./net;
nn_fun      = @net_naca0012_quad_fine;  %net_naca0012_quad;net_airfoil_hybrid;net_cylinder_quad3
cd ../;
standardlize = 1;       %是否进行坐标归一化
isSorted     = 0;       %是否对阵面进行排序推进
num_label    = 0;       %是否在图中输出点的编号
SpDefined    = 1;       % 0-未定义步长，直接采用网格点；1-定义了步长文件；2-ANN输出了步长
% stepSizeFile     = '../grid/simple/tri.cas';
% stepSizeFile     = '../grid/simple/pentagon3.cas';
% stepSizeFile     = '../grid/simple/quad_quad3.cas';
stepSizeFile     = '../grid/simple/special.cas';
% stepSizeFile     = '../grid/inv_cylinder/tri/inv_cylinder-20.cas';
% stepSizeFile     = '../grid/naca0012/tri/naca0012-tri-quadBC.cas';
% stepSizeFile     = '../grid/ANW/anw.cas';
% stepSizeFile     = '../grid/RAE2822/rae2822.cas';
sizeFileType     = 0;   %输入步长文件的类型，0-三角形网格，1-混合网格
boundaryGrid     = stepSizeFile; 
boundaryGridType = 0;   % 0-单一单元网格，1-混合单元网格
%%
[AFT_stack,Coord,Grid,wallNodes]  = read_grid(stepSizeFile, sizeFileType);
% [AFT_stack,Coord,Grid,wallNodes]  = read_grid(boundaryGrid, boundaryGridType);
%%
nodeList = AFT_stack(:,1:2);
node_num = max( max(nodeList)-min(nodeList)+1 );%边界点的个数，或者，初始阵面点数
xCoord_AFT = Coord(1:node_num,1);                %初始阵面点坐标
yCoord_AFT = Coord(1:node_num,2);

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
       
    %% 优先生成四边形，如果生成的四边形质量太差，则重新生成三角形
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
        disp('==========推进生成中...==========');
        disp(['nCells = ', num2str(nCells_AFT)]);
        disp(['nCells_quad = ', num2str(nCells_quad)]);
        disp(['nCells_tri  = ', num2str(nCells_tri)]);
        disp(['阵面实时长度：', num2str(size(AFT_stack_sorted,1))]);
        disp(['新增阵面数：',num2str(size1-size0)]);
        toc;
    end
    %%
    %找出非活跃阵面，并删除
    [AFT_stack_sorted, Grid_stack] = DeleteInactiveFront(AFT_stack_sorted, Grid_stack);
    
    if isSorted == 1      
        AFT_stack_sorted = sortrows(AFT_stack_sorted, 5);
    end
end
disp(['阵面推进完成，单元数：', num2str(nCells_AFT)]);
disp(['阵面推进完成，quad单元数：', num2str(nCells_quad)]);
disp(['阵面推进完成，tri单元数：', num2str(nCells_tri)]);
disp(['阵面推进完成，节点数：', num2str(length(xCoord_AFT))]);
disp(['阵面推进完成，面个数：', num2str(size(Grid_stack,1))]);
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








