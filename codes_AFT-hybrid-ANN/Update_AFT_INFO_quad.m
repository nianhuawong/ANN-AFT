function AFT_stack_sorted = Update_AFT_INFO_quad(AFT_stack_sorted, node1_base, node2_base, node_select, nCells_AFT , xCoord_AFT, yCoord_AFT)

flagConvexPoly = IsConvexPloygon(node1_base, node2_base, node_select(2), node_select(1), xCoord_AFT, yCoord_AFT);
if flagConvexPoly == 0 
    return;
end

%%
dist11 = DISTANCE(node1_base, node_select(1), xCoord_AFT, yCoord_AFT);
dist12 = DISTANCE(node_select(1), node_select(2), xCoord_AFT, yCoord_AFT);
dist22 = DISTANCE(node2_base, node_select(2), xCoord_AFT, yCoord_AFT);
%%
%���ڻ�׼���棬���������߼����£���Ԫ=>��Ԫ���ҵ�Ԫ=>�ҵ�Ԫ
flag11 = IsLeftCell(node1_base, node2_base, node_select(1), xCoord_AFT, yCoord_AFT);  
flag12 = IsLeftCell(node1_base, node2_base, node_select(2), xCoord_AFT, yCoord_AFT);  
if( flag11 == 1 && flag12 == 1 )
    AFT_stack_sorted(1,3) = nCells_AFT;
else
    AFT_stack_sorted(1,4) = nCells_AFT;
end

%%
%���ڷǻ�׼���棬��2����������Ѵ��ڵ����水�������߼����£���������������棬���շ����߼�������
flag21 = IsLeftCell(node2_base, node_select(2), node_select(1), xCoord_AFT, yCoord_AFT);  %�ж�������Ԫ�Ƿ�Ϊ��node_select��node1_base����Ԫ
flag22 = IsLeftCell(node2_base, node_select(2), node1_base,  xCoord_AFT, yCoord_AFT);
[direction, row] = FrontExist(node2_base, node_select(2), AFT_stack_sorted);  %�ж����棨node_select��node1_base���Ƿ��Ѿ����ڼ�����AFT_stack_sorted�еķ���
if( flag21 == 1 && flag22 == 1)  %���Ϊ��Ԫ
    if( row ~= -1 )   %����Ѿ�����
        if(direction == 1) %���AFT_stack_sorted�д洢����Ϊ��node_select��node1_base��
            AFT_stack_sorted(row, 3) = nCells_AFT;  %����µ���Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 4) = nCells_AFT;  %������µ��ҵ�Ԫ
        end
    else    %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node1_base, node_select����nCells_AFT���µ��ҵ�Ԫ����Ԫ������
        AFT_stack_sorted(end+1,:) = [node_select(2), node2_base, -1, nCells_AFT, dist22,  size(AFT_stack_sorted,1)+1, 2];  
    end
else   %���Ϊ�ҵ�Ԫ
    if( row ~= -1 )  %����Ѿ�����
        if(direction == 1)  %���AFT_stack_sorted�д洢����Ϊ��node_select��node1_base��
            AFT_stack_sorted(row, 4) = nCells_AFT; %���µ��ҵ�Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT; %������µ���Ԫ
        end
    else  %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node1_base, node_select����nCells_AFT���µ���Ԫ���ҵ�Ԫ������
        AFT_stack_sorted(end+1,:) = [node_select(2), node2_base, nCells_AFT, -1, dist22,  size(AFT_stack_sorted,1)+1, 2];  
    end
end 

flag31 = IsLeftCell(node_select(2), node_select(1), node1_base, xCoord_AFT, yCoord_AFT);
flag32 = IsLeftCell(node_select(2), node_select(1), node2_base, xCoord_AFT, yCoord_AFT);
[direction, row] = FrontExist(node_select(2), node_select(1), AFT_stack_sorted); 
if( flag31 == 1 && flag32 == 1 ) %���Ϊ��Ԫ
    if( row ~= -1 )%����Ѿ�����
        if(direction == 1)%���AFT_stack_sorted�д洢����Ϊ��node2_base, node_select��
            AFT_stack_sorted(row, 3) = nCells_AFT;%����µ���Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 4) = nCells_AFT;%������µ��ҵ�Ԫ
        end
    else  %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node1_base, node_select����nCells_AFT���µ��ҵ�Ԫ����Ԫ������           
        AFT_stack_sorted(end+1,:) = [node_select(1), node_select(2), -1, nCells_AFT, dist12,  size(AFT_stack_sorted,1)+1, 2];  
    end
else %���Ϊ�ҵ�Ԫ
    if( row ~= -1 ) %����Ѿ�����
        if(direction == 1) %���AFT_stack_sorted�д洢����Ϊ��node2_base, node_select��
            AFT_stack_sorted(row, 4) = nCells_AFT;  %���µ��ҵ�Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT;  %������µ���Ԫ
        end
    else  %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node_select, node2_base����nCells_AFT���µ���Ԫ���ҵ�Ԫ������
        AFT_stack_sorted(end+1,:) = [node_select(1), node_select(2), nCells_AFT, -1, dist12,  size(AFT_stack_sorted,1)+1, 2];              
    end
end

flag41 = IsLeftCell(node_select(1), node1_base, node2_base, xCoord_AFT, yCoord_AFT);
flag42 = IsLeftCell(node_select(1), node1_base, node_select(2), xCoord_AFT, yCoord_AFT);
[direction, row] = FrontExist(node_select(1), node1_base, AFT_stack_sorted); 
if( flag41 == 1 && flag42 == 1 ) %���Ϊ��Ԫ
    if( row ~= -1 )%����Ѿ�����
        if(direction == 1)%���AFT_stack_sorted�д洢����Ϊ��node2_base, node_select��
            AFT_stack_sorted(row, 3) = nCells_AFT;%����µ���Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 4) = nCells_AFT;%������µ��ҵ�Ԫ
        end
    else  %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node1_base, node_select����nCells_AFT���µ��ҵ�Ԫ����Ԫ������           
        AFT_stack_sorted(end+1,:) = [node1_base, node_select(1), -1, nCells_AFT, dist11,  size(AFT_stack_sorted,1)+1, 2];  
    end
else %���Ϊ�ҵ�Ԫ
    if( row ~= -1 ) %����Ѿ�����
        if(direction == 1) %���AFT_stack_sorted�д洢����Ϊ��node2_base, node_select��
            AFT_stack_sorted(row, 4) = nCells_AFT;  %���µ��ҵ�Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT;  %������µ���Ԫ
        end
    else  %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node_select, node2_base����nCells_AFT���µ���Ԫ���ҵ�Ԫ������
        AFT_stack_sorted(end+1,:) = [node1_base, node_select(1), nCells_AFT, -1, dist11,  size(AFT_stack_sorted,1)+1, 2];              
    end
end
