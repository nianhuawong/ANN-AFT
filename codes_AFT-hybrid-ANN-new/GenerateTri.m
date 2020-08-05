function [node_select,coordX, coordY, flag_best] = GenerateTri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, ...
    Sp, coeff, al, node_best, Grid_stack, nn_fun)
global cellNodeTopo stencilType epsilon;
node_select = -1;
flag_best   = 1;

node1_base = AFT_stack_sorted(1,1);         %����Ļ�׼��
node2_base = AFT_stack_sorted(1,2);
ds = DISTANCE(node1_base, node2_base, xCoord_AFT, yCoord_AFT);  %��׼����ĳ���

%%
% [x_best, y_best] = ADD_POINT_tri(AFT_stack_sorted(1,:), xCoord_AFT, yCoord_AFT, Sp);
% [x_best_ann, y_best_ann, ~] = ADD_POINT_quad(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp);
[x_best_ann, y_best_ann, ~] = ADD_POINT_ANN_quad(nn_fun, AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Grid_stack, stencilType, epsilon );

if length(x_best_ann) == 2
    x_best = 0.5 * ( x_best_ann(1) + x_best_ann(2) );
    y_best = 0.5 * ( y_best_ann(1) + y_best_ann(2) );
elseif length(x_best_ann) == 1
  x_best =  x_best_ann;
  y_best =  y_best_ann;
end

node_best = node_best + 1;      %������ѵ�Pbest�����
% PLOT_CIRCLE(x_best, y_best, al, Sp, ds, node_best);

nodeCandidate = node_best;
for i = 2:size(AFT_stack_sorted,1)
    node1 = AFT_stack_sorted(i,1);
    node2 = AFT_stack_sorted(i,2);
    x_p1 = xCoord_AFT(node1);
    y_p1 = yCoord_AFT(node1);
    
    x_p2 = xCoord_AFT(node2);
    y_p2 = yCoord_AFT(node2);
    
%     if( (x_p1-x_best)^2 + (y_p1-y_best)^2 < al*al*Sp*Sp*ds*ds &&  node1 ~= node1_base && node1 ~= node2_base)
    if( (x_p1-x_best)^2 + (y_p1-y_best)^2 < al*al*ds*ds &&  node1 ~= node1_base && node1 ~= node2_base)
        nodeCandidate(end+1) = node1;
    end
%     if( (x_p2-x_best)^2 + (y_p2-y_best)^2 < al*al*Sp*Sp*ds*ds &&  node2 ~= node1_base && node2 ~= node2_base)
    if( (x_p2-x_best)^2 + (y_p2-y_best)^2 < al*al*ds*ds &&  node2 ~= node1_base && node2 ~= node2_base)
        nodeCandidate(end+1) = node2;
    end
end
nodeCandidate = unique(nodeCandidate);
%%
% �ٽ������������Qp
Qp = zeros(length(nodeCandidate),1);
xCoord_tmp = [xCoord_AFT; x_best];
yCoord_tmp = [yCoord_AFT; y_best];
for i = 1 : length(nodeCandidate)
    node3 = nodeCandidate(i); 
    
    [quality,~] = QualityCheckTri(node1_base, node2_base, node3, xCoord_tmp, yCoord_tmp, Sp);
    Qp(i) = quality;
    if( node3 == node_best )            %Ϊ�˾���ѡ�����������ϵĵ㣬��Pbest����������һ��
        Qp(i) = coeff * Qp(i);
    end
end

%%
% ��ѯ�ٽ���Ԫ��Ϊ�������ڽ������ཻ
frontCandidate = [];
nodeCandidate_tmp = [nodeCandidate, node1_base, node2_base];
for i = 2:size(AFT_stack_sorted,1)
    node1 = AFT_stack_sorted(i,1);
    node2 = AFT_stack_sorted(i,2);      %��������2���㶼�Ǻ�ѡ�㣬��ô�������ڽ�����
    
    %         if( size(find(nodeCandidate_tmp == node1), 2) ~= 0 && size(find(nodeCandidate_tmp == node2), 2) ~= 0 )
    if( size(find(nodeCandidate_tmp == node1), 2) ~= 0 || size(find(nodeCandidate_tmp == node2), 2) ~= 0 )
        frontCandidate(end+1) = i;
    end
end

frontCandidateNodes = AFT_stack_sorted(frontCandidate,1:2);
%%  �ڷ������в��ҿ����ཻ�ĵ�
nodeCandidate2 = node_best;
for i = 2:size(Grid_stack,1)
    node1 = Grid_stack(i,1);
    node2 = Grid_stack(i,2);
    x_p1 = xCoord_AFT(node1);
    y_p1 = yCoord_AFT(node1);
    
    x_p2 = xCoord_AFT(node2);
    y_p2 = yCoord_AFT(node2);
    
%     if( (x_p1-x_best)^2 + (y_p1-y_best)^2 < al*al*Sp*Sp*ds*ds &&  node1 ~= node1_base && node1 ~= node2_base)
    if( (x_p1-x_best)^2 + (y_p1-y_best)^2 < al*al*ds*ds &&  node1 ~= node1_base && node1 ~= node2_base)
        nodeCandidate2(end+1) = node1;
    end
%     if( (x_p2-x_best)^2 + (y_p2-y_best)^2 < al*al*Sp*Sp*ds*ds &&  node2 ~= node1_base && node2 ~= node2_base)
    if( (x_p2-x_best)^2 + (y_p2-y_best)^2 < al*al*ds*ds &&  node2 ~= node1_base && node2 ~= node2_base)
        nodeCandidate2(end+1) = node2;
    end
end
nodeCandidate2 = unique(nodeCandidate2);

nodeCandidate_tmp = [nodeCandidate, nodeCandidate2, node1_base, node2_base];
%�ڷ������в����ٽ���
faceCandidate = [];
for i = 2:size(Grid_stack,1)
    node1 = Grid_stack(i,1);
    node2 = Grid_stack(i,2);      %������2������һ���Ǻ�ѡ�㣬��ô�������ڽ���
    
    if( size(find(nodeCandidate_tmp == node1), 2) ~= 0 || size(find(nodeCandidate_tmp == node2), 2) ~= 0 )
        faceCandidate(end+1) = i;
    end
end

%     faceCandidateNodes = Grid_stack(faceCandidate,1:2);
%%
%������������һѡ��㣬�ж��Ƿ����ٽ������ཻ�����ཻ����һ����ѡ�㣬�粻�ཻ����ѡ���õ㹹���µ�������
Qp_sort = sort(Qp, 'descend');
node_select = -1;

for i = 1 : length(nodeCandidate)
    node_test_list = nodeCandidate( Qp==Qp_sort(i) );
    %%     %���ж��ཻ�⣬�����ж��Ƿ񹹳���Ԫ��ֻѡ�񹹳���Ԫ�ĵ�
    for j = 1:length(node_test_list)
        node_test = node_test_list(j);

        flagNotCross1 = IsNotCross(node1_base, node2_base, node_test, ...
            frontCandidate, AFT_stack_sorted, xCoord_tmp, yCoord_tmp ,0);
        if flagNotCross1 == 0
            continue;
        end
        
        flagNotCross2 = IsNotCross(node1_base, node2_base, node_test, ...        %���ж��ཻ�⣬�����ж��Ƿ񹹳���Ԫ��ֻѡ�񹹳���Ԫ�ĵ�
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
            flagClose = IsPointClose2Edge([Grid_stack;AFT_stack_sorted], xCoord_tmp, yCoord_tmp, node_test);
            if flagClose == 1
                continue;
            end
            
%             flagClose2 = IsEdgeClose2Point([node1_base,node_test], xCoord_tmp, yCoord_tmp, node2_base);
%             flagClose3 = IsEdgeClose2Point([node2_base,node_test], xCoord_tmp, yCoord_tmp, node1_base);
%             if flagClose2 == 1 || flagClose3 == 1
%                 continue;
%             end            
        end
        
%         cellNodeTopo_Tmp = [node1_base, node2_base, node_test];
%         if node_test == node_best
%             flagInCell2 = IsAnyPointInCell(cellNodeTopo_Tmp, xCoord_tmp, yCoord_tmp);
%         else
%             flagInCell2 = IsAnyPointInCell(cellNodeTopo_Tmp, xCoord_AFT, yCoord_AFT);
%         end
% 
%         if flagInCell2 == 1
%             continue;
%         end
        
        node_select = node_test;
        break;
    end
    
    if node_select ~= -1
        break;
    end
end

if(node_select == node_best)    %ֻ����ѡ���������ɵĵ�ʱ������Ҫ���µ����������
    xCoord_AFT(end+1) = x_best;
    yCoord_AFT(end+1) = y_best;
    flag_best = 1;
    
    coordX = x_best;
    coordY = y_best;
else
    flag_best = 0;
    node_best = node_best - 1;   %���û��ѡ��Pbest������Ҫ����1
    
    coordX = -1;
    coordY = -1;
end
end