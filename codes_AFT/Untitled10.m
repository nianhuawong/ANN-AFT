        nCells_AFT = nCells_AFT + 1;
        flag1 = IsLeftCell(node1_base, node2_base, node_select, xCoord_AFT, yCoord_AFT);
        if( flag1 == 1 )
            AFT_stack_sorted(1,3) = nCells_AFT;
        else
            AFT_stack_sorted(1,4) = nCells_AFT;
        end
        
        flag2 = IsLeftCell(node2_base, node_select, node1_base, xCoord_AFT, yCoord_AFT);
        if( flag2 == 1 )
%             AFT_stack_sorted(end+1,[1 2 3 5 6]) = [node2_base, node_select, nCells_AFT, dist2,  size(AFT_stack_sorted,1)+1];  
%             AFT_stack_sorted(end+1,:) = [node2_base, node_select, nCells_AFT, -1, dist2,  size(AFT_stack_sorted,1)+1];  
            AFT_stack_sorted(end+1,:) = [node_select, node2_base, nCells_AFT, -1, dist2,  size(AFT_stack_sorted,1)+1];  
        else
%             AFT_stack_sorted(end+1,[1 2 4 5 6]) = [node2_base, node_select, nCells_AFT, dist2,  size(AFT_stack_sorted,1)+1];  
%             AFT_stack_sorted(end+1,:) = [node2_base, node_select, -1, nCells_AFT, dist2,  size(AFT_stack_sorted,1)+1];  
            AFT_stack_sorted(end+1,:) = [node_select, node2_base, -1, nCells_AFT, dist2,  size(AFT_stack_sorted,1)+1];              
        end
        
        flag3 = IsLeftCell(node_select, node1_base, node2_base, xCoord_AFT, yCoord_AFT);
        if( flag3 == 1 )
%             AFT_stack_sorted(end+1,[1 2 3 5 6]) = [node_select,node1_base, nCells_AFT, dist1,  size(AFT_stack_sorted,1)+1];  
%             AFT_stack_sorted(end+1,:) = [node_select,node1_base, nCells_AFT, -1, dist1,  size(AFT_stack_sorted,1)+1];  
            AFT_stack_sorted(end+1,:) = [node1_base, node_select, nCells_AFT, -1, dist1,  size(AFT_stack_sorted,1)+1];  
        else
%             AFT_stack_sorted(end+1,[1 2 4 5 6]) = [node_select,node1_base, nCells_AFT, dist1,  size(AFT_stack_sorted,1)+1];  
%             AFT_stack_sorted(end+1,:) = [node_select,node1_base, -1, nCells_AFT, dist1,  size(AFT_stack_sorted,1)+1];  
            AFT_stack_sorted(end+1,:) = [node1_base, node_select, -1, nCells_AFT, dist1,  size(AFT_stack_sorted,1)+1];  
        end  