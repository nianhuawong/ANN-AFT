clear;close all;
tic
format long
%%
gridType    = 1;        % 0-单一单元网格，1-混合单元网格
Sp          = 1;      % 网格步长  % Sp = sqrt(3.0)/2.0;  %0.866
al          = 3.0;      % 在几倍范围内搜索
coeff       = 0.6;      % 尽量选择现有点的参数，Pbest质量参数的系数
outGridType = 0;        % 0-各向同性网格，1-各向异性网格
dt          = 0.0001;   % 暂停时长
stencilType = 'random';
nn_fun = @net_cylinder_quad5;
% nn_fun = @net_naca0012_quad;
%%
[AFT_stack,Coord,Grid]  = read_grid('../grid/inv_cylinder/quad/inv_cylinder_quad.cas', gridType);
% [AFT_stack,Coord,~]  = read_grid('../grid/naca0012/tri/naca0012-tri-quadBC.cas', gridType);
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
    %优先生成四边形，如果生成的四边形质量太差，则重新生成三角形 
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
        disp('==========推进生成中...==========');
        disp(['nCells = ', num2str(nCells_AFT)]);
        disp(['nCells_quad = ', num2str(nCells_quad)]);
        disp(['nCells_tri  = ', num2str(nCells_tri)]);
        disp(['阵面实时长度：', num2str(size(AFT_stack_sorted,1))]);
        disp(['新增阵面数：',num2str(size1-size0)]);
    end
    %%
    %找出非活跃阵面，并删除
    [AFT_stack_sorted, Grid_stack] = DeleteInactiveFront(AFT_stack_sorted, Grid_stack);

    AFT_stack_sorted = sortrows(AFT_stack_sorted, 5);
%     AFT_stack_sorted = AFT_stack_sorted(end:-1:1,:);
    % AFT_stack_sorted = sortrows(AFT_stack, 5, 'descend');
end
disp(['阵面推进完成，单元数：', num2str(nCells_AFT)]);
disp(['阵面推进完成，quad单元数：', num2str(nCells_quad)]);
disp(['阵面推进完成，tri单元数：', num2str(nCells_tri)]);
disp(['阵面推进完成，节点数：', num2str(length(xCoord_AFT))]);
disp(['阵面推进完成，面个数：', num2str(size(Grid_stack,1))]);
toc








