function AFT_stack_sorted = Update_AFT_INFO_GENERAL_quad(AFT_stack_sorted, node1, node2, node3, node4, nCells_AFT, xCoord_AFT, yCoord_AFT)
global cellNodeTopo nCells_quad;
cellNodeTopo(end+1,:) = [node1, node2, node3, node4];
nCells_quad = nCells_quad + 1;

flagConvexPoly = IsConvexPloygon(node1, node2, node3, node4, xCoord_AFT, yCoord_AFT);
if flagConvexPoly == 0 
    return;
end

dist12 = DISTANCE(node1, node2, xCoord_AFT, yCoord_AFT);
dist23 = DISTANCE(node2, node3, xCoord_AFT, yCoord_AFT);
dist34 = DISTANCE(node3, node4, xCoord_AFT, yCoord_AFT);
dist14 = DISTANCE(node1, node4, xCoord_AFT, yCoord_AFT);
%%
flag11 = IsLeftCell(node1, node2, node3, xCoord_AFT, yCoord_AFT);  %判断新增单元是否为左单元
flag12 = IsLeftCell(node1, node2, node4, xCoord_AFT, yCoord_AFT);
[direction, row] = FrontExist(node1, node2, AFT_stack_sorted);  %判断阵面是否已经存在及其在AFT_stack_sorted中的方向
if( flag11 == 1 && flag12 == 1)  %如果为左单元
    if( row ~= -1 )   %如果已经存在
        if(direction == 1) %如果AFT_stack_sorted中存储方向为（node_select，node1_base）
            AFT_stack_sorted(row, 3) = nCells_AFT;  %则更新到左单元
        elseif(direction == -1)
            AFT_stack_sorted(row, 4) = nCells_AFT;  %否则更新到右单元
        end
    else    %如果不存在，则按反的逻辑新增阵面，即阵面方向反过来（node1_base, node_select），nCells_AFT更新到右单元，左单元不更新
        AFT_stack_sorted(end+1,:) = [node2, node1, -1, nCells_AFT, dist12,  size(AFT_stack_sorted,1)+1, 2];  
    end
else   %如果为右单元
    if( row ~= -1 )  %如果已经存在
        if(direction == 1)  %如果AFT_stack_sorted中存储方向为（node_select，node1_base）
            AFT_stack_sorted(row, 4) = nCells_AFT; %更新到右单元
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT; %否则更新到左单元
        end
    else  %如果不存在，则按反的逻辑新增阵面，即阵面方向反过来（node1_base, node_select），nCells_AFT更新到左单元，右单元不更新
        AFT_stack_sorted(end+1,:) = [node2, node1, nCells_AFT, -1, dist12,  size(AFT_stack_sorted,1)+1, 2];  
    end
end 

%%
%对于非基准阵面，分2种情况，对已存在的阵面按照正常逻辑更新，对于新引入的阵面，按照反的逻辑来更新
flag21 = IsLeftCell(node2, node3, node4, xCoord_AFT, yCoord_AFT);  %判断新增单元是否为（node_select，node1_base）左单元
flag22 = IsLeftCell(node2, node3, node1, xCoord_AFT, yCoord_AFT);
[direction, row] = FrontExist(node2, node3, AFT_stack_sorted);  %判断阵面（node_select，node1_base）是否已经存在及其在AFT_stack_sorted中的方向
if( flag21 == 1 && flag22 == 1)  %如果为左单元
    if( row ~= -1 )   %如果已经存在
        if(direction == 1) %如果AFT_stack_sorted中存储方向为（node_select，node1_base）
            AFT_stack_sorted(row, 3) = nCells_AFT;  %则更新到左单元
        elseif(direction == -1)
            AFT_stack_sorted(row, 4) = nCells_AFT;  %否则更新到右单元
        end
    else    %如果不存在，则按反的逻辑新增阵面，即阵面方向反过来（node1_base, node_select），nCells_AFT更新到右单元，左单元不更新
        AFT_stack_sorted(end+1,:) = [node3, node2, -1, nCells_AFT, dist23,  size(AFT_stack_sorted,1)+1, 2];  
    end
else   %如果为右单元
    if( row ~= -1 )  %如果已经存在
        if(direction == 1)  %如果AFT_stack_sorted中存储方向为（node_select，node1_base）
            AFT_stack_sorted(row, 4) = nCells_AFT; %更新到右单元
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT; %否则更新到左单元
        end
    else  %如果不存在，则按反的逻辑新增阵面，即阵面方向反过来（node1_base, node_select），nCells_AFT更新到左单元，右单元不更新
        AFT_stack_sorted(end+1,:) = [node3, node2, nCells_AFT, -1, dist23,  size(AFT_stack_sorted,1)+1, 2];  
    end
end 

flag31 = IsLeftCell(node3, node4, node1, xCoord_AFT, yCoord_AFT);
flag32 = IsLeftCell(node3, node4, node2, xCoord_AFT, yCoord_AFT);
[direction, row] = FrontExist(node3, node4, AFT_stack_sorted); 
if( flag31 == 1 && flag32 == 1 ) %如果为左单元
    if( row ~= -1 )%如果已经存在
        if(direction == 1)%如果AFT_stack_sorted中存储方向为（node2_base, node_select）
            AFT_stack_sorted(row, 3) = nCells_AFT;%则更新到左单元
        elseif(direction == -1)
            AFT_stack_sorted(row, 4) = nCells_AFT;%否则更新到右单元
        end
    else  %如果不存在，则按反的逻辑新增阵面，即阵面方向反过来（node1_base, node_select），nCells_AFT更新到右单元，左单元不更新           
        AFT_stack_sorted(end+1,:) = [node4, node3, -1, nCells_AFT, dist34,  size(AFT_stack_sorted,1)+1, 2];  
    end
else %如果为右单元
    if( row ~= -1 ) %如果已经存在
        if(direction == 1) %如果AFT_stack_sorted中存储方向为（node2_base, node_select）
            AFT_stack_sorted(row, 4) = nCells_AFT;  %更新到右单元
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT;  %否则更新到左单元
        end
    else  %如果不存在，则按反的逻辑新增阵面，即阵面方向反过来（node_select, node2_base），nCells_AFT更新到左单元，右单元不更新
        AFT_stack_sorted(end+1,:) = [node4, node3, nCells_AFT, -1, dist34,  size(AFT_stack_sorted,1)+1, 2];              
    end
end

flag41 = IsLeftCell(node4, node1, node2, xCoord_AFT, yCoord_AFT);
flag42 = IsLeftCell(node4, node1, node3, xCoord_AFT, yCoord_AFT);
[direction, row] = FrontExist(node4, node1, AFT_stack_sorted); 
if( flag41 == 1 && flag42 == 1 ) %如果为左单元
    if( row ~= -1 )%如果已经存在
        if(direction == 1)%如果AFT_stack_sorted中存储方向为（node2_base, node_select）
            AFT_stack_sorted(row, 3) = nCells_AFT;%则更新到左单元
        elseif(direction == -1)
            AFT_stack_sorted(row, 4) = nCells_AFT;%否则更新到右单元
        end
    else  %如果不存在，则按反的逻辑新增阵面，即阵面方向反过来（node1_base, node_select），nCells_AFT更新到右单元，左单元不更新           
        AFT_stack_sorted(end+1,:) = [node1, node4, -1, nCells_AFT, dist14,  size(AFT_stack_sorted,1)+1, 2];  
    end
else %如果为右单元
    if( row ~= -1 ) %如果已经存在
        if(direction == 1) %如果AFT_stack_sorted中存储方向为（node2_base, node_select）
            AFT_stack_sorted(row, 4) = nCells_AFT;  %更新到右单元
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT;  %否则更新到左单元
        end
    else  %如果不存在，则按反的逻辑新增阵面，即阵面方向反过来（node_select, node2_base），nCells_AFT更新到左单元，右单元不更新
        AFT_stack_sorted(end+1,:) = [node1, node4, nCells_AFT, -1, dist14,  size(AFT_stack_sorted,1)+1, 2];              
    end
end