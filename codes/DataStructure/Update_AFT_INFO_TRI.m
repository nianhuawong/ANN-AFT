function AFT_stack_sorted = Update_AFT_INFO_TRI(AFT_stack_sorted, node1_base, node2_base, node_select, nCells_AFT , xCoord_AFT, yCoord_AFT)
global cellNodeTopo;
cellNodeTopo(end+1,:) = [node1_base, node2_base, node_select];

%%
dist1 = DISTANCE(node1_base, node_select, xCoord_AFT, yCoord_AFT);
dist2 = DISTANCE(node2_base, node_select, xCoord_AFT, yCoord_AFT);

%%
%对于基准阵面，按照正常逻辑更新，左单元=>左单元，右单元=>右单元
flag1 = IsLeftCell(node1_base, node2_base, node_select, xCoord_AFT, yCoord_AFT);     
if( flag1 == 1 )
    AFT_stack_sorted(1,3) = nCells_AFT;
else
    AFT_stack_sorted(1,4) = nCells_AFT;
end

%%
%对于非基准阵面，分2种情况，对已存在的阵面按照正常逻辑更新，对于新引入的阵面，按照反的逻辑来更新
flag2 = IsLeftCell(node_select, node1_base, node2_base, xCoord_AFT, yCoord_AFT);  %判断新增单元是否为（node_select，node1_base）左单元
[direction, row] = FrontExist(node_select,node1_base, AFT_stack_sorted);  %判断阵面（node_select，node1_base）是否已经存在及其在AFT_stack_sorted中的方向
if( flag2 == 1 )  %如果为左单元
    if( row ~= -1 )   %如果已经存在
        if(direction == 1) %如果AFT_stack_sorted中存储方向为（node_select，node1_base）
            AFT_stack_sorted(row, 3) = nCells_AFT;  %则更新到左单元
        elseif(direction == -1)
            AFT_stack_sorted(row, 4) = nCells_AFT;  %否则更新到右单元
        end
    else    %如果不存在，则按反的逻辑新增阵面，即阵面方向反过来（node1_base, node_select），nCells_AFT更新到右单元，左单元不更新
        AFT_stack_sorted(end+1,:) = [node1_base, node_select, -1, nCells_AFT, dist1,  size(AFT_stack_sorted,1)+1, 2];  
    end
else   %如果为右单元
    if( row ~= -1 )  %如果已经存在
        if(direction == 1)  %如果AFT_stack_sorted中存储方向为（node_select，node1_base）
            AFT_stack_sorted(row, 4) = nCells_AFT; %更新到右单元
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT; %否则更新到左单元
        end
    else  %如果不存在，则按反的逻辑新增阵面，即阵面方向反过来（node1_base, node_select），nCells_AFT更新到左单元，右单元不更新
        AFT_stack_sorted(end+1,:) = [node1_base, node_select, nCells_AFT, -1, dist1,  size(AFT_stack_sorted,1)+1, 2];  
    end
end 

flag3 = IsLeftCell(node2_base, node_select, node1_base, xCoord_AFT, yCoord_AFT);
[direction, row] = FrontExist(node2_base,node_select, AFT_stack_sorted); 
if( flag3 == 1 ) %如果为左单元
    if( row ~= -1 )%如果已经存在
        if(direction == 1)%如果AFT_stack_sorted中存储方向为（node2_base, node_select）
            AFT_stack_sorted(row, 3) = nCells_AFT;%则更新到左单元
        elseif(direction == -1)
            AFT_stack_sorted(row, 4) = nCells_AFT;%否则更新到右单元
        end
    else  %如果不存在，则按反的逻辑新增阵面，即阵面方向反过来（node1_base, node_select），nCells_AFT更新到右单元，左单元不更新           
        AFT_stack_sorted(end+1,:) = [node_select, node2_base, -1, nCells_AFT, dist2,  size(AFT_stack_sorted,1)+1, 2];  
    end
else %如果为右单元
    if( row ~= -1 ) %如果已经存在
        if(direction == 1) %如果AFT_stack_sorted中存储方向为（node2_base, node_select）
            AFT_stack_sorted(row, 4) = nCells_AFT;  %更新到右单元
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT;  %否则更新到左单元
        end
    else  %如果不存在，则按反的逻辑新增阵面，即阵面方向反过来（node_select, node2_base），nCells_AFT更新到左单元，右单元不更新
        AFT_stack_sorted(end+1,:) = [node_select, node2_base, nCells_AFT, -1, dist2,  size(AFT_stack_sorted,1)+1, 2];              
    end
end      