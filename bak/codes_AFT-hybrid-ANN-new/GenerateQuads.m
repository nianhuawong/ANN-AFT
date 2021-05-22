function [node_select,coordX, coordY, flag_best] = GenerateQuads(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, ...
    Sp, coeff, al, node_best, Grid_stack, nn_fun )
global cellNodeTopo stencilType epsilon;
node_select = [-1,-1];
flag_best   = [0, 0];

node1_base = AFT_stack_sorted(1,1);         %����Ļ�׼��
node2_base = AFT_stack_sorted(1,2);
ds = DISTANCE(node1_base, node2_base, xCoord_AFT, yCoord_AFT);  %��׼����ĳ���

%%
[x_best_quad, y_best_quad, Sp] = ADD_POINT_quad(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp);
% [x_best_quad, y_best_quad, Sp] = ADD_POINT_ANN_quad(nn_fun, AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Grid_stack, stencilType, epsilon);
                                                
%     PLOT_CIRCLE(x_best_quad, y_best_quad, al, Sp, ds, node_best);
%%
%������ɵ�2�������ǳ�С������Ϊ��1���㣬�����µ�����������ļнǽӽ�90�㣬����������
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

node_tmp1 = NodeCandidate(AFT_stack_sorted, node1_base, node2_base, xCoord_AFT, yCoord_AFT, [x_best1, y_best1], al * ds );
node_tmp2 = NodeCandidate(AFT_stack_sorted, node1_base, node2_base, xCoord_AFT, yCoord_AFT, [x_best2, y_best2], al * ds );

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
        flagClose1 = IsPointClose2Edge([Grid_stack;AFT_stack_sorted], xCoord_tmp, yCoord_tmp, node_select1);
        if flagClose1 == 1
            continue;
        end
    end
    
    if node_select2 == node_best + 2 || node_select2 == node_best + 1
        flagClose2 = IsPointClose2Edge([Grid_stack;AFT_stack_sorted], xCoord_tmp, yCoord_tmp, node_select2);
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
%ѡ��ı߲�����Grid_stack����ڣ�������Ϊ�ǻ�Ծ��
[~, row1] = FrontExist(node1_base,node_select(1), Grid_stack);
[~, row2] = FrontExist(node2_base,node_select(2), Grid_stack);
[~, row3] = FrontExist(node_select(1),node_select(2), Grid_stack);
if row1 ~= -1 || row2 ~= -1 || row3 ~= -1
    node_select = [-1,-1];
    coordX = -1;
    coordY = -1;
    return;
end

%���ѡ����ͬһ���㣬�����������ı���
if node_select(1) == node_select(2)
    node_select = [-1,-1];
    coordX = -1;
    coordY = -1;
    return;
end

%����Ҳ������ʵĵ㣬���޷������ı���
if sum(node_select==-1)>0   
    node_select = [-1,-1];
    coordX = -1;
    coordY = -1;
    return;
end

% �ж��ı����������������̫������������ε�Ԫ
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