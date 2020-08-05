function  [AFT_stack_sorted, nCells_AFT] = UpdateTriCells(AFT_stack_sorted, nCells_AFT, xCoord_AFT, yCoord_AFT, node_select, flag_best)
global epsilon cellNodeTopo outGridType;
%阵面及左单元编号更新
node1_base = AFT_stack_sorted(1,1);         %阵面的基准点
node2_base = AFT_stack_sorted(1,2);

nCells_AFT = nCells_AFT + 1;
AFT_stack_sorted = Update_AFT_INFO_TRI(AFT_stack_sorted, node1_base, ...
    node2_base, node_select,nCells_AFT, xCoord_AFT, yCoord_AFT);
%%
%新增点和阵面之后，除了基准阵面形成的单元，还有可能会自动构成多个单元，需要判断。
%在已有阵面中查找自动构成的单元，判断方法为邻点的邻点如果相邻，则构成封闭单元
%新增点的邻点
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
%     %         邻点中若是有互相相邻的，则形成新单元
%     new_cell = [];
%     for i = 1:length(neighbor)
%         neighborNode = neighbor(i);
%         for j = 1: size(AFT_stack_sorted,1)
%             if( AFT_stack_sorted(j,1) == neighborNode ) %邻点所在阵面
%                 if( find(neighbor==AFT_stack_sorted(j,2)) )  %邻点的邻点如果
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
%     %去掉重复的单元
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
%     %还要去掉已经有的单元
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
%     %将新单元加入数据结构
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
        neighbor1 = NeighborNodes(node_select(1), AFT_stack_sorted,-1);%找出现有点的相邻点
        neighbor1 = [node1_base, neighbor1];
        neighbor1 = unique(neighbor1);
        
        %邻点的邻点 和 邻点 中若是有互相相邻的，则形成新单元
        new_cell = [];
        for i = 1:length(neighbor1)
            neighborNode = neighbor1(i); %邻点
            for j = 1: size(AFT_stack_sorted,1)
                if( AFT_stack_sorted(j,1) == neighborNode && AFT_stack_sorted(j,2)~= node_select(1)) %邻点所在阵面j
                    neighborNodeOfNeighbor = AFT_stack_sorted(j,2); %邻点的邻点
                    
                    if( find(neighbor1==neighborNodeOfNeighbor) )  %邻点的邻点如果相邻，则为三角形
                        new_cell(end+1,:) = [node_select(1), neighborNode, neighborNodeOfNeighbor, -11];
                    end
                    
                    for k = 1:size(AFT_stack_sorted,1)
                        if( AFT_stack_sorted(k,1) == neighborNodeOfNeighbor && AFT_stack_sorted(k,2)~= neighborNode )   %邻点的邻点所在阵面k
                            if(find(neighbor1==AFT_stack_sorted(k,2)))   %邻点的邻点的邻点AFT_stack_sorted(k,2)
                                new_cell(end+1,:) = [node_select(1), neighborNode, neighborNodeOfNeighbor, AFT_stack_sorted(k,2)];
                            end
                        elseif ( AFT_stack_sorted(k,2) == neighborNodeOfNeighbor && AFT_stack_sorted(k,1)~= neighborNode )   %邻点的邻点所在阵面k
                            if(find(neighbor1==AFT_stack_sorted(k,1)))   %邻点的邻点的邻点AFT_stack_sorted(k,1)
                                new_cell(end+1,:) = [node_select(1), neighborNode, neighborNodeOfNeighbor, AFT_stack_sorted(k,1)];
                            end
                        end
                    end
                elseif( AFT_stack_sorted(j,2) == neighborNode && AFT_stack_sorted(j,1)~= node_select(1)) %邻点所在阵面j
                    neighborNodeOfNeighbor = AFT_stack_sorted(j,1);%邻点的邻点
                    
                    if( find(neighbor1==neighborNodeOfNeighbor) )  %邻点的邻点如果相邻，则为三角形
                        new_cell(end+1,:) = [node_select(1), neighborNode, neighborNodeOfNeighbor, -11];
                    end
                    
                    for k = 1:size(AFT_stack_sorted,1)
                        if( AFT_stack_sorted(k,1) == neighborNodeOfNeighbor && AFT_stack_sorted(k,2)~= neighborNode )%邻点的邻点所在阵面
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
%% 去掉无效单元
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
        
%% 去掉重复的单元
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
%% 去掉重复的单元 可能会重复考虑四边形和三角形
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
%% 还要去掉已经有的单元
        for i = 1 : size(new_cell,1)
            iCell = new_cell(i,:);
            [~, row] = CellExist(iCell(1), iCell(2), iCell(3), iCell(4), cellNodeTopo);
            if row ~= -1
                new_cell(i,:)=-1;
            end
        end    
        II = new_cell(:,1) == -1;
        new_cell(II,:)=[];
        
%% 还要去掉质量不好的单元
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

%% 还要判断是否有点落在新单元内部
        for i = 1 : size(new_cell,1)
            iCell = new_cell(i,:);
            
            flagInCell = IsAnyPointInCell(iCell, xCoord_AFT, yCoord_AFT);
            if flagInCell == 1
                new_cell(i,:)=-1;
            end
        end
        II = new_cell(:,1) == -1;
        new_cell(II,:)=[];
        
%% 将新单元加入数据结构
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