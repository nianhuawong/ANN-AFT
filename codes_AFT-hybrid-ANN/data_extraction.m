clear;close all;tic;format long;
%%
global num_label flag_label cellNodeTopo epsilon nCells_quad nCells_tri stencilType outGridType standardlize SpDefined;
gridType    = 0;        % 0-单一单元网格，1-混合单元网格
Sp          = 1;        % 网格步长  % Sp = sqrt(3.0)/2.0;  %0.866，传统阵面推进才需要
al          = 3.0;      % 在几倍范围内搜索
coeff       = 0.8;      % 尽量选择现有点的参数，Pbest质量参数的系数
outGridType = 0;        % 0-各向同性网格，1-各向异性网格
dt          = 0.00001;   % 暂停时长
stencilType = 'random';  % 在ANN生成点时，如何取当前阵面的引导点模板，可以随机取1个，或者所有可能都取，最后平均
epsilon     = 0.5;       % 四边形网格质量要求, 值越大要求越低
nn_fun      = @net_naca0012_quad_fine;  %net_naca0012_quad;net_airfoil_hybrid;net_cylinder_quad3
num_label   = 0;
flag_label  = zeros(1,10000);
cellNodeTopo = [];
standardlize = 1;
SpDefined    = 1;   % 0-未定义步长，直接采用网格点；1-定义了步长文件；2-ANN输出了步长
stepSizeFile = '../grid/naca0012/tri/naca0012-tri-quadBC-sp.cas';
sizeFileType = 0;
%%
% [AFT_stack,Coord,Grid,wallNodes]  = read_grid('../grid/simple/tri.cas', gridType);
% [AFT_stack,Coord,Grid,wallNodes]  = read_grid('../grid/simple/pentagon3.cas', gridType);
% [AFT_stack,Coord,Grid,wallNodes]  = read_grid('../grid/simple/quad_quad3.cas', gridType);
% [AFT_stack,Coord,Grid,wallNodes]  = read_grid('../grid/inv_cylinder/quad/inv_cylinder_quad-c.cas', gridType);
% [AFT_stack,Coord,Grid,wallNodes]  = read_grid('../grid/inv_cylinder/tri/inv_cylinder-30.cas', gridType);
[AFT_stack,Coord,Grid,wallNodes]  = read_grid('../grid/naca0012/tri/naca0012-tri-quadBC.cas', gridType);
% [AFT_stack,Coord,Grid,wallNodes]  = read_grid('../grid/RAE2822/rae2822.cas', gridType);
% [AFT_stack,Coord,Grid,wallNodes]  = read_grid('../grid/ANW/anw.cas', gridType);
%%
nodeList = AFT_stack(:,1:2);
node_num = max( max(nodeList)-min(nodeList)+1 );%边界点的个数，或者，初始阵面点数
xCoord_AFT = Coord(1:node_num,1);                %初始阵面点坐标
yCoord_AFT = Coord(1:node_num,2);

PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);

%%
% 选择最小阵面，生成Pbest
nCells_AFT = 0;
nCells_quad = 0;
nCells_tri = 0;
Grid_stack = [];
node_best = node_num;     %初始时最佳点Pbest的序号

%%  先将边界阵面推进
for i =1:size(AFT_stack,1)
%     if AFT_stack(i,7) == 3
        AFT_stack(i,5) = 0.00001* AFT_stack(i,5);
    %     AFT_stack(i,5) = 1e5* AFT_stack(i,5);
%     end
end

if SpDefined == 1
    [SpField, backGrid, backCoord] = StepSizeField(stepSizeFile, sizeFileType);
end
%%
% AFT_stack_sorted = AFT_stack;
AFT_stack_sorted = sortrows(AFT_stack, 5);
%%
while size(AFT_stack_sorted,1)>0
    if SpDefined == 1
        Sp = StepSize(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, SpField, backGrid, backCoord);
    end
    
    node1_base = AFT_stack_sorted(1,1);         
    node2_base = AFT_stack_sorted(1,2);   
    %%
     
    size0 = size(AFT_stack_sorted,1);
    %% 
    if nCells_AFT == -10
        if node1_base == 106 && node2_base == 313 || node1_base == 126 && node2_base == 313|| ...
                node1_base == 313 && node2_base == 314
            kkk = 1;
        end
        PLOT_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, 1);
        kkk = 1;
% %         if row~=-1
% %             kkk = 1;
% %         end        
    end
       
    %% 优先生成四边形，如果生成的四边形质量太差，则重新生成三角形
    [node_select,coordX, coordY, flag_best] = GenerateQuads(AFT_stack_sorted, xCoord_AFT, yCoord_AFT,...
        Sp, coeff, al, node_best, Grid_stack, nn_fun);
            
    if  sum(node_select) ~= -2 
        xCoord_AFT = [xCoord_AFT;coordX];
        yCoord_AFT = [yCoord_AFT;coordY];
        node_best = node_best + sum(flag_best);       
       
        [AFT_stack_sorted,nCells_AFT] = UpdateQuadCells(AFT_stack_sorted, nCells_AFT, ...
            xCoord_AFT, yCoord_AFT, node_select, flag_best);       
        
    elseif sum(node_select) == -2
        [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, ...
            Sp, coeff, al, node_best, Grid_stack, nn_fun);
        
        while node_select == -1 
            al = 2 * al;
            [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, ...
                Sp, coeff, al, node_best, Grid_stack, nn_fun);
        end
        
        if( flag_best == 1 )
            xCoord_AFT = [xCoord_AFT;coordX];
            yCoord_AFT = [yCoord_AFT;coordY];
            node_best = node_best + 1;
        end  
            [AFT_stack_sorted,nCells_AFT] = UpdateTriCells(AFT_stack_sorted, nCells_AFT, xCoord_AFT, yCoord_AFT, ...
                node_select, flag_best);     
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

    AFT_stack_sorted = sortrows(AFT_stack_sorted, 5);
end
disp(['阵面推进完成，单元数：', num2str(nCells_AFT)]);
disp(['阵面推进完成，quad单元数：', num2str(nCells_quad)]);
disp(['阵面推进完成，tri单元数：', num2str(nCells_tri)]);
disp(['阵面推进完成，节点数：', num2str(length(xCoord_AFT))]);
disp(['阵面推进完成，面个数：', num2str(size(Grid_stack,1))]);
toc
%%
DelaunayMesh(xCoord_AFT,yCoord_AFT,wallNodes);
toc








