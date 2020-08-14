function [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun)
global cellNodeTopo stencilType epsilon useANN outGridType;

node1_base = AFT_stack_sorted(1,1);         %阵面的基准点
node2_base = AFT_stack_sorted(1,2);
ds_base = DISTANCE(node1_base, node2_base, xCoord_AFT, yCoord_AFT);  %基准阵面的长度

%%
if useANN == 1 
    [x_best, y_best, ~] = ADD_POINT_ANN_quad(nn_fun, AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Grid_stack, stencilType, epsilon, Sp );
else
    [x_best, y_best] = ADD_POINT_tri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, outGridType);
end

if length(x_best) == 2
    x_best = 0.5 * ( x_best(1) + x_best(2) );
    y_best = 0.5 * ( y_best(1) + y_best(2) );
end

node_best = node_best + 1;      %新增最佳点Pbest的序号
% PLOT_CIRCLE(x_best, y_best, al, Sp, ds_base, node_best);
%%
nodeCandidate_AFT = NodeCandidate(AFT_stack_sorted, node1_base, node2_base, xCoord_AFT, yCoord_AFT, [x_best, y_best], al*Sp);
nodeCandidate_AFT = [nodeCandidate_AFT, node_best];
% 查询临近阵元，为避免与邻近阵面相交
frontCandidate = FrontCandidate(AFT_stack_sorted, [nodeCandidate_AFT, node1_base, node2_base]);
% frontCandidateNodes = AFT_stack_sorted(frontCandidate,1:2);

%%  在非阵面中查找可能相交的点
nodeCandidate_Grid = NodeCandidate(Grid_stack, node1_base, node2_base, xCoord_AFT, yCoord_AFT, [x_best, y_best], al * Sp );
nodeCandidate_Grid = [nodeCandidate_Grid(:)', node1_base, node2_base, node_best];

%在非阵面中查找临近面
faceCandidate = FrontCandidate(Grid_stack, [nodeCandidate_Grid, nodeCandidate_AFT]);
%     faceCandidateNodes = Grid_stack(faceCandidate,1:2);
%%
% 临近点的质量参数Qp
Qp = zeros(length(nodeCandidate_AFT),1);
xCoord_tmp = [xCoord_AFT; x_best];
yCoord_tmp = [yCoord_AFT; y_best];
for i = 1 : length(nodeCandidate_AFT)
    node3 = nodeCandidate_AFT(i);   
    [quality,~] = QualityCheckTri(node1_base, node2_base, node3, xCoord_tmp, yCoord_tmp, Sp);
    Qp(i) = quality;
    if( node3 == node_best )            %为了尽量选择现有阵面上的点，将Pbest的质量降低一点
        Qp(i) = coeff * Qp(i);
    end
end

%%
%按质量参数逐一选择点，判断是否与临近阵面相交，如相交则下一个候选点，如不相交，则选定该点构成新的三角形
Qp_sort = sort(Qp, 'descend');
node_select = -1;

for i = 1 : length(nodeCandidate_AFT)
    node_test_list = nodeCandidate_AFT( Qp==Qp_sort(i) );
    %%     %除判断相交外，还需判断是否构成左单元，只选择构成左单元的点
    for j = 1:length(node_test_list)
        node_test = node_test_list(j);

        flagNotCross1 = IsNotCross(node1_base, node2_base, node_test, ...
            frontCandidate, AFT_stack_sorted, xCoord_tmp, yCoord_tmp ,0);
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
        
        flagInCell = IsPointInCell(cellNodeTopo, xCoord_tmp, yCoord_tmp, node_test);
        if flagInCell == 1
            continue;
        end
        
        flagDiag   = IsPointDiagnoal(cellNodeTopo, node1_base, node2_base, node_test);
        if flagDiag == 1
            continue;
        end
        
        if node_test == node_best
            flagClose = IsPointClose2Edge([Grid_stack;AFT_stack_sorted], xCoord_tmp, yCoord_tmp, node_test, Sp);
            if flagClose == 1
                continue;
            end                     
        end
        
%         flagClose2 = IsEdgeClose2Point(AFT_stack_sorted,[node1_base,node_test], xCoord_tmp, yCoord_tmp, [node2_base,node_best]);
%         flagClose3 = IsEdgeClose2Point(AFT_stack_sorted,[node2_base,node_test], xCoord_tmp, yCoord_tmp, [node1_base,node_best]);
%         if flagClose2 == 1 || flagClose3 == 1
%             continue;
%         end
        
        cellNodeTopo_Tmp = [node1_base, node2_base, node_test];
        if node_test == node_best
            flagInCell2 = IsAnyPointInCell(cellNodeTopo_Tmp, xCoord_tmp, yCoord_tmp);
        else
            flagInCell2 = IsAnyPointInCell(cellNodeTopo_Tmp, xCoord_AFT, yCoord_AFT);
        end

        if flagInCell2 == 1
            continue;
        end
        
        node_select = node_test;
        break;
    end
    
    if node_select ~= -1
        break;
    end
end

if(node_select == node_best)    %只有在选择了新生成的点时，才需要将新点坐标存下来
%     xCoord_AFT(end+1) = x_best;
%     yCoord_AFT(end+1) = y_best;
    flag_best = 1;
    
    coordX = x_best;
    coordY = y_best;
else
    flag_best = 0;
%     node_best = node_best - 1;   %如果没有选择Pbest，则编号要回退1
    
    coordX = -1;
    coordY = -1;
end
end