function [AFT_stack_sorted, nCells_AFT] = UpdateQuadCells(AFT_stack_sorted, nCells_AFT, outGridType, xCoord_AFT, yCoord_AFT, node_select, flag_best) 
global epsilon;
%%
    %���漰��Ԫ��Ÿ���
    node1_base = AFT_stack_sorted(1,1);         %����Ļ�׼��
    node2_base = AFT_stack_sorted(1,2);
%%
%     x1 = xCoord_AFT(node1_base);
%     y1 = yCoord_AFT(node1_base);
% 
%     x2 = xCoord_AFT(node2_base);
%     y2 = yCoord_AFT(node2_base);
%     
%     nCells_AFT = nCells_AFT + 1;    
%     if  y1 >0 && y2 > 0%����ı��ε�Ԫ
%         AFT_stack_sorted = Update_AFT_INFO_quad(AFT_stack_sorted, node1_base, ...
%             node2_base, node_select, nCells_AFT, xCoord_AFT, yCoord_AFT);
%     else%��һ���ı����ʷֳ�2��ֱ��������
%         AFT_stack_sorted = Update_AFT_INFO_TRI(AFT_stack_sorted, node1_base, ...
%             node2_base, node_select(2),nCells_AFT, xCoord_AFT, yCoord_AFT);
%         
%         nCells_AFT = nCells_AFT + 1;
%         AFT_stack_sorted = Update_AFT_INFO_GENERAL_TRI(AFT_stack_sorted, node1_base, ...
%             node_select(2), node_select(1),nCells_AFT , xCoord_AFT, yCoord_AFT);
%         
% %         AFT_stack_sorted = Update_AFT_INFO_GENERAL_TRI(AFT_stack_sorted, node1_base, ...
% %             node2_base, node_select(2),nCells_AFT, xCoord_AFT, yCoord_AFT);        
% %         AFT_stack_sorted = Update_AFT_INFO_GENERAL_TRI(AFT_stack_sorted, node1_base, ...
% %             node_select(2), node_select(1),nCells_AFT , xCoord_AFT, yCoord_AFT);
%     end
    %%
    nCells_AFT = nCells_AFT + 1;    
    if outGridType == 0    %����ı��ε�Ԫ
        AFT_stack_sorted = Update_AFT_INFO_quad(AFT_stack_sorted, node1_base, ...
            node2_base, node_select, nCells_AFT, xCoord_AFT, yCoord_AFT);
    elseif outGridType == 1  %��һ���ı����ʷֳ�2��ֱ��������
        AFT_stack_sorted = Update_AFT_INFO_TRI(AFT_stack_sorted, node1_base, ...
            node2_base, node_select(2),nCells_AFT, xCoord_AFT, yCoord_AFT);
        
        nCells_AFT = nCells_AFT + 1;
        AFT_stack_sorted = Update_AFT_INFO_GENERAL_TRI(AFT_stack_sorted, node1_base, ...
            node_select(2), node_select(1),nCells_AFT , xCoord_AFT, yCoord_AFT);
        
%         AFT_stack_sorted = Update_AFT_INFO_GENERAL_TRI(AFT_stack_sorted, node1_base, ...
%             node2_base, node_select(2),nCells_AFT, xCoord_AFT, yCoord_AFT);        
%         AFT_stack_sorted = Update_AFT_INFO_GENERAL_TRI(AFT_stack_sorted, node1_base, ...
%             node_select(2), node_select(1),nCells_AFT , xCoord_AFT, yCoord_AFT);
    end
    
    %%
    %�����������֮�󣬳��˻�׼�����γɵĵ�Ԫ�����п��ܻ��Զ����ɶ����Ԫ����Ҫ�жϡ�
    %�����������в����Զ����ɵĵ�Ԫ���жϷ���Ϊ�ڵ���ڵ� ���ڵ����ڣ��򹹳ɷ�յ�Ԫ
    if(flag_best(1)== 0 || flag_best(2)== 0 )
        neighbor1 =[];
%         if( flag_best(1)== 0) %û��ѡ��pbest������ѡ�������е㣬�п��ܵ�������������Ԫ
            neighbor1 = NeighborNodes(node_select(1), AFT_stack_sorted,-1);%�ҳ����е�����ڵ�
            neighbor1 = [node1_base, neighbor1];
            neighbor1 = unique(neighbor1);
%         end
        
        neighbor2 =[];
%         if( flag_best(2) == 0 ) %û��ѡ��pbest������ѡ�������е㣬�п��ܵ�������������Ԫ
            neighbor2 = NeighborNodes(node_select(2), AFT_stack_sorted,-1);%�ҳ����е�����ڵ�
            neighbor2 = [node2_base, neighbor2];
            neighbor2 = unique(neighbor2);
%         end
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
        %%
%% ȥ����Ч��Ԫ
        for i = 1 : size(new_cell,1)
            iCell = new_cell(i,:);
            iCell(iCell<0) = [];
            iCell = unique( iCell );
            if length(iCell) < 3
                new_cell(i,:)=-1;
            end
        end
        II = new_cell(:,1) == -1;
        new_cell(II,:)=[];
        
        %%         ȥ���ظ��ĵ�Ԫ
        for i = 1 : size(new_cell,1)
            iCell = new_cell(i,:);
            iCell(iCell<0) = [];%
            iCell = unique(iCell);%
            for j = i+1:size(new_cell,1)
                jCell = new_cell(j,:);
                jCell(jCell<0) = [];%
                jCell = unique(jCell);  %                 
%                     if( sum(unique(jCell) == unique(iCell)) == 4 )
                    if( length(iCell) == length(jCell) && length(iCell) == 4 && ( sum(jCell == iCell) == 4 ) )
                        new_cell(j,:)=-1;
                    elseif ( length(iCell) == length(jCell) && length(iCell) == 3 && ( sum(jCell == iCell) == 3 ) )
                        new_cell(j,:)=-1;
                    end
            end
        end
        
        II = new_cell(:,1) == -1;
        new_cell(II,:)=[];
        
        %%         ��Ҫȥ���Ѿ��еĵ�Ԫ
        for i = 1 : size(new_cell,1)
            iCell = new_cell(i,:);
            if(iCell(4)==-11)    %������
                if(size(find(iCell==node1_base),2) && size(find(iCell==node2_base),2) ...
                        && size(find(iCell==node_select(1)),2) || ...
                        size(find(iCell==node1_base),2) && size(find(iCell==node_select(1)),2) ...
                        && size(find(iCell==node_select(2)),2) || ...
                        size(find(iCell==node2_base),2) && size(find(iCell==node_select(1)),2) ...
                        && size(find(iCell==node_select(2)),2) )
                    new_cell(i,:)=-1;
                end
            elseif(iCell(4)==-22) %������
                if(size(find(iCell==node1_base),2) && size(find(iCell==node2_base),2) ...
                        && size(find(iCell==node_select(2)),2) || ...
                        size(find(iCell==node1_base),2) && size(find(iCell==node_select(1)),2) ...
                        && size(find(iCell==node_select(2)),2) || ...
                        size(find(iCell==node2_base),2) && size(find(iCell==node_select(1)),2) ...
                        && size(find(iCell==node_select(2)),2) )
                    new_cell(i,:)=-1;
                end
            else               %�ı���
                if(size(find(iCell==node1_base),2) && size(find(iCell==node2_base),2) ...
                        && size(find(iCell==node_select(1)),2)&& size(find(iCell==node_select(2)),2))
                    new_cell(i,:)=-1;
                end
            end
        end
        
        II = new_cell(:,1) == -1;
        new_cell(II,:)=[];
        
        %% ��Ҫȥ���������õĵ�Ԫ
        for i = 1 : size(new_cell,1)
            node1 = new_cell(i,1);
            node2 = new_cell(i,2);
            node3 = new_cell(i,3);
            node4 = new_cell(i,4);
           if node4 > 0
               [quality,~] = QualityCheckQuad(node1, node2, node3, node4, xCoord_AFT, yCoord_AFT, -1);
               if abs( 1.0- quality ) > epsilon
                   new_cell(i,:)=-1;
               end
           end
        end
        II = new_cell(:,1) == -1;
        new_cell(II,:)=[];
        
        %% ��Ҫ�ж��Ƿ��е������µ�Ԫ�ڲ�
        for i = 1 : size(new_cell,1)
            iCell = new_cell(i,:);
            
            flagInCell = IsAnyPointInCell(iCell, xCoord_AFT, xCoord_AFT);
            if flagInCell == 1
                new_cell(i,:)=-1;
            end
        end
        II = new_cell(:,1) == -1;
        new_cell(II,:)=[];
        
        %%         ���µ�Ԫ�������ݽṹ
        for i = 1:size(new_cell,1)
            nCells_AFT = nCells_AFT + 1;
            node1 = new_cell(i,1);
            node2 = new_cell(i,2);
            node3 = new_cell(i,3);
            node4 = new_cell(i,4);
            %%
            if (node4 > 0)
                if outGridType == 0
                    AFT_stack_sorted = Update_AFT_INFO_GENERAL_quad(AFT_stack_sorted, ...
                        node1, node2, node3, node4, nCells_AFT, xCoord_AFT, yCoord_AFT);
                elseif outGridType == 1
                    AFT_stack_sorted = Update_AFT_INFO_GENERAL_TRI(AFT_stack_sorted, ...
                        node1, node2, node3, nCells_AFT, xCoord_AFT, yCoord_AFT);
                    
                    nCells_AFT = nCells_AFT + 1;
                    AFT_stack_sorted = Update_AFT_INFO_GENERAL_TRI(AFT_stack_sorted, ...
                        node1, node3, node4, nCells_AFT, xCoord_AFT, yCoord_AFT);
                end
            elseif (node4 < 0)
                AFT_stack_sorted = Update_AFT_INFO_GENERAL_TRI(AFT_stack_sorted, ...
                    node1, node2, node3, nCells_AFT, xCoord_AFT, yCoord_AFT);
            end
       %%
%            if (node4 > 0)
%                if y1 >0 && y2 > 0
%                    AFT_stack_sorted = Update_AFT_INFO_GENERAL_quad(AFT_stack_sorted, ...
%                        node1, node2, node3, node4, nCells_AFT , xCoord_AFT, yCoord_AFT);
%                else
%                    AFT_stack_sorted = Update_AFT_INFO_GENERAL_TRI(AFT_stack_sorted, ...
%                        node1, node2, node3,nCells_AFT, xCoord_AFT, yCoord_AFT);
% 
%                    nCells_AFT = nCells_AFT + 1;
%                    AFT_stack_sorted = Update_AFT_INFO_GENERAL_TRI(AFT_stack_sorted, ...
%                        node1, node3, node4,nCells_AFT , xCoord_AFT, yCoord_AFT);
%                end
%            elseif (node4 < 0)
%                AFT_stack_sorted = Update_AFT_INFO_GENERAL_TRI(AFT_stack_sorted, ...
%                    node1, node2, node3, nCells_AFT , xCoord_AFT, yCoord_AFT);
%            end
  %%     
        end
    end

    %%
%     AFT_stack_updated = AFT_stack_sorted;
    end