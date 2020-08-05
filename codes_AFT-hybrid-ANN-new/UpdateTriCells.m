function  [AFT_stack_sorted, nCells_AFT] = UpdateTriCells(AFT_stack_sorted, nCells_AFT, xCoord_AFT, yCoord_AFT, node_select, flag_best)
global epsilon cellNodeTopo outGridType;
%���漰��Ԫ��Ÿ���
node1_base = AFT_stack_sorted(1,1);         %����Ļ�׼��
node2_base = AFT_stack_sorted(1,2);

nCells_AFT = nCells_AFT + 1;
AFT_stack_sorted = Update_AFT_INFO_TRI(AFT_stack_sorted, node1_base, ...
    node2_base, node_select,nCells_AFT, xCoord_AFT, yCoord_AFT);
%%
%�����������֮�󣬳��˻�׼�����γɵĵ�Ԫ�����п��ܻ��Զ����ɶ����Ԫ����Ҫ�жϡ�
%�����������в����Զ����ɵĵ�Ԫ���жϷ���Ϊ�ڵ���ڵ�������ڣ��򹹳ɷ�յ�Ԫ
%��������ڵ�
% if flag_best == 0
%     neighbor = [node1_base, node2_base];
%     for i = 1: size(AFT_stack_sorted,1)
%         if( AFT_stack_sorted(i,1)== node_select)
%             neighbor(end+1) = AFT_stack_sorted(i,2);
%         end
%         if( AFT_stack_sorted(i,2) == node_select)
%             neighbor(end+1) = AFT_stack_sorted(i,1);
%         end
%     end
%     neighbor = unique(neighbor);
%     
%     %         �ڵ��������л������ڵģ����γ��µ�Ԫ
%     new_cell = [];
%     for i = 1:length(neighbor)
%         neighborNode = neighbor(i);
%         for j = 1: size(AFT_stack_sorted,1)
%             if( AFT_stack_sorted(j,1) == neighborNode ) %�ڵ���������
%                 if( find(neighbor==AFT_stack_sorted(j,2)) )  %�ڵ���ڵ����
%                     new_cell(end+1,:) = [node_select, neighborNode, AFT_stack_sorted(j,2)];
%                 end
%             end
%             if(AFT_stack_sorted(j,2) == neighborNode)
%                 if( find(neighbor==AFT_stack_sorted(j,1)) )
%                     new_cell(end+1,:) = [node_select, neighborNode, AFT_stack_sorted(j,1)];
%                 end
%             end
%         end
%     end
%     
%     %ȥ���ظ��ĵ�Ԫ
%     for i = 1 : size(new_cell,1)
%         iCell = new_cell(i,:);
%         for j = i+1:size(new_cell,1)
%             jCell = new_cell(j,:);
%             if( sum(jCell([3,2]) == iCell([2,3])) == 2 || sum(jCell([2,3]) == iCell([2,3])) == 2)
%                 new_cell(j,:)=-1;
%             end
%         end
%     end
%     
%     II = new_cell(:,1) == -1;
%     new_cell(II,:)=[];
%     
%     %��Ҫȥ���Ѿ��еĵ�Ԫ
%     for i = 1 : size(new_cell,1)
%         iCell = new_cell(i,:);
%         if(size(find(iCell==node1_base),2) && size(find(iCell==node2_base),2) && size(find(iCell==node_select),2))
%             new_cell(i,:)=-1;
%         end
%     end
%     
%     II = new_cell(:,1) == -1;
%     new_cell(II,:)=[];
%     
%     %���µ�Ԫ�������ݽṹ
%     for i = 1:size(new_cell,1)
%         nCells_AFT = nCells_AFT + 1;
%         node1 = new_cell(i,1);
%         node2 = new_cell(i,2);
%         node3 = new_cell(i,3);
%         
%         AFT_stack_sorted = Update_AFT_INFO_GENERAL_TRI(AFT_stack_sorted, ...
%             node1, node2, node3, nCells_AFT , xCoord_AFT, yCoord_AFT);
%     end
% end

%%
    if(flag_best== 0)
        neighbor1 = NeighborNodes(node_select(1), AFT_stack_sorted,-1);%�ҳ����е�����ڵ�
        neighbor1 = [node1_base, neighbor1];
        neighbor1 = unique(neighbor1);
        
        %�ڵ���ڵ� �� �ڵ� �������л������ڵģ����γ��µ�Ԫ
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
        
%% ȥ���ظ��ĵ�Ԫ
        for i = 1 : size(new_cell,1)
            iCell = new_cell(i,:);
            iCell(iCell<0) = [];%
            iCell = unique(iCell);%
            for j = i+1:size(new_cell,1)
                jCell = new_cell(j,:);
                jCell(jCell<0) = [];%
                jCell = unique(jCell);  %
                if( length(iCell) == length(jCell) && length(iCell) == 4 && ( sum(jCell == iCell) == 4 ) )
                    new_cell(j,:)=-1;
                elseif ( length(iCell) == length(jCell) && length(iCell) == 3 && ( sum(jCell == iCell) == 3 ) )
                    new_cell(j,:)=-1;
                end
            end
        end      
        II = new_cell(:,1) == -1;
        new_cell(II,:)=[];
%% ȥ���ظ��ĵ�Ԫ ���ܻ��ظ������ı��κ�������
        for i = 1 : size(new_cell,1)
            iCell = new_cell(i,:);
            for j = i+1:size(new_cell,1)
                jCell = new_cell(j,:);
                tmp = intersect(iCell,jCell);
                tmp( tmp< 0 ) = [];
                if length(tmp)==3
                    iCell(iCell<0)=[];
                    jCell(jCell<0)=[];
                    if length(iCell) == 4
                        new_cell(i,:)=-1;
                    elseif length(jCell) == 4
                        new_cell(j,:)=-1;
                    end
                end
            end
        end
        II = new_cell(:,1) == -1;
        new_cell(II,:)=[];        
%% ��Ҫȥ���Ѿ��еĵ�Ԫ
        for i = 1 : size(new_cell,1)
            iCell = new_cell(i,:);
            [~, row] = CellExist(iCell(1), iCell(2), iCell(3), iCell(4), cellNodeTopo);
            if row ~= -1
                new_cell(i,:)=-1;
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
           elseif node4 < 0
               [quality,~] = QualityCheckTri(node1, node2, node3, xCoord_AFT, yCoord_AFT, -1);
%                 if abs( 1.5- quality ) > epsilon
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
            
            flagInCell = IsAnyPointInCell(iCell, xCoord_AFT, yCoord_AFT);
            if flagInCell == 1
                new_cell(i,:)=-1;
            end
        end
        II = new_cell(:,1) == -1;
        new_cell(II,:)=[];
        
%% ���µ�Ԫ�������ݽṹ
        for i = 1:size(new_cell,1)
            nCells_AFT = nCells_AFT + 1;
            node1 = new_cell(i,1);
            node2 = new_cell(i,2);
            node3 = new_cell(i,3);
            node4 = new_cell(i,4);

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
        end
    end

end