clear;clc;
tic
format long
%%
gridType    = 0;        % 0-��һ��Ԫ����1-��ϵ�Ԫ����
Sp          = 1.0;      % ���񲽳�  % Sp = sqrt(3.0)/2.0;  %0.866         
al          = 2.0;      % �ڼ�����Χ������
coeff       = 0.99;      % ����ѡ�����е�Ĳ�����Pbest����������ϵ��
dt          = 0.01;   % ��ͣʱ��
outGridType = 1;        % 0-����ͬ������1-������������
%%
[AFT_stack,Coord,~]  = read_grid('./grid/tri2.cas', gridType);
%%
nodeList = AFT_stack(:,1:2);
node_num = max( max(nodeList)-min(nodeList)+1 );%�߽��ĸ��������ߣ���ʼ�������
xCoord_AFT = Coord(1:node_num,1);                %��ʼ���������
yCoord_AFT = Coord(1:node_num,2);
PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);

%%
% ѡ����С���棬����Pbest
nCells_AFT = 0;
node_best = node_num;     %��ʼʱ��ѵ�Pbest�����
% AFT_stack_sorted =[];
AFT_stack_sorted = sortrows(AFT_stack, 5);
% while size(AFT_stack,1)>0
while size(AFT_stack_sorted,1)>0
%     AFT_stack_sorted = sortrows(AFT_stack, 5);
    [x_best, y_best] = ADD_POINT(AFT_stack_sorted(1,:), xCoord_AFT, yCoord_AFT, Sp, outGridType);
    node_best = node_best + 1;      %������ѵ�Pbest�����

    %%
    % ��ѯ�ٽ���
    % ���Ի���Բ�������ٽ�������Щ
%     figure;
%     PLOT(AFT_stack, xCoord_AFT, yCoord_AFT);
%     hold on
%     plot(x_best,y_best,'*')
%     hold on
%     txt = text(x_best+0.1,y_best,num2str(node_best), 'Color', 'red', 'FontSize', 14);
%     syms xxx yyy
% % %     ezplot((xxx-x_best)^2+(yyy-y_best)^2==al*al*Sp*Sp*ds*ds);
%     fimplicit(@(xxx,yyy) (xxx-x_best)^2+(yyy-y_best)^2-al*al*Sp*Sp*ds*ds);
%     hold on
    pause(dt);
    
    %����Ļ�׼��
    node1_base = AFT_stack_sorted(1,1);
    node2_base = AFT_stack_sorted(1,2);
    
    %�����������У������ٽ��㣬��������ľ���С��al*Sp*ds�ĵ㣬Ҫ�������Լ������������
    ds = AFT_stack_sorted(1,5);  %��׼����ĳ���
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

%         if( (x_p1-x_best)^2 + (y_p1-y_best)^2 < al*al*Sp*Sp*ds*ds &&  node1 ~= node1_base && node1 ~= node2_base)
%             nodeCandidate(end+1) = node1;
%         elseif( (x_p2-x_best)^2 + (y_p2-y_best)^2 < al*al*Sp*Sp*ds*ds &&  node2 ~= node1_base && node2 ~= node2_base)
%             nodeCandidate(end+1) = node2;
%         end
        if( (x_p1-x_mid)^2 + (y_p1-y_mid)^2 < al*al*Sp*Sp*ds*ds &&  node1 ~= node1_base && node1 ~= node2_base)
            nodeCandidate(end+1) = node1;
        elseif( (x_p2-x_mid)^2 + (y_p2-y_mid)^2 < al*al*Sp*Sp*ds*ds &&  node2 ~= node1_base && node2 ~= node2_base)
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
        a = DISTANCE( node1_base, node2_base, xCoord_tmp, yCoord_tmp);  %��׼�������ѡ���γ�������
        b = DISTANCE( node1_base, node3, xCoord_tmp, yCoord_tmp);       %��������QpΪ����Բ�� ���Բ�뾶֮��
        c = DISTANCE( node3, node2_base, xCoord_tmp, yCoord_tmp);

        theta = acos( ( a^2 + b^2 - c^2 ) / ( 2.0 * a * b + 1e-40 ) );  
        area = 0.5 * a * b * sin(theta);              %���������
        r = 2.0 * area / ( ( a + b + c ) + 1e-40 );   %����Բ�뾶
        R = a * b * c / 4.0 / ( area + 1e-40 );       %���Բ�뾶

        Qp(i) =   3.0 * r / ( R +  1e-40 );

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
    %         frontCandidate(end+1) = AFT_stack_sorted(i,6);
            frontCandidate(end+1) = i;
        end
    end

    frontCandidateNodes = AFT_stack_sorted(frontCandidate,1:2);
    %%
    %������������һѡ��㣬�ж��Ƿ����ٽ������ཻ�����ཻ����һ����ѡ�㣬�粻�ཻ����ѡ���õ㹹���µ�������
    Qp_sort = sort(Qp, 'descend');
    node_select = -1;
     
%     if nCells_AFT == 107
%         kkk = 1;
%     end
    
    for i = 1 : length(nodeCandidate)
        node_test_list = nodeCandidate( find(Qp==Qp_sort(i)) );
%%     %���ж��ཻ�⣬�����ж��Ƿ񹹳���Ԫ��ֻѡ�񹹳���Ԫ�ĵ�
        for j = 1:length(node_test_list)
            node_test = node_test_list(j);
            flagNotCross = IsNotCross(node1_base, node2_base, node_test, frontCandidate, AFT_stack_sorted, xCoord_tmp, yCoord_tmp);            
            flagLeftCell = IsLeftCell(node1_base, node2_base, node_test, xCoord_tmp, yCoord_tmp);

            if flagNotCross == 1 && flagLeftCell == 1
                node_select = node_test;           
                break;
            end               
        end
        
        if node_select ~= -1
            break;
        end
    end

%% 
    %����������Ϣ
    if node_select ~= -1                      
        if(node_select == node_best)    %ֻ����ѡ���������ɵĵ�ʱ������Ҫ���µ����������            
            xCoord_AFT(end+1) = x_best;
            yCoord_AFT(end+1) = y_best;
        else
             node_best = node_best - 1;   %���û��ѡ��Pbest������Ҫ����1
        end       
        
        %���漰��Ԫ��Ÿ���
        size0 = size(AFT_stack_sorted,1);
        nCells_AFT = nCells_AFT + 1;
        AFT_stack_sorted = Update_AFT_INFO(AFT_stack_sorted, node1_base, ...
            node2_base, node_select,nCells_AFT, xCoord_AFT, yCoord_AFT);
%%        
        %�����������֮�󣬳��˻�׼�����γɵĵ�Ԫ�����п��ܻ��Զ����ɶ����Ԫ����Ҫ�жϡ�
        %�����������в����Զ����ɵĵ�Ԫ���жϷ���Ϊ�ڵ���ڵ�������ڣ��򹹳ɷ�յ�Ԫ
        %��������ڵ�
        if(node_select ~= node_best)
            neighbor = [node1_base, node2_base];
            for i = 1: size(AFT_stack_sorted,1) 
                if( AFT_stack_sorted(i,1)== node_select) 
                    neighbor(end+1) = AFT_stack_sorted(i,2);
                end
                if( AFT_stack_sorted(i,2) == node_select)
                    neighbor(end+1) = AFT_stack_sorted(i,1);
                end
            end
            neighbor = unique(neighbor);
            
    %         �ڵ��������л������ڵģ����γ��µ�Ԫ
            new_cell = [];
            for i = 1:length(neighbor)
                neighborNode = neighbor(i);
                for j = 1: size(AFT_stack_sorted,1)
                    if( AFT_stack_sorted(j,1) == neighborNode ) %�ڵ���������
                        if( find(neighbor==AFT_stack_sorted(j,2)) )  %�ڵ���ڵ����
                            new_cell(end+1,:) = [node_select, neighborNode, AFT_stack_sorted(j,2)];
                        end
                    end
                    if(AFT_stack_sorted(j,2) == neighborNode)
                        if( find(neighbor==AFT_stack_sorted(j,1)) )
                            new_cell(end+1,:) = [node_select, neighborNode, AFT_stack_sorted(j,1)];
                        end                    
                    end
                end
            end
            
            %ȥ���ظ��ĵ�Ԫ
            for i = 1 : size(new_cell,1)
               iCell = new_cell(i,:);
               for j = i+1:size(new_cell,1)
                   jCell = new_cell(j,:); 
                   if( sum(jCell([3,2]) == iCell([2,3])) == 2)
                       new_cell(j,:)=-1;
                   end
               end
            end
            
            II = find(new_cell(:,1) == -1);
            new_cell(II,:)=[];
            
            %��Ҫȥ���Ѿ��еĵ�Ԫ
            for i = 1 : size(new_cell,1)
                iCell = new_cell(i,:);
                if(size(find(iCell==node1_base),2) && size(find(iCell==node2_base),2) && size(find(iCell==node_select),2))
                    new_cell(i,:)=-1;
                end
            end
            
            II = find(new_cell(:,1) == -1);
            new_cell(II,:)=[]; 
            
            %���µ�Ԫ�������ݽṹ
            for i = 1:size(new_cell,1) 
                nCells_AFT = nCells_AFT + 1;
                node1 = new_cell(i,1);
                node2 = new_cell(i,2);
                node3 = new_cell(i,3);

                AFT_stack_sorted = Update_AFT_INFO_GENERAL(AFT_stack_sorted, ...
                    node1, node2, node3, nCells_AFT , xCoord_AFT, yCoord_AFT);         
            end            
        end
        
        size1 = size(AFT_stack_sorted,1);
        PLOT_NEW_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, size1-size0);
        hold on;
        
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
                AFT_stack(end+1,:) = AFT_stack_sorted(i,:);
                AFT_stack_sorted(i,:)=-1;
            end
        end
        
        AFT_stack_sorted( find(AFT_stack_sorted(:,1) == -1), : ) = [];
        
        AFT_stack_sorted = sortrows(AFT_stack_sorted, 5);        
    else
        %%δ�ҵ�node_select�������Ӧ�ñȽ��ټ�
        disp('δ�ҵ�node_select�����...,�޷��ƽ������飡');
        node_best = node_best - 1;
        
        tmp = AFT_stack_sorted(1,:);
        AFT_stack_sorted(1,:) = AFT_stack_sorted(2,:);
        AFT_stack_sorted(2,:) = tmp;        
    end
    
%     AFT_stack = AFT_stack_sorted;    
end

disp(['�����ƽ���ɣ���Ԫ����', num2str(nCells_AFT)]);
disp(['�����ƽ���ɣ��ڵ�����', num2str(length(xCoord_AFT))]);
disp(['�����ƽ���ɣ��������', num2str(size(AFT_stack,1))]);
toc
    
    






