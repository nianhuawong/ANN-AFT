function [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, ...
    Sp, coeff, al, node_best, Grid_stack, nn_fun, stencilType, epsilon)
global cellNodeTopo;

node1_base = AFT_stack_sorted(1,1);         %阵面的基准点
node2_base = AFT_stack_sorted(1,2);
ds = DISTANCE(node1_base, node2_base, xCoord_AFT, yCoord_AFT);  %基准阵面的长度

% [x_best, y_best] = ADD_POINT_tri(AFT_stack_sorted(1,:), xCoord_AFT, yCoord_AFT, Sp);
[x_best, y_best, ~] = ADD_POINT_ANN_quad(nn_fun, AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Grid_stack, stencilType, epsilon );
x_best = x_best(1);
y_best = y_best(1);

%%
node_best = node_best + 1;      %新增最佳点Pbest的序号

% PLOT_CIRCLE(x_best, y_best, al, Sp, ds, node_best);

nodeCandidate = node_best;
for i = 2:size(AFT_stack_sorted,1)
    node1 = AFT_stack_sorted(i,1);
    node2 = AFT_stack_sorted(i,2);
    x_p1 = xCoord_AFT(node1);
    y_p1 = yCoord_AFT(node1);
    
    x_p2 = xCoord_AFT(node2);
    y_p2 = yCoord_AFT(node2);
    
    %         if( (x_p1-x_best)^2 + (y_p1-y_best)^2 < al*al*Sp*Sp*ds*ds &&  node1 ~= node1_base && node1 ~= node2_base)
    if( (x_p1-x_best)^2 + (y_p1-y_best)^2 < al*al*ds*ds &&  node1 ~= node1_base && node1 ~= node2_base)
        nodeCandidate(end+1) = node1;
    end
    %         if( (x_p2-x_best)^2 + (y_p2-y_best)^2 < al*al*Sp*Sp*ds*ds &&  node2 ~= node1_base && node2 ~= node2_base)
    if( (x_p2-x_best)^2 + (y_p2-y_best)^2 < al*al*ds*ds &&  node2 ~= node1_base && node2 ~= node2_base)
        nodeCandidate(end+1) = node2;
    end
end
nodeCandidate = unique(nodeCandidate);
%%
% 临近点的质量参数Qp
Qp = zeros(length(nodeCandidate),1);
xCoord_tmp = [xCoord_AFT; x_best];
yCoord_tmp = [yCoord_AFT; y_best];
for i = 1 : length(nodeCandidate)
    node3 = nodeCandidate(i);
    a = DISTANCE( node1_base, node2_base, xCoord_tmp, yCoord_tmp);  %基准阵面与候选点形成三角形
    b = DISTANCE( node1_base, node3, xCoord_tmp, yCoord_tmp);       %质量参数Qp为内切圆和 外接圆半径之比
    c = DISTANCE( node3, node2_base, xCoord_tmp, yCoord_tmp);
    
    theta = acos( ( a^2 + b^2 - c^2 ) / ( 2.0 * a * b + 1e-40 ) );
    area = 0.5 * a * b * sin(theta);              %三角形面积
    r = 2.0 * area / ( ( a + b + c ) + 1e-40 );   %内切圆半径
    R = a * b * c / 4.0 / ( area + 1e-40 );       %外接圆半径
    
    Qp(i) =   3.0 * r / ( R +  1e-40 );
    
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
%%  在非阵面中查找可能相交的点
nodeCandidate2 = node_best;
for i = 2:size(Grid_stack,1)
    node1 = Grid_stack(i,1);
    node2 = Grid_stack(i,2);
    x_p1 = xCoord_AFT(node1);
    y_p1 = yCoord_AFT(node1);
    
    x_p2 = xCoord_AFT(node2);
    y_p2 = yCoord_AFT(node2);
    
    if( (x_p1-x_best)^2 + (y_p1-y_best)^2 < al*al*Sp*Sp*ds*ds &&  node1 ~= node1_base && node1 ~= node2_base)
        nodeCandidate2(end+1) = node1;
    end
    if( (x_p2-x_best)^2 + (y_p2-y_best)^2 < al*al*Sp*Sp*ds*ds &&  node2 ~= node1_base && node2 ~= node2_base)
        nodeCandidate2(end+1) = node2;
    end
end
nodeCandidate2 = unique(nodeCandidate2);

nodeCandidate_tmp = [nodeCandidate, nodeCandidate2, node1_base, node2_base];
%在非阵面中查找临近面
faceCandidate = [];
for i = 2:size(Grid_stack,1)
    node1 = Grid_stack(i,1);
    node2 = Grid_stack(i,2);      %如果面的2个点有一个是候选点，那么阵面是邻近面
    
    if( size(find(nodeCandidate_tmp == node1), 2) ~= 0 || size(find(nodeCandidate_tmp == node2), 2) ~= 0 )
        faceCandidate(end+1) = i;
    end
end

%     faceCandidateNodes = Grid_stack(faceCandidate,1:2);
%%
%按质量参数逐一选择点，判断是否与临近阵面相交，如相交则下一个候选点，如不相交，则选定该点构成新的三角形
Qp_sort = sort(Qp, 'descend');
node_select = -1;

for i = 1 : length(nodeCandidate)
    node_test_list = nodeCandidate( Qp==Qp_sort(i) );
    %%     %除判断相交外，还需判断是否构成左单元，只选择构成左单元的点
    for j = 1:length(node_test_list)
        node_test = node_test_list(j);
        %         if node_test == 81 && node1_base == 79 && node2_base == 86
        %             kk = 1;
        %         end
        flagNotCross1 = IsNotCross(node1_base, node2_base, node_test, frontCandidate, AFT_stack_sorted, xCoord_tmp, yCoord_tmp ,0);
        if flagNotCross1 == 0
            continue;
        end
        
        flagNotCross2 = IsNotCross(node1_base, node2_base, node_test, ...        %除判断相交外，还需判断是否构成左单元，只选择构成左单元的点
            faceCandidate, Grid_stack, xCoord_tmp, yCoord_tmp,0);
        if flagNotCross2 == 0
            continue;
        end
        
        flagLeftCell = IsLeftCell(node1_base, node2_base, node_test, xCoord_tmp, yCoord_tmp);
        if flagLeftCell == 0
            continue;
        end
        
        neighbor1 = NeighborNodes(node1_base, AFT_stack_sorted, node2_base);
        neighbor2 = NeighborNodes(node2_base, AFT_stack_sorted, node1_base);
        
        neighbor11 = NeighborOfNeighborNodes(neighbor1, AFT_stack_sorted);
        neighbor22 = NeighborOfNeighborNodes(neighbor2, AFT_stack_sorted);
        
        flagSpecial = 0;
        if( size(find(neighbor11==node_test),2) == 0 && size(find(neighbor22==node_test),2) == 0)
            flagSpecial = 1;
        end
        %          if flagSpecial == 0
        %             continue;
        %         end
        
        %         if flagNotCross1 == 1 && flagNotCross2 == 1 && flagLeftCell == 1 && flagSpecial == 1
        %             node_select = node_test;
        %             break;
        %         end
        
        flagInCell = IsPointInCell(cellNodeTopo, xCoord_tmp, yCoord_tmp, node_test);
        if flagInCell == 1
            continue;
        end
        
        flagDiag   = IsPointDiagnoal(cellNodeTopo, node1_base, node2_base, node_test);
        if flagDiag == 1
            continue;
        end
        
        if node_test == node_best
            flagClose = IsPointClose2Edge([Grid_stack;AFT_stack_sorted], xCoord_tmp, yCoord_tmp, node_test);
            if flagClose == 1
                continue;
            end
        end
        
        node_select = node_test;
        break;
%         if flagNotCross1 == 1 && flagNotCross2 == 1 && flagLeftCell == 1 && flagInCell == 0 && flagDiag == 0
%             node_select = node_test;
%             break;
%         end
    end
    
    if node_select ~= -1
        break;
    end
end

if(node_select == node_best)    %只有在选择了新生成的点时，才需要将新点坐标存下来
    xCoord_AFT(end+1) = x_best;
    yCoord_AFT(end+1) = y_best;
    flag_best = 1;
    
    coordX = x_best;
    coordY = y_best;
else
    flag_best = 0;
    node_best = node_best - 1;   %如果没有选择Pbest，则编号要回退1
    
    coordX = -1;
    coordY = -1;
end
end