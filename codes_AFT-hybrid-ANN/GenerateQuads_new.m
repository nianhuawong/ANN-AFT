function [node_select,coordX, coordY, flag_best] = GenerateQuads_new(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, ...
    Sp, coeff, al, node_best, Grid_stack, nn_fun )
global cellNodeTopo stencilType epsilon useANN;
node_select = [-1,-1];
flag_best   = [0, 0];

node1_base = AFT_stack_sorted(1,1);         %阵面的基准点
node2_base = AFT_stack_sorted(1,2);
ds_base = DISTANCE(node1_base, node2_base, xCoord_AFT, yCoord_AFT);  %基准阵面的长度

%%
if useANN == 1 
    [x_best_quad, y_best_quad, Sp] = ADD_POINT_ANN_quad(nn_fun, AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Grid_stack, stencilType, epsilon, Sp);
else
    [x_best_quad, y_best_quad, Sp] = ADD_POINT_quad(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp);
end
                                                
% PLOT_CIRCLE(x_best_quad, y_best_quad, al, Sp, ds_base, node_best);
%%
%如果生成的2个点距离非常小，则认为是1个点，或者新点连线与阵面的夹角接近90°，生成三角形
if  length(x_best_quad) == 1 && length(y_best_quad) == 1
    node_select = [-1,-1];
    coordX = -1;
    coordY = -1;
    return;
end    

xCoord_tmp = [xCoord_AFT; x_best_quad];
yCoord_tmp = [yCoord_AFT; y_best_quad];

x_best1 = x_best_quad(1);x_best2 = x_best_quad(2);
y_best1 = y_best_quad(1);y_best2 = y_best_quad(2);

al2 = 0.8;
while sum(node_select) == -2
    
candidateList1 = NodeCandidate(AFT_stack_sorted, node1_base, node2_base, xCoord_AFT, yCoord_AFT, [x_best1, y_best1], al2*Sp);
candidateList2 = NodeCandidate(AFT_stack_sorted, node1_base, node2_base, xCoord_AFT, yCoord_AFT, [x_best2, y_best2], al2*Sp);

candidateList1(end+1) = node_best + 1;
candidateList2(end+1) = node_best + 2;

node_tmp1 = NodeCandidate([Grid_stack;AFT_stack_sorted], node1_base, node2_base, xCoord_AFT, yCoord_AFT, [x_best1, y_best1], al * Sp );
node_tmp2 = NodeCandidate([Grid_stack;AFT_stack_sorted], node1_base, node2_base, xCoord_AFT, yCoord_AFT, [x_best2, y_best2], al * Sp );

nodeCandidate_tmp = [node_tmp1(:)', node_tmp2(:)', node1_base, node2_base];
frontCandidate = FrontCandidate(AFT_stack_sorted, nodeCandidate_tmp);
faceCandidate = FrontCandidate(Grid_stack, nodeCandidate_tmp);

M = length(candidateList1);
N = length(candidateList2);
Qp = zeros(M,N);
for i = 1:M
    node_select1 = candidateList1(i);
    for j = 1:N     
        node_select2 = candidateList2(j);
        if node_select1 ~= node_select2
            [quality,~] = QualityCheckQuad(node1_base, node2_base, node_select2, node_select1, xCoord_tmp, yCoord_tmp, Sp);
%             quality = QualityCheckQuad_new(node1_base, node2_base, node_select2, node_select1, xCoord_tmp, yCoord_tmp);
            Qp(i,j) = quality;
            if node_select1 > node_best && node_select2 > node_best
                Qp(i,j) = coeff * coeff * Qp(i,j);
            elseif node_select1 > node_best || node_select2 > node_best
                Qp(i,j) = coeff * Qp(i,j);               
            end
        end
    end
end

Qp_sort = sort(Qp(:),'descend'); 
for i = 1:M*N
    [row,col] = find(Qp==Qp_sort(i));
    node_select1 = candidateList1(row(1));
    node_select2 = candidateList2(col(1));
    
    flagNotCross = IsNotCrossAll(node1_base, node2_base, node_select1, node_select2,...
                              frontCandidate, AFT_stack_sorted, faceCandidate, Grid_stack, ...
                              xCoord_tmp, yCoord_tmp);    
      if flagNotCross == 0
          continue;
      end
                       
    flagLeftCell1 = IsLeftCell(node1_base, node2_base, node_select1, xCoord_tmp, yCoord_tmp);
    flagLeftCell2 = IsLeftCell(node1_base, node2_base, node_select2, xCoord_tmp, yCoord_tmp);
    if flagLeftCell1 == 0 || flagLeftCell2 == 0
        continue;
    end
    
    flagInCell1 = IsPointInCell(cellNodeTopo, xCoord_tmp, yCoord_tmp, node_select1);
    flagInCell2 = IsPointInCell(cellNodeTopo, xCoord_tmp, yCoord_tmp, node_select2);
    if flagInCell1 == 1 || flagInCell2 == 1
        continue;
    end
    
    flagDiag1   = IsPointDiagnoal(cellNodeTopo, node1_base, node2_base, node_select1);
    flagDiag2   = IsPointDiagnoal(cellNodeTopo, node1_base, node2_base, [node_select1,node_select2]);
    if flagDiag1 == 1 || flagDiag2 == 1
        continue;
    end

    if node_select1 == node_best + 1 || node_select1 == node_best + 2
        flagClose1 = IsPointClose2Edge([Grid_stack;AFT_stack_sorted], xCoord_tmp, yCoord_tmp, node_select1, Sp);
        if flagClose1 == 1
            continue;
        end
    end
    
    if node_select2 == node_best + 2 || node_select2 == node_best + 1
        flagClose2 = IsPointClose2Edge([Grid_stack;AFT_stack_sorted], xCoord_tmp, yCoord_tmp, node_select2, Sp);
        if flagClose2 == 1
            continue;
        end
    end  
    
%     flagClose1 = IsEdgeClose2Point([node1_base,node_select1], xCoord_tmp, yCoord_tmp, node2_base);
%     if flagClose1 == 1
%         continue;
%     end
%     
%     flagClose2 = IsEdgeClose2Point([node2_base,node_select2], xCoord_tmp, yCoord_tmp, node1_base);
%     if flagClose2 == 1
%         continue;
%     end
    
%     flagClose3 = IsEdgeClose2Point([node_select1,node_select2], xCoord_tmp, yCoord_tmp, -1); 
%     if flagClose3 == 1
%         continue;
%     end
    
    node_select = [node_select1,node_select2];
    break;
end
al2 = 2.0 * al2;
[quality,~] = QualityCheckQuad(node1_base, node2_base, node_select(2), node_select(1), xCoord_tmp, yCoord_tmp, Sp);
if ( quality > epsilon && sum(node_select) > 0 ) || al2 > 3.2
    break;
end
end

if node_select(1) == node_best + 1
    xCoord_AFT(end+1) = x_best1;
    yCoord_AFT(end+1) = y_best1;
    flag_best(1) = 1;
elseif node_select(1) == node_best + 2
    xCoord_AFT(end+1) = x_best2;
    yCoord_AFT(end+1) = y_best2;
    flag_best(1) = 1;    
end

if node_select(2) == node_best + 1
    xCoord_AFT(end+1) = x_best1;
    yCoord_AFT(end+1) = y_best1;
    flag_best(2) = 1;
elseif node_select(2) == node_best + 2
    xCoord_AFT(end+1) = x_best2;
    yCoord_AFT(end+1) = y_best2;
    flag_best(2) = 1;   
end 

if flag_best(1) == 0 && flag_best(2) == 1
    node_select(2) = node_select(2) - 1;
end


%%
%选择的边不能在Grid_stack里存在，即不能为非活跃面
[row1, ~ ] = FrontExist(node1_base,node_select(1), Grid_stack);
[row2, ~ ] = FrontExist(node2_base,node_select(2), Grid_stack);
[row3, ~ ] = FrontExist(node_select(1),node_select(2), Grid_stack);
if row1 ~= -1 || row2 ~= -1 || row3 ~= -1
    node_select = [-1,-1];
    coordX = -1;
    coordY = -1;
    return;
end

%如果选择了同一个点，不可以生成四边形
if node_select(1) == node_select(2)
    node_select = [-1,-1];
    coordX = -1;
    coordY = -1;
    return;
end

%如果找不到合适的点，则无法生成四边形
if sum(node_select==-1)>0   
    node_select = [-1,-1];
    coordX = -1;
    coordY = -1;
    return;
end

% 判断四边形质量，如果质量太差，就生成三角形单元
[quality,~] = QualityCheckQuad(node1_base, node2_base, node_select(2), node_select(1), xCoord_AFT, yCoord_AFT, Sp);
if quality < epsilon
    node_select = [-1,-1];
    coordX = -1;
    coordY = -1;
else
    coordX = xCoord_AFT(end-sum(flag_best)+1:end);
    coordY = yCoord_AFT(end-sum(flag_best)+1:end);
end

end