clear;clc;close all;tic;format long;
%%
global num_label flag_label cellNodeTopo epsilon standardlize SpDefined;
gridType    = 0;        % 0-单一单元网格，1-混合单元网格
Sp          = 1.0;      % 网格步长  % Sp = sqrt(3.0)/2.0;  %0.866         
al          = 3.0;      % 在几倍范围内搜索
coeff       = 0.8;      % 尽量选择现有点的参数，Pbest质量参数的系数
epsilon     = 0.9;
dt          = 0.00001;   % 暂停时长
stencilType = 'all';
outGridType = 0;        % 0-各向同性网格，1-各向异性网格
nn_fun = @net_naca0012_tri_fine; %net_naca0012_quadBC_c;net_naca0012_tri_fine;net_airfoil_quadBC;net_rae2822_tri;net_cylinder_tri
num_label   = 0;
flag_label  = zeros(1,10000);
cellNodeTopo = [];
standardlize = 1;
SpDefined    = 1;   % 0-未定义步长，直接采用网格点；1-定义了步长文件；2-ANN输出了步长
stepSizeFile = '../grid/naca0012/tri/naca0012-tri-quadBC-sp.cas';
sizeFileType = 0;
%%
% [AFT_stack,Coord, Grid, wallNodes]  = read_grid('../grid/inv_cylinder/tri/inv_cylinder-30.cas', gridType);
% [AFT_stack,Coord, Grid, wallNodes]  = read_grid('../grid/simple/pentagon3.cas', gridType);
% [AFT_stack,Coord, Grid, wallNodes]  = read_grid('../grid/simple/tri.cas', gridType);
% [AFT_stack,Coord, Grid, wallNodes]  = read_grid('../grid/simple/quad_quad2.cas', gridType);
% [AFT_stack,Coord, Grid, wallNodes]  = read_grid('../grid/naca0012/tri/naca0012-tri-quadBC.cas', gridType);
% [AFT_stack,Coord, Grid, wallNodes]  = read_grid('../grid/airfoil-training/tri/naca0012.cas', gridType);
% [AFT_stack,Coord, Grid,wallNodes]  = read_grid('../grid/airfoil-training/tri/rae2822.cas', gridType);
[AFT_stack,Coord, Grid, wallNodes]  = read_grid('../grid/airfoil-training/tri/anw.cas', gridType);
nodeList = AFT_stack(:,1:2);
node_num = max( max(nodeList)-min(nodeList)+1 );%边界点的个数，或者，初始阵面点数
xCoord_AFT = Coord(1:node_num,1);                %初始阵面点坐标
yCoord_AFT = Coord(1:node_num,2);
PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);

%%
% 选择最小阵面，生成Pbest
nCells_AFT = 0;
iFace = 1;
Grid_stack = [];
node_best = node_num;     %初始时最佳点Pbest的序号

%%  先将边界阵面推进
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
while size(AFT_stack_sorted,1)>0
    if SpDefined == 1
        Sp = StepSize(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, SpField, backGrid, backCoord);
    end
    
%     node1_base = AFT_stack_sorted(1,1);         
%     node2_base = AFT_stack_sorted(1,2);      
%     if nCells_AFT >= -10
%         if node1_base == 154 && node2_base == 241 || node1_base == 831 && node2_base == 630|| ...
%                 node1_base == 580 && node2_base == 468
%             kkk = 1;
%         end
%         PLOT_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, 1);
%         kkk = 1;      
%     end

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
    
    interval = 100;
    if(mod(nCells_AFT,interval)==0)
        disp('================================');
        disp('==========推进生成中...==========');
        disp(['nCells = ', num2str(nCells_AFT)]);
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
disp(['阵面推进完成，节点数：', num2str(length(xCoord_AFT))]);
disp(['阵面推进完成，面个数：', num2str(size(Grid_stack,1))]);
toc;
%%
DelaunayMesh(xCoord_AFT,yCoord_AFT,wallNodes);
toc

    
    






