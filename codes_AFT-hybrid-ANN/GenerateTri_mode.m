function [node_select,coordX, coordY, flag_best] = GenerateTri_mode(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, coeff, al, node_best, Grid_stack)
global stencilType useANN outGridType nn_fun_tri countMode_tri;
mode = 0;
%%
if useANN == 1 
    [x_best, y_best, Sp, mode, nodeIndex] = ADD_POINT_ANN_tri(nn_fun_tri, AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Grid_stack, stencilType, Sp);
else
    mode = 1;
    [x_best, y_best] = ADD_POINT_tri(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Sp, outGridType);
end
node_best = node_best + 1;      %������ѵ�Pbest�����

node1_base = AFT_stack_sorted(1,1);         %����Ļ�׼��
node2_base = AFT_stack_sorted(1,2);
% ds_base = DISTANCE(node1_base, node2_base, xCoord_AFT, yCoord_AFT);  %��׼����ĳ���
% PLOT_CIRCLE(x_best, y_best, al, Sp, ds_base, node_best);
%%
if mode == 2 || mode == 3
     %�����������У������ٽ��㣬��Ϊ��ѡ�㣬�� ��������׼�����е� �ľ���С��al*Sp�ĵ㣬Ҫ�������Լ������������
    nodeCandidate_AFT = NodeCandidate(AFT_stack_sorted, node1_base, node2_base, xCoord_AFT, yCoord_AFT, [x_best, y_best], al * Sp );
    nodeCandidate_AFT = [nodeCandidate_AFT, node_best];
    %%
    % ��ѯ�ٽ���Ԫ��Ϊ�������ڽ������ཻ
    frontCandidate = FrontCandidate(AFT_stack_sorted, [nodeCandidate_AFT, node1_base, node2_base]);
    flagNotCross1 = IsNotCross(node1_base, node2_base, nodeIndex, frontCandidate, AFT_stack_sorted, xCoord_AFT, yCoord_AFT ,0);
            
     flagLeftCell = IsLeftCell(node1_base, node2_base, nodeIndex, xCoord_AFT, yCoord_AFT);
    if flagLeftCell == 0 || flagNotCross1 == 0
        node_select = -1;
    else
        node_select =  nodeIndex;
        countMode_tri = countMode_tri + 1;
    end
end

if mode == 1 || node_select == -1
    nodeCandidate_AFT = NodeCandidate(AFT_stack_sorted, node1_base, node2_base, xCoord_AFT, yCoord_AFT, [x_best, y_best], al * Sp );
    nodeCandidate_AFT = [nodeCandidate_AFT, node_best];
    % ��ѯ�ٽ���Ԫ��Ϊ�������ڽ������ཻ
    frontCandidate = FrontCandidate(AFT_stack_sorted, [nodeCandidate_AFT, node1_base, node2_base]);
    % frontCandidateNodes = AFT_stack_sorted(frontCandidate,1:2);
    
    %%  �ڷ������в��ҿ����ཻ�ĵ�
    nodeCandidate_Grid = NodeCandidate(Grid_stack, node1_base, node2_base, xCoord_AFT, yCoord_AFT, [x_best, y_best], al * Sp );
    nodeCandidate_Grid = [nodeCandidate_Grid(:)', node1_base, node2_base, node_best];
    
    %�ڷ������в����ٽ���
    faceCandidate = FrontCandidate(Grid_stack, [nodeCandidate_Grid, nodeCandidate_AFT]);
    %     faceCandidateNodes = Grid_stack(faceCandidate,1:2);
    %%
    % �ٽ������������Qp
    Qp = zeros(length(nodeCandidate_AFT),1);
    xCoord_tmp = [xCoord_AFT; x_best];
    yCoord_tmp = [yCoord_AFT; y_best];
    for i = 1 : length(nodeCandidate_AFT)
        node3 = nodeCandidate_AFT(i);
        [quality,~] = QualityCheckTri(node1_base, node2_base, node3, xCoord_tmp, yCoord_tmp, Sp);
        Qp(i) = quality;
        if( node3 == node_best )            %Ϊ�˾���ѡ�����������ϵĵ㣬��Pbest����������һ��
            Qp(i) = coeff * Qp(i);
        end
    end
    
    %%
    %������������һѡ��㣬�ж��Ƿ����ٽ������ཻ�����ཻ����һ����ѡ�㣬�粻�ཻ����ѡ���õ㹹���µ�������
    Qp_sort = sort(Qp, 'descend');
    node_select = -1;
    
    for i = 1 : length(nodeCandidate_AFT)
        node_test_list = nodeCandidate_AFT( Qp==Qp_sort(i) );
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
            
            if node_test == node_best
                flagClose = IsPointClose2Edge([Grid_stack;AFT_stack_sorted], xCoord_tmp, yCoord_tmp, node_test,Sp);
                if flagClose == 1
                    continue;
                end
                
%                 flagClose2 = IsEdgeClose2Point([node1_base,node_test], xCoord_tmp, yCoord_tmp, node2_base);
%                 flagClose3 = IsEdgeClose2Point([node2_base,node_test], xCoord_tmp, yCoord_tmp, node1_base);
%                 if flagClose2 == 1 || flagClose3 == 1
%                     continue;
%                 end
            end
            
            node_select = node_test;
            break;
        end
        
        if node_select ~= -1
            break;
        end
    end  
end    

if(node_select == node_best)    %ֻ����ѡ���������ɵĵ�ʱ������Ҫ���µ����������
    flag_best = 1;
    
    coordX = x_best;
    coordY = y_best;
else
    flag_best = 0;
    
    coordX = [];
    coordY = [];
end
end