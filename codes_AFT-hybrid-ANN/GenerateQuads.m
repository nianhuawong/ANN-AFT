function [node_select,coordX, coordY, flag_best] = GenerateQuads(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, ...
    Sp, coeff, al, node_best, Grid_stack, nn_fun, stencilType)

node_select = [-1,-1];
flag_best   = [1 1];
% [x_best_quad, y_best_quad] = ADD_POINT_quad(AFT_stack_sorted(1,:), xCoord_AFT, yCoord_AFT, Sp);
[x_best_quad, y_best_quad] = ADD_POINT_ANN_quad(nn_fun, AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Grid_stack, stencilType);

%%
% plot(x_best_quad,y_best_quad,'*')
node1_base = AFT_stack_sorted(1,1);         %阵面的基准点
node2_base = AFT_stack_sorted(1,2);

v_base = [xCoord_AFT(node2_base)-xCoord_AFT(node1_base), yCoord_AFT(node2_base)-yCoord_AFT(node1_base)];
v_newpoint = [x_best_quad(1)-x_best_quad(2), y_best_quad(1)-y_best_quad(2)];

dd1 = sqrt( v_base(1)^2 + v_base(2)^2 );
dd2 = sqrt( v_newpoint(1)^2 + v_newpoint(2)^2 );
angle = acos( v_base * v_newpoint'/ dd1 / dd2 );
angle = angle / pi * 180;
% dd2 / dd1
% angle
%如果生成的2个点距离非常小，则认为是1个点，或者新点连线与阵面的夹角接近90°，生成三角形
if  dd2 / dd1 < 0.4 || ( abs(angle) - 90 ) < 10
    node_select = [-1,-1];
    coordX = -1;
    coordY = -1;
    return;
end
    
% if nCells_AFT == 24
%     kkk = 1;
% end

for ii = 1:2
    node_best = node_best + 1;      %新增最佳点Pbest的序号
    x_best = x_best_quad(ii);       %新增最佳点Pbest的坐标
    y_best = y_best_quad(ii);
    
    %%
    % 查询临近点
%     node1_base = AFT_stack_sorted(1,1);         %阵面的基准点
%     node2_base = AFT_stack_sorted(1,2);
    ds = DISTANCE(node1_base, node2_base, xCoord_AFT, yCoord_AFT);  %基准阵面的长度
    
%     PLOT_CIRCLE(x_best, y_best, al, Sp, ds, node_best);
    
    %在现有阵面中，查找临近点，作为候选点，与 新增点或基准阵面中点 的距离小于al*Sp*ds的点，要遍历除自己外的所有阵面
    nodeCandidate = node_best;     
    for i = 2:size(AFT_stack_sorted,1)
        node1 = AFT_stack_sorted(i,1);
        node2 = AFT_stack_sorted(i,2);
        x_p1 = xCoord_AFT(node1);
        y_p1 = yCoord_AFT(node1);
        
        x_p2 = xCoord_AFT(node2);
        y_p2 = yCoord_AFT(node2);
        
        if( (x_p1-x_best)^2 + (y_p1-y_best)^2 < al*al*Sp*Sp*ds*ds &&  node1 ~= node1_base && node1 ~= node2_base)
            nodeCandidate(end+1) = node1;
        end
        if( (x_p2-x_best)^2 + (y_p2-y_best)^2 < al*al*Sp*Sp*ds*ds &&  node2 ~= node1_base && node2 ~= node2_base)
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
%     frontCandidateNodes = AFT_stack_sorted(frontCandidate,1:2);

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
    if size(Grid_stack,1)>0
        faceCandidateNodes = Grid_stack(faceCandidate,1:2);
    end
    %%
    %按质量参数逐一选择点，判断是否与临近阵面相交，如相交则下一个候选点，如不相交，则选定该点构成新的三角形
    Qp_sort = sort(Qp, 'descend');
    
    for i = 1 : length(nodeCandidate)
        node_test_list = nodeCandidate( Qp==Qp_sort(i) );
        for j = 1:length(node_test_list)
            node_test = node_test_list(j);
            flagNotCross1 = IsNotCross(node1_base, node2_base, node_test, ...        %除判断相交外，还需判断是否构成左单元，只选择构成左单元的点
                frontCandidate, AFT_stack_sorted, xCoord_tmp, yCoord_tmp,ii);
            
             flagNotCross2 = IsNotCross(node1_base, node2_base, node_test, ...        %除判断相交外，还需判断是否构成左单元，只选择构成左单元的点
                faceCandidate, Grid_stack, xCoord_tmp, yCoord_tmp,ii);  
            
            flagLeftCell = IsLeftCell(node1_base, node2_base, node_test, xCoord_tmp, yCoord_tmp);
            
            neighbor1 = NeighborNodes(node1_base, AFT_stack_sorted, node2_base);
            neighbor2 = NeighborNodes(node2_base, AFT_stack_sorted, node1_base);
            
            neighbor1(neighbor1==node2_base)=[];
            neighbor2(neighbor2==node1_base)=[];
            
            neighbor11 = NeighborOfNeighborNodes(neighbor1, AFT_stack_sorted);
            neighbor22 = NeighborOfNeighborNodes(neighbor2, AFT_stack_sorted);
            
            flagSpecial = 0;
            if( size(find(neighbor11==node_test),2) == 0 && ii == 1 )
                flagSpecial = 1;
            end
            if( size(find(neighbor22==node_test),2) == 0 && ii == 2)
                flagSpecial = 1;
            end
            
%             flagSpecial_2 = 0;
%             if flagSpecial == 1
%                 
%             end
            
            if flagNotCross1 == 1 && flagNotCross2 == 1 && flagLeftCell == 1 && flagSpecial == 1 
                node_select(ii) = node_test;
                
                flagNotCross3 = 1;                                          %除判断新增点与基准阵面连线是否与现有阵面相交外，还需要判断新增的2个点S1 S2的连线是否与现有阵面相交
                flagNotCross4 = 1;
                if( node_select(2)~= -1 )
                    flagNotCross3 = IsNotCross(node_select(1), node2_base, node_select(2), ...
                        frontCandidate, AFT_stack_sorted, xCoord_tmp, yCoord_tmp, 1);
                    
                    flagNotCross4 = IsNotCross(node_select(1), node2_base, node_select(2), ...
                        faceCandidate, Grid_stack, xCoord_tmp, yCoord_tmp, 1);
                end
                
                if flagNotCross3 == 1 &&  flagNotCross4 == 1             %如果不相交，则可以
                    break;
                else
                    node_select(ii) = -1;           %如果相交，则要再次选择                          
                end
            end
        end
        
        if node_select(ii) ~= -1
            break;
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
    else
        flag_best(ii) = 0;
        node_best = node_best - 1;%如果没有选择Pbest，则编号要回退1
    end
end


%%
% 判断四边形质量，如果质量太差，就生成三角形单元
if sum(node_select==-1)>0   %如果找不到合适的点，则无法生成四边形
    node_select = [-1,-1];
    coordX = -1;
    coordY = -1;
else
    quality = QualityCheckQuad(node1_base, node2_base, node_select(1), node_select(2), xCoord_AFT, yCoord_AFT, Sp);
    if quality < 0.8
        node_select = [-1,-1];
        coordX = -1;
        coordY = -1;
    else
        coordX = xCoord_AFT(end-sum(flag_best)+1:end);
        coordY = yCoord_AFT(end-sum(flag_best)+1:end);
    end
end
end