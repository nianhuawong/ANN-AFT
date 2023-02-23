function AFT_stack_sorted = Update_AFT_INFO_GENERAL_TRI(AFT_stack_sorted, node1, node2, node3, nCells_AFT , xCoord_AFT, yCoord_AFT)
global cellNodeTopo;
cellNodeTopo(end+1,:) = [node1, node2, node3];

dist12 = DISTANCE(node1, node2, xCoord_AFT, yCoord_AFT);
dist13 = DISTANCE(node1, node3, xCoord_AFT, yCoord_AFT);
dist23 = DISTANCE(node2, node3, xCoord_AFT, yCoord_AFT);
%%
flag1 = IsLeftCell(node1, node2, node3, xCoord_AFT, yCoord_AFT);
[direction, row] = FrontExist(node1,node2, AFT_stack_sorted);    
if( flag1 == 1 )        %如果为左单元        
    if( row ~= -1 )  %如果已经存在
        if(direction == 1)  %如果AFT_stack_sorted中存储方向为（node1，node2）
            AFT_stack_sorted(row, 3) = nCells_AFT;%则更新到左单元
        elseif( direction == -1 )
            AFT_stack_sorted(row, 4) = nCells_AFT; %否则更新到右单元
        end                                                   
    else %如果不存在，则按反的逻辑新增阵面，即阵面方向反过来（node2, node1），nCells_AFT更新到右单元，左单元不更新
        AFT_stack_sorted(end+1,:) = [node2, node1, -1, nCells_AFT, dist12, size(AFT_stack_sorted,1)+1, 2];                     
    end
else  %如果为右单元
    if( row ~= -1 ) %如果已经存在
        if(direction == 1) %如果AFT_stack_sorted中存储方向为（node1，node2）
            AFT_stack_sorted(row, 4) = nCells_AFT; %则更新到右单元
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT; %否则更新到左单元
        end                        
    else%如果不存在，则按反的逻辑新增阵面，即阵面方向反过来（node2, node1），nCells_AFT更新到左单元，右单元不更新
        AFT_stack_sorted(end+1,:) = [node2, node1, nCells_AFT, -1, dist12, size(AFT_stack_sorted,1)+1, 2];                     
    end
end

flag2 = IsLeftCell(node2, node3, node1, xCoord_AFT, yCoord_AFT);
[direction, row] = FrontExist(node2,node3, AFT_stack_sorted); 
if( flag2 == 1 )
    if( row ~= -1 )
        if(direction == 1)
            AFT_stack_sorted(row, 3) = nCells_AFT;
        elseif( direction == -1 )
            AFT_stack_sorted(row, 4) = nCells_AFT;
        end  
    else
        AFT_stack_sorted(end+1,:) = [node3, node2, -1, nCells_AFT, dist23, size(AFT_stack_sorted,1)+1, 2];                     
    end                
else
    if( row ~= -1 )
        if(direction == 1)
            AFT_stack_sorted(row, 4) = nCells_AFT; 
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT;
        end 
    else
        AFT_stack_sorted(end+1,:) = [node3, node2, nCells_AFT, -1, dist23, size(AFT_stack_sorted,1)+1, 2];                     
    end
end

flag3 = IsLeftCell(node3, node1, node2, xCoord_AFT, yCoord_AFT);
[direction, row] = FrontExist(node3,node1, AFT_stack_sorted); 
if( flag3 == 1 )
    if( row ~= -1 )
        if(direction == 1)
            AFT_stack_sorted(row, 3) = nCells_AFT;
        elseif( direction == -1 )
            AFT_stack_sorted(row, 4) = nCells_AFT;
        end  
    else
        AFT_stack_sorted(end+1,:) = [node1, node3, -1, nCells_AFT, dist13, size(AFT_stack_sorted,1)+1, 2];                     
    end                
else
    if( row ~= -1 )
        if(direction == 1)
            AFT_stack_sorted(row, 4) = nCells_AFT; 
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT;
        end 
    else
        AFT_stack_sorted(end+1,:) = [node1, node3, nCells_AFT, -1, dist13, size(AFT_stack_sorted,1)+1, 2];                     
    end
end    