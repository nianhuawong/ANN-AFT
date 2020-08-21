function [node_select,coordX, coordY, flag_best] = GenerateQuads(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack, nn_fun )
global cellNodeTopo stencilType epsilon useANN;
node_select = [-1,-1];
flag_best   = [1 1];

node1_base = AFT_stack_sorted(1,1);         %����Ļ�׼��
node2_base = AFT_stack_sorted(1,2);
ds_base = DISTANCE(node1_base, node2_base, xCoord_AFT, yCoord_AFT);  %��׼����ĳ���

%%
if useANN == 1 
    [x_best_quad, y_best_quad, Sp] = ADD_POINT_ANN_quad(nn_fun, AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Grid_stack, stencilType, Sp);
else
    [x_best_quad, y_best_quad,Sp] = ADD_POINT_quad(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp);
end
                                                
% PLOT_CIRCLE(x_best_quad, y_best_quad, al, Sp, ds_base, node_best);
%%
%������ɵ�2�������ǳ�С������Ϊ��1���㣬�����µ�����������ļнǽӽ�90�㣬����������
if  length(x_best_quad) == 1 && length(y_best_quad) == 1
    node_select = [-1,-1];
    coordX = -1;
    coordY = -1;
    return;
end    

for ii = 1:2
    node_best = node_best + 1;      %������ѵ�Pbest�����
    x_best = x_best_quad(ii);       %������ѵ�Pbest������
    y_best = y_best_quad(ii);
    
    %%
     %�����������У������ٽ��㣬��Ϊ��ѡ�㣬�� ��������׼�����е� �ľ���С��al*Sp�ĵ㣬Ҫ�������Լ������������
    nodeCandidate_AFT = NodeCandidate(AFT_stack_sorted, node1_base, node2_base, xCoord_AFT, yCoord_AFT, [x_best, y_best], al*Sp);
    nodeCandidate_AFT = [nodeCandidate_AFT, node_best];
    %%
    % ��ѯ�ٽ���Ԫ��Ϊ�������ڽ������ཻ
    frontCandidate = FrontCandidate(AFT_stack_sorted, [nodeCandidate_AFT, node1_base, node2_base]);

%%  �ڷ������в��ҿ����ཻ�ĵ�
    nodeCandidate_Grid = NodeCandidate(Grid_stack, node1_base, node2_base, xCoord_AFT, yCoord_AFT, [x_best, y_best], al * Sp );
    nodeCandidate_Grid = [nodeCandidate_Grid(:)', node1_base, node2_base, node_best];
    
    %�ڷ������в����ٽ���
    faceCandidate = FrontCandidate(Grid_stack, nodeCandidate_Grid);
%     if size(Grid_stack,1)>0
%         faceCandidateNodes = Grid_stack(faceCandidate,1:2);
%     end

    %%
    % �ٽ������������Qp
    Qp = zeros(length(nodeCandidate_AFT),1);
    
    xCoord_tmp = [xCoord_AFT; x_best];
    yCoord_tmp = [yCoord_AFT; y_best];
       
    v_base = [xCoord_tmp(node2_base)-xCoord_tmp(node1_base), yCoord_tmp(node2_base)-yCoord_tmp(node1_base)];
    for i = 1 : length(nodeCandidate_AFT)
        node3 = nodeCandidate_AFT(i);
%====================================================        
%         if ii == 1
%             d_new = DISTANCE( node1_base, node3, xCoord_tmp, yCoord_tmp);
%             v_new = [xCoord_tmp(node3)-xCoord_tmp(node1_base), yCoord_tmp(node3)-yCoord_tmp(node1_base)];
%         elseif ii == 2
%             d_new = DISTANCE( node2_base, node3, xCoord_tmp, yCoord_tmp);
%             v_new = [xCoord_tmp(node3)-xCoord_tmp(node2_base), yCoord_tmp(node3)-yCoord_tmp(node2_base)];
%         end
%        angle = acos( v_new * v_base' / ( d_new + 1e-40 ) / ( ds_base  + 1e-40 ) ) * 180 / pi;
%        term1 = d_new * sind(angle) / Sp;
%        term1 = 1.0 + abs( 1.0 - term1 );
%        term2 = 1.0 + abs( 1.0 - angle / 90.0 );
%        Qp(i) = ( term1 + term2 ) / 2.0;
%        if Qp(i) > 1.0
%            Qp(i) = 2.0 - Qp(i);
%        end
%====================================================
        if ii == 1
            A = [xCoord_tmp(node1_base),yCoord_tmp(node1_base)];
            B = [xCoord_tmp(node2_base),yCoord_tmp(node2_base)];
            D = [xCoord_tmp(node3),yCoord_tmp(node3)];
            C = B + D - A;
            node4 = length(xCoord_tmp) + 1;
            [quality, ~] = QualityCheckQuad(node1_base, node2_base, node4, node3, [xCoord_tmp; C(1)], [yCoord_tmp; C(2)], Sp);
        elseif ii == 2
            [quality, ~] = QualityCheckQuad(node1_base, node2_base, node3, node_select(1), xCoord_tmp, yCoord_tmp, Sp);
        end
        Qp(i) = quality;           
%====================================================   
        if( node3 == node_best )            %Ϊ�˾���ѡ�����������ϵĵ㣬��Pbest����������һ��
            Qp(i) = coeff * Qp(i);
        end
    end
    
    %%
    %������������һѡ��㣬�ж��Ƿ����ٽ������ཻ�����ཻ����һ����ѡ�㣬�粻�ཻ����ѡ���õ㹹���µ�������
    Qp_sort = sort(Qp, 'descend');
    
    for i = 1 : length(nodeCandidate_AFT)
        node_test_list = nodeCandidate_AFT( Qp==Qp_sort(i) );
        for j = 1:length(node_test_list)
            node_test = node_test_list(j);
            flagNotCross1 = IsNotCross(node1_base, node2_base, node_test, ...        %���ж��ཻ�⣬�����ж��Ƿ񹹳���Ԫ��ֻѡ�񹹳���Ԫ�ĵ�
                frontCandidate, AFT_stack_sorted, xCoord_tmp, yCoord_tmp,ii);
            if flagNotCross1 == 0
                continue;
            end
            
            flagNotCross2 = IsNotCross(node1_base, node2_base, node_test, ...        %���ж��ཻ�⣬�����ж��Ƿ񹹳���Ԫ��ֻѡ�񹹳���Ԫ�ĵ�
                faceCandidate, Grid_stack, xCoord_tmp, yCoord_tmp,ii);
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
            
%             if ii == 2 && node_select(1) ~= -1           
%                 new_cell = [node1_base, node2_base, node_test, node_select(1)];
% %                 cellNodeTopo_Tmp = [cellNodeTopo;new_cell];
%                 cellNodeTopo_Tmp = new_cell;
%                 if node_test == node_best
%                     flagInCell2 = IsAnyPointInCell(cellNodeTopo_Tmp, xCoord_tmp, yCoord_tmp);  
%                 else
%                     flagInCell2 = IsAnyPointInCell(cellNodeTopo_Tmp, xCoord_AFT, yCoord_AFT);  
%                 end                                  
%                               
%                 if flagInCell2 == 1
%                     continue;
%                 end
%             end
            
            if ii == 1
                flagDiag   = IsPointDiagnoal(cellNodeTopo, node1_base, node2_base, node_test);
            elseif ii == 2
                flagDiag   = IsPointDiagnoal(cellNodeTopo, node1_base, node2_base, [node_select(1),node_test]);
            end
            if flagDiag == 1
                continue;
            end

            if node_test == node_best
                flagClose = IsPointClose2Edge([Grid_stack;AFT_stack_sorted], xCoord_tmp, yCoord_tmp, node_test,Sp);
                if flagClose == 1
                    continue;
                end
                
                flagClose2 = 0; flagClose3 = 0; flagClose4 = 0;
                if ii == 1
                    flagClose2 = IsEdgeClose2Point(AFT_stack_sorted, [node1_base,node_test], xCoord_tmp, yCoord_tmp, node2_base);
                elseif ii == 2 && node_select(1) ~= -1
                    flagClose3 = IsEdgeClose2Point(AFT_stack_sorted, [node2_base,node_test], xCoord_tmp, yCoord_tmp, node1_base);
                    flagClose4 = IsEdgeClose2Point(AFT_stack_sorted, [node_select(1),node_test], xCoord_tmp, yCoord_tmp, -1);
                end
                
                if flagClose2 == 1 || flagClose3 == 1 || flagClose4 == 1
                    continue;
                end
            end

            node_select(ii) = node_test;
            
            flagNotCross3 = 1;                                          %���ж����������׼���������Ƿ������������ཻ�⣬����Ҫ�ж�������2����S1 S2�������Ƿ������������ཻ
            flagNotCross4 = 1;
            if( node_select(2)~= -1 )
                flagNotCross3 = IsNotCross(node_select(1), node2_base, node_select(2), ...
                    frontCandidate, AFT_stack_sorted, xCoord_tmp, yCoord_tmp, 1);
                
                flagNotCross4 = IsNotCross(node_select(1), node2_base, node_select(2), ...
                    faceCandidate, Grid_stack, xCoord_tmp, yCoord_tmp, 1);
            end
            
            if flagNotCross3 == 1 &&  flagNotCross4 == 1             %������ཻ�������
                break;
            else
                node_select(ii) = -1;           %����ཻ����Ҫ�ٴ�ѡ��
            end
        end
        
        if node_select(ii) ~= -1
            break;
        end
    end
    
    if node_select(ii) ~= -1
        if(node_select(ii) == node_best)    %ֻ����ѡ���������ɵĵ�ʱ������Ҫ���µ����������
            xCoord_AFT(end+1) = x_best;
            yCoord_AFT(end+1) = y_best;
        elseif( node_select(ii)~= node_best)
            flag_best(ii) = 0;
            node_best = node_best - 1;%���û��ѡ��Pbest������Ҫ����1
        end
    else
        flag_best(ii) = 0;
        node_best = node_best - 1;%���û��ѡ��Pbest������Ҫ����1
    end
end


%%
%ѡ��ı߲�����Grid_stack����ڣ�������Ϊ�ǻ�Ծ��
[row1, ~ ] = FrontExist(node1_base,node_select(1), Grid_stack);
[row2, ~ ] = FrontExist(node2_base,node_select(2), Grid_stack);
[row3, ~ ] = FrontExist(node_select(1),node_select(2), Grid_stack);
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