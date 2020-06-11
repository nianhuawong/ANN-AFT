clear;clc;
tic
format long
%%
gridType    = 0;        % 0-单一单元网格，1-混合单元网格
Sp          = 1.0;      % 网格步长  % Sp = sqrt(3.0)/2.0;  %0.866
al          = 3.0;      % 在几倍范围内搜索
coeff       = 0.8;      % 尽量选择现有点的参数，Pbest质量参数的系数
dt          = 0.01;   % 暂停时长
%%
[AFT_stack,Coord,~]  = read_grid('./grid/tri2.cas', gridType);
%%
nodeList = AFT_stack(:,1:2);
node_num = max( max(nodeList)-min(nodeList)+1 );%边界点的个数，或者，初始阵面点数
xCoord_AFT = Coord(1:node_num,1);                %初始阵面点坐标
yCoord_AFT = Coord(1:node_num,2);

% nodeList = unique([nodeList(:,1);nodeList(:,2)]);
% node_num = length(nodeList);
% xCoord_AFT = Coord(nodeList,1);
% yCoord_AFT = Coord(nodeList,2);

PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);

%%
% 选择最小阵面，生成Pbest
nCells_AFT = 0;
iFace = 1;
Grid_stack = [];
node_best = node_num;     %初始时最佳点Pbest的序号

%%  先将边界阵面推进
for i =1:size(AFT_stack,1)
    AFT_stack(i,5) = 0.00001* AFT_stack(i,5);
end
%%
AFT_stack_sorted = sortrows(AFT_stack, 5);
while size(AFT_stack_sorted,1)>0
    node_select = [-1,-1];
    flag_best   = [1 1];
    
    [x_best_quad, y_best_quad] = ADD_POINT(AFT_stack_sorted(1,:), xCoord_AFT, yCoord_AFT, Sp);
    
    if nCells_AFT == 31
        kkk = 1;
    end
    
    for ii = 1:2
        node_best = node_best + 1;      %新增最佳点Pbest的序号
        x_best = x_best_quad(ii);       %新增最佳点Pbest的坐标
        y_best = y_best_quad(ii);
        
        %%
        % 查询临近点
        % 可以画出圆来看看临近点有哪些
        %     figure;
        %         PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);
        %         hold on;
        %         plot(x_best,y_best,'*')
        %         hold on;
        %         text(x_best+0.1,y_best,num2str(node_best), 'Color', 'red', 'FontSize', 14);
        %         syms xxx yyy;
        %     % %     ezplot((xxx-x_best)^2+(yyy-y_best)^2==al*al*Sp*Sp*ds*ds);
        %         fimplicit(@(xxx,yyy) (xxx-x_best)^2+(yyy-y_best)^2-al*al*Sp*Sp*ds*ds);
        %         hold on;
        pause(dt);
        %%
        node1_base = AFT_stack_sorted(1,1);         %阵面的基准点
        node2_base = AFT_stack_sorted(1,2);
        ds = DISTANCE(node1_base, node2_base, xCoord_AFT, yCoord_AFT);  %基准阵面的长度
        
        %在现有阵面中，查找临近点，作为候选点，与 新增点或基准阵面中点 的距离小于al*Sp*ds的点，要遍历除自己外的所有阵面
        nodeCandidate = node_best;
        
        x_mid = 0.5 * (xCoord_AFT(node1_base) + xCoord_AFT(node2_base));
        y_mid = 0.5 * (yCoord_AFT(node1_base) + yCoord_AFT(node2_base));
        
        for i = 2:size(AFT_stack_sorted,1)
            node1 = AFT_stack_sorted(i,1);
            node2 = AFT_stack_sorted(i,2);
            x_p1 = xCoord_AFT(node1);
            y_p1 = yCoord_AFT(node1);
            
            x_p2 = xCoord_AFT(node2);
            y_p2 = yCoord_AFT(node2);
            
            %             if( (x_p1-x_best)^2 + (y_p1-y_best)^2 < al*al*Sp*Sp*ds*ds &&  node1 ~= node1_base && node1 ~= node2_base)
            if( (x_p1-x_mid)^2 + (y_p1-y_mid)^2 < al*al*Sp*Sp*ds*ds &&  node1 ~= node1_base && node1 ~= node2_base)
                nodeCandidate(end+1) = node1;
            end
            %             if( (x_p2-x_best)^2 + (y_p2-y_best)^2 < al*al*Sp*Sp*ds*ds &&  node2 ~= node1_base && node2 ~= node2_base)
            if( (x_p2-x_mid)^2 + (y_p2-y_mid)^2 < al*al*Sp*Sp*ds*ds &&  node2 ~= node1_base && node2 ~= node2_base)
                nodeCandidate(end+1) = node2;
            end
        end
        nodeCandidate = unique(nodeCandidate);
        %%
        % 临近点的质量参数Qp
        Qp = zeros(length(nodeCandidate),1);
        
        xCoord_tmp = [xCoord_AFT; x_best];
        yCoord_tmp = [yCoord_AFT; y_best];
        
        a = DISTANCE( node1_base, node2_base, xCoord_tmp, yCoord_tmp);
        v_base = [xCoord_tmp(node2_base)-xCoord_tmp(node1_base), yCoord_tmp(node2_base)-yCoord_tmp(node1_base)];
        
        for i = 1 : length(nodeCandidate)
            node3 = nodeCandidate(i);
            if ii == 1
                b = DISTANCE( node1_base, node3, xCoord_tmp, yCoord_tmp);
                v_new = [xCoord_tmp(node3)-xCoord_tmp(node1_base), yCoord_tmp(node3)-yCoord_tmp(node1_base)];
            elseif ii == 2
                b = DISTANCE( node2_base, node3, xCoord_tmp, yCoord_tmp);
                v_new = [xCoord_tmp(node3)-xCoord_tmp(node2_base), yCoord_tmp(node3)-yCoord_tmp(node2_base)];
            end
            
            
            Qp(i) = 1.0 / ( ( 2.0 * b/a - Sp ) + abs(v_base * v_new' ) );   %四边形网格的质量参数新增边长度最好等于基准阵面，新增边与基准阵面的夹角最好接近90°
            
            if( node3 == node_best )            %为了尽量选择现有阵面上的点，将Pbest的质量降低一点
                Qp(i) = coeff * Qp(i);
            end
        end
        
        %%
        % 查询临近阵元，为避免与邻近阵面相交
        frontCandidate = [];
        nodeCandidate_tmp = [nodeCandidate, node1_base, node2_base];
        for i = 2:size(AFT_stack_sorted,1)
            node1 = AFT_stack_sorted(i,1);
            node2 = AFT_stack_sorted(i,2);      %如果阵面的2个点都是候选点，那么阵面是邻近阵面
            
            %         if( size(find(nodeCandidate_tmp == node1), 2) ~= 0 && size(find(nodeCandidate_tmp == node2), 2) ~= 0 )
            if( size(find(nodeCandidate_tmp == node1), 2) ~= 0 || size(find(nodeCandidate_tmp == node2), 2) ~= 0 )
                frontCandidate(end+1) = i;
            end
        end
        
        frontCandidateNodes = AFT_stack_sorted(frontCandidate,1:2);
        %%
        %按质量参数逐一选择点，判断是否与临近阵面相交，如相交则下一个候选点，如不相交，则选定该点构成新的三角形
        Qp_sort = sort(Qp, 'descend');
        
        for i = 1 : length(nodeCandidate)
            node_test_list = nodeCandidate( find(Qp==Qp_sort(i)) );
            for j = 1:length(node_test_list)
                node_test = node_test_list(j);
                flagNotCross = IsNotCross(node1_base, node2_base, node_test, ...        %除判断相交外，还需判断是否构成左单元，只选择构成左单元的点
                    frontCandidate, AFT_stack_sorted, xCoord_tmp, yCoord_tmp,ii);
                flagLeftCell = IsLeftCell(node1_base, node2_base, node_test, xCoord_tmp, yCoord_tmp);
                
                if flagNotCross == 1 && flagLeftCell == 1
                    node_select(ii) = node_test;
                    
                    flagNotCross2 = 1;                                          %除判断新增点与基准阵面连线是否与现有阵面相交外，还需要判断新增的2个点S1 S2的连线是否与现有阵面相交
                    if( node_select(2)~= -1 )
                        flagNotCross2 = IsNotCross(node_select(1), node2_base, node_select(2), ...
                            frontCandidate, AFT_stack_sorted, xCoord_tmp, yCoord_tmp, 1);
                    end
                    if flagNotCross2 == 1               %如果不相交，则可以
                        break;
                    else
                        node_select(ii) = -1;           %如果相交，则要再次选择
                    end
                end
            end
            
            if node_select(ii) ~= -1
                if(node_select(ii) == node_best)    %只有在选择了新生成的点时，才需要将新点坐标存下来
                    xCoord_AFT(end+1) = x_best;
                    yCoord_AFT(end+1) = y_best;
                elseif( node_select(ii)~= node_best)
                    flag_best(ii) = 0;
                    node_best = node_best - 1;%如果没有选择Pbest，则编号要回退1
                end
                break;
            end
        end
    end
    %%
    if nCells_AFT == 22
        kkk = 1;
    end
    %%
    %阵面及左单元编号更新
    size0 = size(AFT_stack_sorted,1);
    nCells_AFT = nCells_AFT + 1;
    AFT_stack_sorted = Update_AFT_INFO(AFT_stack_sorted, node1_base, ...
        node2_base, node_select,nCells_AFT, xCoord_AFT, yCoord_AFT);
    
    %%
    %新增点和阵面之后，除了基准阵面形成的单元，还有可能会自动构成多个单元，需要判断。
    %在已有阵面中查找自动构成的单元，判断方法为邻点的邻点 与邻点相邻，则构成封闭单元
    if(flag_best(1)== 0 || flag_best(2)== 0 )
        neighbor1 =[];
        if( flag_best(1)== 0) %没有选择pbest，而是选择了现有点，有可能导致新增几个单元              
            neighbor1 = NeighborNodes(node_select(1), AFT_stack_sorted);%找出现有点的相邻点
            neighbor1 = [node1_base, neighbor1];
            neighbor1 = unique(neighbor1);
        end
        
        neighbor2 =[];
        if( flag_best(2) == 0 ) %没有选择pbest，而是选择了现有点，有可能导致新增几个单元
            neighbor2 = NeighborNodes(node_select(2), AFT_stack_sorted);%找出现有点的相邻点
            neighbor2 = [node2_base, neighbor2];
            neighbor2 = unique(neighbor2);           
        end
%%
        % %邻点的邻点 和 邻点 中若是有互相相邻的，则形成新单元
        new_cell = [];
        for i = 1:length(neighbor1)
            neighborNode = neighbor1(i); %邻点
            for j = 1: size(AFT_stack_sorted,1)
                if( AFT_stack_sorted(j,1) == neighborNode && AFT_stack_sorted(j,2)~= node_select(1)) %邻点所在阵面j
                    neighborNodeOfNeighbor = AFT_stack_sorted(j,2); %邻点的邻点
                    
                    if( find(neighbor1==neighborNodeOfNeighbor) )  %邻点的邻点如果相邻，则为三角形
                        new_cell(end+1,:) = [node_select(1), neighborNode, neighborNodeOfNeighbor, -11];
                    end
                    
                    for k = 1:size(AFT_stack_sorted,1)
                        if( AFT_stack_sorted(k,1) == neighborNodeOfNeighbor && AFT_stack_sorted(k,2)~= neighborNode )   %邻点的邻点所在阵面k
                            if(find(neighbor1==AFT_stack_sorted(k,2)))   %邻点的邻点的邻点AFT_stack_sorted(k,2)
                                new_cell(end+1,:) = [node_select(1), neighborNode, neighborNodeOfNeighbor, AFT_stack_sorted(k,2)];
                            end
                        elseif ( AFT_stack_sorted(k,2) == neighborNodeOfNeighbor && AFT_stack_sorted(k,1)~= neighborNode )   %邻点的邻点所在阵面k
                            if(find(neighbor1==AFT_stack_sorted(k,1)))   %邻点的邻点的邻点AFT_stack_sorted(k,1)
                                new_cell(end+1,:) = [node_select(1), neighborNode, neighborNodeOfNeighbor, AFT_stack_sorted(k,1)];
                            end
                        end
                    end
                elseif( AFT_stack_sorted(j,2) == neighborNode && AFT_stack_sorted(j,1)~= node_select(1)) %邻点所在阵面j
                    neighborNodeOfNeighbor = AFT_stack_sorted(j,1);%邻点的邻点
                    
                    if( find(neighbor1==neighborNodeOfNeighbor) )  %邻点的邻点如果相邻，则为三角形
                        new_cell(end+1,:) = [node_select(1), neighborNode, neighborNodeOfNeighbor, -11];
                    end
                    
                    for k = 1:size(AFT_stack_sorted,1)
                        if( AFT_stack_sorted(k,1) == neighborNodeOfNeighbor && AFT_stack_sorted(k,2)~= neighborNode )%邻点的邻点所在阵面
                            if(find(neighbor1==AFT_stack_sorted(k,2)))
                                new_cell(end+1,:) = [node_select(1), neighborNode, neighborNodeOfNeighbor, AFT_stack_sorted(k,2)];
                            end
                        elseif (AFT_stack_sorted(k,2) == neighborNodeOfNeighbor && AFT_stack_sorted(k,1)~= neighborNode )
                            if(find(neighbor1==AFT_stack_sorted(k,1)))
                                new_cell(end+1,:) = [node_select(1), neighborNode, neighborNodeOfNeighbor, AFT_stack_sorted(k,1)];
                            end
                        end
                    end
                end
            end
        end
        
        for i = 1:length(neighbor2)
            neighborNode = neighbor2(i); %邻点
            for j = 1: size(AFT_stack_sorted,1)
                if( AFT_stack_sorted(j,1) == neighborNode && AFT_stack_sorted(j,2)~= node_select(2)) %邻点所在阵面
                    neighborNodeOfNeighbor = AFT_stack_sorted(j,2); %邻点的邻点
                    %
                    if( find(neighbor2==neighborNodeOfNeighbor) )  %邻点的邻点如果相邻，则为三角形
                        new_cell(end+1,:) = [node_select(2), neighborNode, neighborNodeOfNeighbor, -22];
                    end
                    
                    for k = 1:size(AFT_stack_sorted,1)
                        if( AFT_stack_sorted(k,1) == neighborNodeOfNeighbor && AFT_stack_sorted(k,2)~= neighborNode)   %邻点的邻点所在阵面
                            if(find(neighbor2==AFT_stack_sorted(k,2)))   %邻点的邻点的邻点AFT_stack_sorted(k,2)
                                new_cell(end+1,:) = [node_select(2), neighborNode, neighborNodeOfNeighbor, AFT_stack_sorted(k,2)];
                            end
                        elseif ( AFT_stack_sorted(k,2) == neighborNodeOfNeighbor && AFT_stack_sorted(k,1)~= neighborNode )   %邻点的邻点所在阵面
                            if(find(neighbor2==AFT_stack_sorted(k,1)))   %邻点的邻点的邻点AFT_stack_sorted(k,2)
                                new_cell(end+1,:) = [node_select(2), neighborNode, neighborNodeOfNeighbor, AFT_stack_sorted(k,1)];
                            end
                        end
                    end
                elseif( AFT_stack_sorted(j,2) == neighborNode && AFT_stack_sorted(j,1)~= node_select(2)) %邻点所在阵面
                    neighborNodeOfNeighbor = AFT_stack_sorted(j,1);%邻点的邻点
                    %
                    if( find(neighbor2==neighborNodeOfNeighbor) )  %邻点的邻点如果相邻，则为三角形
                        new_cell(end+1,:) = [node_select(2), neighborNode, neighborNodeOfNeighbor, -22];
                    end
                    
                    for k = 1:size(AFT_stack_sorted,1)
                        if( AFT_stack_sorted(k,1) == neighborNodeOfNeighbor && AFT_stack_sorted(k,2)~= neighborNode )%邻点的邻点所在阵面
                            if(find(neighbor2==AFT_stack_sorted(k,2)))
                                new_cell(end+1,:) = [node_select(2), neighborNode, neighborNodeOfNeighbor, AFT_stack_sorted(k,2)];
                            end
                        elseif (AFT_stack_sorted(k,2) == neighborNodeOfNeighbor && AFT_stack_sorted(k,1)~= neighborNode )
                            if(find(neighbor2==AFT_stack_sorted(k,1)))
                                new_cell(end+1,:) = [node_select(2), neighborNode, neighborNodeOfNeighbor, AFT_stack_sorted(k,1)];
                            end
                        end
                    end
                end
            end
        end
        % %
        % %         去掉重复的单元
        for i = 1 : size(new_cell,1)
            iCell = new_cell(i,:);
            for j = i+1:size(new_cell,1)
                jCell = new_cell(j,:);
                if( sum(unique(jCell) == unique(iCell)) == 4 )
                    new_cell(j,:)=-1;
                end
            end
        end
        
        II = find(new_cell(:,1) == -1);
        new_cell(II,:)=[];
        
        % %         还要去掉已经有的单元
        for i = 1 : size(new_cell,1)
            iCell = new_cell(i,:);
            if(iCell(4)==-11)    %三角形
                if(size(find(iCell==node1_base),2) && size(find(iCell==node2_base),2) ...
                        && size(find(iCell==node_select(1)),2))
                    new_cell(i,:)=-1;
                end
            elseif(iCell(4)==-22) %三角形
                if(size(find(iCell==node1_base),2) && size(find(iCell==node2_base),2) ...
                        && size(find(iCell==node_select(2)),2))
                    new_cell(i,:)=-1;
                end
            else               %四边形
                if(size(find(iCell==node1_base),2) && size(find(iCell==node2_base),2) ...
                        && size(find(iCell==node_select(1)),2)&& size(find(iCell==node_select(2)),2))
                    new_cell(i,:)=-1;
                end
            end
        end
        
        II = find(new_cell(:,1) == -1);
        new_cell(II,:)=[];
        % %         将新单元加入数据结构
        for i = 1:size(new_cell,1)
            nCells_AFT = nCells_AFT + 1;
            node1 = new_cell(i,1);
            node2 = new_cell(i,2);
            node3 = new_cell(i,3);
            node4 = new_cell(i,4);
            if (node4 > 0)
                AFT_stack_sorted = Update_AFT_INFO_GENERAL(AFT_stack_sorted, ...
                    node1, node2, node3, node4, nCells_AFT , xCoord_AFT, yCoord_AFT);
            elseif (node4 < 0)
                AFT_stack_sorted = Update_AFT_INFO_GENERAL_TRI(AFT_stack_sorted, ...
                    node1, node2, node3, nCells_AFT , xCoord_AFT, yCoord_AFT);
            end
            
        end
    end
    %% ==============================================
    size1 = size(AFT_stack_sorted,1);
    PLOT_NEW_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, size1-size0);
    hold on;
    
    %     PLOT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT);
    %     hold on;
    
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
    
    AFT_stack_sorted( find(AFT_stack_sorted(:,1) == -1), : ) = [];
    
    AFT_stack_sorted = sortrows(AFT_stack_sorted, 5);
end

disp(['阵面推进完成，单元数：', num2str(nCells_AFT)]);
disp(['阵面推进完成，节点数：', num2str(length(xCoord_AFT))]);
disp(['阵面推进完成，面个数：', num2str(size(Grid_stack,1))]);
toc








