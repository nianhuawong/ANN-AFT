clear;clc;close all;
tic
format long
%%
gridType    = 0;        % 0-单一单元网格，1-混合单元网格
Sp          = 1.0;      % 网格步长  % Sp = sqrt(3.0)/2.0;  %0.866         
al          = 3.0;      % 在几倍范围内搜索
coeff       = 0.8;      % 尽量选择现有点的参数，Pbest质量参数的系数
dt          = 0.00001;   % 暂停时长
stencilType = 'random';
outGridType = 0;        % 0-各向同性网格，1-各向异性网格
nn_fun = @net_naca0012_quadBC;
%%
[AFT_stack,Coord,~]  = read_grid('../grid/inv_cylinder/tri/inv_cylinder-40.cas', gridType);
% [AFT_stack,Coord,~]  = read_grid('../grid/naca0012/tri/naca0012-tri-quadBC.cas', gridType);
% [AFT_stack,Coord,~]  = read_grid('../grid/naca0012/tri/naca0012-tri.cas', gridType);
%
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
    %     AFT_stack(i,5) = 1e5* AFT_stack(i,5);
%     end
end
AFT_stack_sorted = sortrows(AFT_stack, 5); 
% AFT_stack_sorted = AFT_stack;
% AFT_stack_sorted = sortrows(AFT_stack, 5,'descend');

while size(AFT_stack_sorted,1)>0
    
    if nCells_AFT ==227
        kkk = 1;
    end
    
    size0 = size(AFT_stack_sorted,1);
   
    [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun, stencilType);
    
    while node_select == -1
        al = 1.2 * al;
        [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun, stencilType);
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
    hold on;
    
    interval = 100;
    if(mod(nCells_AFT,interval)==0)
        disp('================================');
        disp('==========推进生成中...==========');
        disp(['nCells = ', num2str(nCells_AFT)]);
        disp(['阵面实时长度：', num2str(size(AFT_stack_sorted,1))]);
        disp(['新增阵面数：',num2str(size1-size0)]);
    end
  %%  
  %找出非活跃阵面，并删除
  for i = 1: size(AFT_stack_sorted,1)
      if((AFT_stack_sorted(i,3) ~= -1) && (AFT_stack_sorted(i,4) ~= -1))  %左单元和右单元编号均不为-1
          Grid_stack(iFace,:) = AFT_stack_sorted(i,:);
          iFace = iFace + 1;
          AFT_stack_sorted(i,:)=-1;
      end
  end
  
  AFT_stack_sorted( AFT_stack_sorted(:,1) == -1, : ) = [];
    

  AFT_stack_sorted = sortrows(AFT_stack_sorted, 5);
  %         AFT_stack_sorted = sortrows(AFT_stack_sorted, 5, 'descend');
  
  if(node_select == -1)
      %%未找到node_select的情况，应该比较少见
      disp('未找到node_select的情况...,无法推进，请检查！');
      node_best = node_best - 1;
      
      tmp = AFT_stack_sorted(1,:);
      AFT_stack_sorted(1,:) = AFT_stack_sorted(2,:);
      AFT_stack_sorted(2,:) = tmp;
  end
end

disp(['阵面推进完成，单元数：', num2str(nCells_AFT)]);
disp(['阵面推进完成，节点数：', num2str(length(xCoord_AFT))]);
disp(['阵面推进完成，面个数：', num2str(size(Grid_stack,1))]);
toc
    
    






