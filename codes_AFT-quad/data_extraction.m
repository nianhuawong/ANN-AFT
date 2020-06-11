clear;clc;
tic
format long
%%
gridType    = 0;        % 0-��һ��Ԫ����1-��ϵ�Ԫ����
Sp          = 1.0;      % ���񲽳�  % Sp = sqrt(3.0)/2.0;  %0.866
al          = 3.0;      % �ڼ�����Χ������
coeff       = 0.8;      % ����ѡ�����е�Ĳ�����Pbest����������ϵ��
dt          = 0.01;   % ��ͣʱ��
%%
[AFT_stack,Coord,~]  = read_grid('./grid/tri2.cas', gridType);
%%
nodeList = AFT_stack(:,1:2);
node_num = max( max(nodeList)-min(nodeList)+1 );%�߽��ĸ��������ߣ���ʼ�������
xCoord_AFT = Coord(1:node_num,1);                %��ʼ���������
yCoord_AFT = Coord(1:node_num,2);

% nodeList = unique([nodeList(:,1);nodeList(:,2)]);
% node_num = length(nodeList);
% xCoord_AFT = Coord(nodeList,1);
% yCoord_AFT = Coord(nodeList,2);

PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);

%%
% ѡ����С���棬����Pbest
nCells_AFT = 0;
iFace = 1;
Grid_stack = [];
node_best = node_num;     %��ʼʱ��ѵ�Pbest�����

%%  �Ƚ��߽������ƽ�
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
        node_best = node_best + 1;      %������ѵ�Pbest�����
        x_best = x_best_quad(ii);       %������ѵ�Pbest������
        y_best = y_best_quad(ii);
        
        %%
        % ��ѯ�ٽ���
        % ���Ի���Բ�������ٽ�������Щ
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
        node1_base = AFT_stack_sorted(1,1);         %����Ļ�׼��
        node2_base = AFT_stack_sorted(1,2);
        ds = DISTANCE(node1_base, node2_base, xCoord_AFT, yCoord_AFT);  %��׼����ĳ���
        
        %�����������У������ٽ��㣬��Ϊ��ѡ�㣬�� ��������׼�����е� �ľ���С��al*Sp*ds�ĵ㣬Ҫ�������Լ������������
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
        
        frontCandidateNodes = AFT_stack_sorted(frontCandidate,1:2);
        %%
        %������������һѡ��㣬�ж��Ƿ����ٽ������ཻ�����ཻ����һ����ѡ�㣬�粻�ཻ����ѡ���õ㹹���µ�������
        Qp_sort = sort(Qp, 'descend');
        
        for i = 1 : length(nodeCandidate)
            node_test_list = nodeCandidate( find(Qp==Qp_sort(i)) );
            for j = 1:length(node_test_list)
                node_test = node_test_list(j);
                flagNotCross = IsNotCross(node1_base, node2_base, node_test, ...        %���ж��ཻ�⣬�����ж��Ƿ񹹳���Ԫ��ֻѡ�񹹳���Ԫ�ĵ�
                    frontCandidate, AFT_stack_sorted, xCoord_tmp, yCoord_tmp,ii);
                flagLeftCell = IsLeftCell(node1_base, node2_base, node_test, xCoord_tmp, yCoord_tmp);
                
                if flagNotCross == 1 && flagLeftCell == 1
                    node_select(ii) = node_test;
                    
                    flagNotCross2 = 1;                                          %���ж����������׼���������Ƿ������������ཻ�⣬����Ҫ�ж�������2����S1 S2�������Ƿ������������ཻ
                    if( node_select(2)~= -1 )
                        flagNotCross2 = IsNotCross(node_select(1), node2_base, node_select(2), ...
                            frontCandidate, AFT_stack_sorted, xCoord_tmp, yCoord_tmp, 1);
                    end
                    if flagNotCross2 == 1               %������ཻ�������
                        break;
                    else
                        node_select(ii) = -1;           %����ཻ����Ҫ�ٴ�ѡ��
                    end
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
                break;
            end
        end
    end
    %%
    if nCells_AFT == 22
        kkk = 1;
    end
    %%
    %���漰��Ԫ��Ÿ���
    size0 = size(AFT_stack_sorted,1);
    nCells_AFT = nCells_AFT + 1;
    AFT_stack_sorted = Update_AFT_INFO(AFT_stack_sorted, node1_base, ...
        node2_base, node_select,nCells_AFT, xCoord_AFT, yCoord_AFT);
    
    %%
    %�����������֮�󣬳��˻�׼�����γɵĵ�Ԫ�����п��ܻ��Զ����ɶ����Ԫ����Ҫ�жϡ�
    %�����������в����Զ����ɵĵ�Ԫ���жϷ���Ϊ�ڵ���ڵ� ���ڵ����ڣ��򹹳ɷ�յ�Ԫ
    if(flag_best(1)== 0 || flag_best(2)== 0 )
        neighbor1 =[];
        if( flag_best(1)== 0) %û��ѡ��pbest������ѡ�������е㣬�п��ܵ�������������Ԫ              
            neighbor1 = NeighborNodes(node_select(1), AFT_stack_sorted);%�ҳ����е�����ڵ�
            neighbor1 = [node1_base, neighbor1];
            neighbor1 = unique(neighbor1);
        end
        
        neighbor2 =[];
        if( flag_best(2) == 0 ) %û��ѡ��pbest������ѡ�������е㣬�п��ܵ�������������Ԫ
            neighbor2 = NeighborNodes(node_select(2), AFT_stack_sorted);%�ҳ����е�����ڵ�
            neighbor2 = [node2_base, neighbor2];
            neighbor2 = unique(neighbor2);           
        end
%%
        % %�ڵ���ڵ� �� �ڵ� �������л������ڵģ����γ��µ�Ԫ
        new_cell = [];
        for i = 1:length(neighbor1)
            neighborNode = neighbor1(i); %�ڵ�
            for j = 1: size(AFT_stack_sorted,1)
                if( AFT_stack_sorted(j,1) == neighborNode && AFT_stack_sorted(j,2)~= node_select(1)) %�ڵ���������j
                    neighborNodeOfNeighbor = AFT_stack_sorted(j,2); %�ڵ���ڵ�
                    
                    if( find(neighbor1==neighborNodeOfNeighbor) )  %�ڵ���ڵ�������ڣ���Ϊ������
                        new_cell(end+1,:) = [node_select(1), neighborNode, neighborNodeOfNeighbor, -11];
                    end
                    
                    for k = 1:size(AFT_stack_sorted,1)
                        if( AFT_stack_sorted(k,1) == neighborNodeOfNeighbor && AFT_stack_sorted(k,2)~= neighborNode )   %�ڵ���ڵ���������k
                            if(find(neighbor1==AFT_stack_sorted(k,2)))   %�ڵ���ڵ���ڵ�AFT_stack_sorted(k,2)
                                new_cell(end+1,:) = [node_select(1), neighborNode, neighborNodeOfNeighbor, AFT_stack_sorted(k,2)];
                            end
                        elseif ( AFT_stack_sorted(k,2) == neighborNodeOfNeighbor && AFT_stack_sorted(k,1)~= neighborNode )   %�ڵ���ڵ���������k
                            if(find(neighbor1==AFT_stack_sorted(k,1)))   %�ڵ���ڵ���ڵ�AFT_stack_sorted(k,1)
                                new_cell(end+1,:) = [node_select(1), neighborNode, neighborNodeOfNeighbor, AFT_stack_sorted(k,1)];
                            end
                        end
                    end
                elseif( AFT_stack_sorted(j,2) == neighborNode && AFT_stack_sorted(j,1)~= node_select(1)) %�ڵ���������j
                    neighborNodeOfNeighbor = AFT_stack_sorted(j,1);%�ڵ���ڵ�
                    
                    if( find(neighbor1==neighborNodeOfNeighbor) )  %�ڵ���ڵ�������ڣ���Ϊ������
                        new_cell(end+1,:) = [node_select(1), neighborNode, neighborNodeOfNeighbor, -11];
                    end
                    
                    for k = 1:size(AFT_stack_sorted,1)
                        if( AFT_stack_sorted(k,1) == neighborNodeOfNeighbor && AFT_stack_sorted(k,2)~= neighborNode )%�ڵ���ڵ���������
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
            neighborNode = neighbor2(i); %�ڵ�
            for j = 1: size(AFT_stack_sorted,1)
                if( AFT_stack_sorted(j,1) == neighborNode && AFT_stack_sorted(j,2)~= node_select(2)) %�ڵ���������
                    neighborNodeOfNeighbor = AFT_stack_sorted(j,2); %�ڵ���ڵ�
                    %
                    if( find(neighbor2==neighborNodeOfNeighbor) )  %�ڵ���ڵ�������ڣ���Ϊ������
                        new_cell(end+1,:) = [node_select(2), neighborNode, neighborNodeOfNeighbor, -22];
                    end
                    
                    for k = 1:size(AFT_stack_sorted,1)
                        if( AFT_stack_sorted(k,1) == neighborNodeOfNeighbor && AFT_stack_sorted(k,2)~= neighborNode)   %�ڵ���ڵ���������
                            if(find(neighbor2==AFT_stack_sorted(k,2)))   %�ڵ���ڵ���ڵ�AFT_stack_sorted(k,2)
                                new_cell(end+1,:) = [node_select(2), neighborNode, neighborNodeOfNeighbor, AFT_stack_sorted(k,2)];
                            end
                        elseif ( AFT_stack_sorted(k,2) == neighborNodeOfNeighbor && AFT_stack_sorted(k,1)~= neighborNode )   %�ڵ���ڵ���������
                            if(find(neighbor2==AFT_stack_sorted(k,1)))   %�ڵ���ڵ���ڵ�AFT_stack_sorted(k,2)
                                new_cell(end+1,:) = [node_select(2), neighborNode, neighborNodeOfNeighbor, AFT_stack_sorted(k,1)];
                            end
                        end
                    end
                elseif( AFT_stack_sorted(j,2) == neighborNode && AFT_stack_sorted(j,1)~= node_select(2)) %�ڵ���������
                    neighborNodeOfNeighbor = AFT_stack_sorted(j,1);%�ڵ���ڵ�
                    %
                    if( find(neighbor2==neighborNodeOfNeighbor) )  %�ڵ���ڵ�������ڣ���Ϊ������
                        new_cell(end+1,:) = [node_select(2), neighborNode, neighborNodeOfNeighbor, -22];
                    end
                    
                    for k = 1:size(AFT_stack_sorted,1)
                        if( AFT_stack_sorted(k,1) == neighborNodeOfNeighbor && AFT_stack_sorted(k,2)~= neighborNode )%�ڵ���ڵ���������
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
        % %         ȥ���ظ��ĵ�Ԫ
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
        
        % %         ��Ҫȥ���Ѿ��еĵ�Ԫ
        for i = 1 : size(new_cell,1)
            iCell = new_cell(i,:);
            if(iCell(4)==-11)    %������
                if(size(find(iCell==node1_base),2) && size(find(iCell==node2_base),2) ...
                        && size(find(iCell==node_select(1)),2))
                    new_cell(i,:)=-1;
                end
            elseif(iCell(4)==-22) %������
                if(size(find(iCell==node1_base),2) && size(find(iCell==node2_base),2) ...
                        && size(find(iCell==node_select(2)),2))
                    new_cell(i,:)=-1;
                end
            else               %�ı���
                if(size(find(iCell==node1_base),2) && size(find(iCell==node2_base),2) ...
                        && size(find(iCell==node_select(1)),2)&& size(find(iCell==node_select(2)),2))
                    new_cell(i,:)=-1;
                end
            end
        end
        
        II = find(new_cell(:,1) == -1);
        new_cell(II,:)=[];
        % %         ���µ�Ԫ�������ݽṹ
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
        disp('==========�ƽ�������...==========');
        disp(['nCells = ', num2str(nCells_AFT)]);
        disp(['����ʵʱ���ȣ�', num2str(size(AFT_stack_sorted,1))]);
        disp(['������������',num2str(size1-size0)]);
    end
    %%
    %�ҳ��ǻ�Ծ���棬��ɾ��
    for i = 1: size(AFT_stack_sorted,1)
        if((AFT_stack_sorted(i,3) ~= -1) && (AFT_stack_sorted(i,4) ~= -1))  %��Ԫ���ҵ�Ԫ��ž���Ϊ-1
            Grid_stack(iFace,:) = AFT_stack_sorted(i,:);
            iFace = iFace + 1;
            AFT_stack_sorted(i,:)=-1;
        end
    end
    
    AFT_stack_sorted( find(AFT_stack_sorted(:,1) == -1), : ) = [];
    
    AFT_stack_sorted = sortrows(AFT_stack_sorted, 5);
end

disp(['�����ƽ���ɣ���Ԫ����', num2str(nCells_AFT)]);
disp(['�����ƽ���ɣ��ڵ�����', num2str(length(xCoord_AFT))]);
disp(['�����ƽ���ɣ��������', num2str(size(Grid_stack,1))]);
toc








