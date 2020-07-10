function [node_select,coordX, coordY, flag_best] = GenerateQuads(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, ...
    Sp, coeff, al, node_best, Grid_stack, nn_fun, stencilType)

node_select = [-1,-1];
flag_best   = [1 1];
% [x_best_quad, y_best_quad] = ADD_POINT_quad(AFT_stack_sorted(1,:), xCoord_AFT, yCoord_AFT, Sp);
[x_best_quad, y_best_quad] = ADD_POINT_ANN_quad(nn_fun, AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Grid_stack, stencilType);

%%
% plot(x_best_quad,y_best_quad,'*')
node1_base = AFT_stack_sorted(1,1);         %����Ļ�׼��
node2_base = AFT_stack_sorted(1,2);

v_base = [xCoord_AFT(node2_base)-xCoord_AFT(node1_base), yCoord_AFT(node2_base)-yCoord_AFT(node1_base)];
v_newpoint = [x_best_quad(1)-x_best_quad(2), y_best_quad(1)-y_best_quad(2)];

dd1 = sqrt( v_base(1)^2 + v_base(2)^2 );
dd2 = sqrt( v_newpoint(1)^2 + v_newpoint(2)^2 );
angle = acos( v_base * v_newpoint'/ dd1 / dd2 );
angle = angle / pi * 180;
% dd2 / dd1
% angle
%������ɵ�2�������ǳ�С������Ϊ��1���㣬�����µ�����������ļнǽӽ�90�㣬����������
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
    node_best = node_best + 1;      %������ѵ�Pbest�����
    x_best = x_best_quad(ii);       %������ѵ�Pbest������
    y_best = y_best_quad(ii);
    
    %%
    % ��ѯ�ٽ���
%     node1_base = AFT_stack_sorted(1,1);         %����Ļ�׼��
%     node2_base = AFT_stack_sorted(1,2);
    ds = DISTANCE(node1_base, node2_base, xCoord_AFT, yCoord_AFT);  %��׼����ĳ���
    
%     PLOT_CIRCLE(x_best, y_best, al, Sp, ds, node_best);
    
    %�����������У������ٽ��㣬��Ϊ��ѡ�㣬�� ��������׼�����е� �ľ���С��al*Sp*ds�ĵ㣬Ҫ�������Լ������������
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
    % �ٽ������������Qp
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
       
        Qp(i) = 1.0 / ( ( 2.0 * b/a - Sp ) + abs(v_base * v_new' ) );   %�ı���������������������߳�����õ��ڻ�׼���棬���������׼����ļн���ýӽ�90��
        
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
%     frontCandidateNodes = AFT_stack_sorted(frontCandidate,1:2);

    %%  �ڷ������в��ҿ����ཻ�ĵ�
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
    %�ڷ������в����ٽ���
    faceCandidate = [];
    for i = 2:size(Grid_stack,1)
        node1 = Grid_stack(i,1);
        node2 = Grid_stack(i,2);      %������2������һ���Ǻ�ѡ�㣬��ô�������ڽ���
              
        if( size(find(nodeCandidate_tmp == node1), 2) ~= 0 || size(find(nodeCandidate_tmp == node2), 2) ~= 0 )
            faceCandidate(end+1) = i;
        end
    end
    if size(Grid_stack,1)>0
        faceCandidateNodes = Grid_stack(faceCandidate,1:2);
    end
    %%
    %������������һѡ��㣬�ж��Ƿ����ٽ������ཻ�����ཻ����һ����ѡ�㣬�粻�ཻ����ѡ���õ㹹���µ�������
    Qp_sort = sort(Qp, 'descend');
    
    for i = 1 : length(nodeCandidate)
        node_test_list = nodeCandidate( Qp==Qp_sort(i) );
        for j = 1:length(node_test_list)
            node_test = node_test_list(j);
            flagNotCross1 = IsNotCross(node1_base, node2_base, node_test, ...        %���ж��ཻ�⣬�����ж��Ƿ񹹳���Ԫ��ֻѡ�񹹳���Ԫ�ĵ�
                frontCandidate, AFT_stack_sorted, xCoord_tmp, yCoord_tmp,ii);
            
             flagNotCross2 = IsNotCross(node1_base, node2_base, node_test, ...        %���ж��ཻ�⣬�����ж��Ƿ񹹳���Ԫ��ֻѡ�񹹳���Ԫ�ĵ�
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
% �ж��ı����������������̫������������ε�Ԫ
if sum(node_select==-1)>0   %����Ҳ������ʵĵ㣬���޷������ı���
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