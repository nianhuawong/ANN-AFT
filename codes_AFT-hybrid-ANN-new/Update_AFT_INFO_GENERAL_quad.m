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
flag11 = IsLeftCell(node1, node2, node3, xCoord_AFT, yCoord_AFT);  %�ж�������Ԫ�Ƿ�Ϊ��Ԫ
flag12 = IsLeftCell(node1, node2, node4, xCoord_AFT, yCoord_AFT);
[direction, row] = FrontExist(node1, node2, AFT_stack_sorted);  %�ж������Ƿ��Ѿ����ڼ�����AFT_stack_sorted�еķ���
if( flag11 == 1 && flag12 == 1)  %���Ϊ��Ԫ
    if( row ~= -1 )   %����Ѿ�����
        if(direction == 1) %���AFT_stack_sorted�д洢����Ϊ��node_select��node1_base��
            AFT_stack_sorted(row, 3) = nCells_AFT;  %����µ���Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 4) = nCells_AFT;  %������µ��ҵ�Ԫ
        end
    else    %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node1_base, node_select����nCells_AFT���µ��ҵ�Ԫ����Ԫ������
        AFT_stack_sorted(end+1,:) = [node2, node1, -1, nCells_AFT, dist12,  size(AFT_stack_sorted,1)+1, 2];  
    end
else   %���Ϊ�ҵ�Ԫ
    if( row ~= -1 )  %����Ѿ�����
        if(direction == 1)  %���AFT_stack_sorted�д洢����Ϊ��node_select��node1_base��
            AFT_stack_sorted(row, 4) = nCells_AFT; %���µ��ҵ�Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT; %������µ���Ԫ
        end
    else  %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node1_base, node_select����nCells_AFT���µ���Ԫ���ҵ�Ԫ������
        AFT_stack_sorted(end+1,:) = [node2, node1, nCells_AFT, -1, dist12,  size(AFT_stack_sorted,1)+1, 2];  
    end
end 

%%
%���ڷǻ�׼���棬��2����������Ѵ��ڵ����水�������߼����£���������������棬���շ����߼�������
flag21 = IsLeftCell(node2, node3, node4, xCoord_AFT, yCoord_AFT);  %�ж�������Ԫ�Ƿ�Ϊ��node_select��node1_base����Ԫ
flag22 = IsLeftCell(node2, node3, node1, xCoord_AFT, yCoord_AFT);
[direction, row] = FrontExist(node2, node3, AFT_stack_sorted);  %�ж����棨node_select��node1_base���Ƿ��Ѿ����ڼ�����AFT_stack_sorted�еķ���
if( flag21 == 1 && flag22 == 1)  %���Ϊ��Ԫ
    if( row ~= -1 )   %����Ѿ�����
        if(direction == 1) %���AFT_stack_sorted�д洢����Ϊ��node_select��node1_base��
            AFT_stack_sorted(row, 3) = nCells_AFT;  %����µ���Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 4) = nCells_AFT;  %������µ��ҵ�Ԫ
        end
    else    %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node1_base, node_select����nCells_AFT���µ��ҵ�Ԫ����Ԫ������
        AFT_stack_sorted(end+1,:) = [node3, node2, -1, nCells_AFT, dist23,  size(AFT_stack_sorted,1)+1, 2];  
    end
else   %���Ϊ�ҵ�Ԫ
    if( row ~= -1 )  %����Ѿ�����
        if(direction == 1)  %���AFT_stack_sorted�д洢����Ϊ��node_select��node1_base��
            AFT_stack_sorted(row, 4) = nCells_AFT; %���µ��ҵ�Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT; %������µ���Ԫ
        end
    else  %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node1_base, node_select����nCells_AFT���µ���Ԫ���ҵ�Ԫ������
        AFT_stack_sorted(end+1,:) = [node3, node2, nCells_AFT, -1, dist23,  size(AFT_stack_sorted,1)+1, 2];  
    end
end 

flag31 = IsLeftCell(node3, node4, node1, xCoord_AFT, yCoord_AFT);
flag32 = IsLeftCell(node3, node4, node2, xCoord_AFT, yCoord_AFT);
[direction, row] = FrontExist(node3, node4, AFT_stack_sorted); 
if( flag31 == 1 && flag32 == 1 ) %���Ϊ��Ԫ
    if( row ~= -1 )%����Ѿ�����
        if(direction == 1)%���AFT_stack_sorted�д洢����Ϊ��node2_base, node_select��
            AFT_stack_sorted(row, 3) = nCells_AFT;%����µ���Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 4) = nCells_AFT;%������µ��ҵ�Ԫ
        end
    else  %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node1_base, node_select����nCells_AFT���µ��ҵ�Ԫ����Ԫ������           
        AFT_stack_sorted(end+1,:) = [node4, node3, -1, nCells_AFT, dist34,  size(AFT_stack_sorted,1)+1, 2];  
    end
else %���Ϊ�ҵ�Ԫ
    if( row ~= -1 ) %����Ѿ�����
        if(direction == 1) %���AFT_stack_sorted�д洢����Ϊ��node2_base, node_select��
            AFT_stack_sorted(row, 4) = nCells_AFT;  %���µ��ҵ�Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT;  %������µ���Ԫ
        end
    else  %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node_select, node2_base����nCells_AFT���µ���Ԫ���ҵ�Ԫ������
        AFT_stack_sorted(end+1,:) = [node4, node3, nCells_AFT, -1, dist34,  size(AFT_stack_sorted,1)+1, 2];              
    end
end

flag41 = IsLeftCell(node4, node1, node2, xCoord_AFT, yCoord_AFT);
flag42 = IsLeftCell(node4, node1, node3, xCoord_AFT, yCoord_AFT);
[direction, row] = FrontExist(node4, node1, AFT_stack_sorted); 
if( flag41 == 1 && flag42 == 1 ) %���Ϊ��Ԫ
    if( row ~= -1 )%����Ѿ�����
        if(direction == 1)%���AFT_stack_sorted�д洢����Ϊ��node2_base, node_select��
            AFT_stack_sorted(row, 3) = nCells_AFT;%����µ���Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 4) = nCells_AFT;%������µ��ҵ�Ԫ
        end
    else  %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node1_base, node_select����nCells_AFT���µ��ҵ�Ԫ����Ԫ������           
        AFT_stack_sorted(end+1,:) = [node1, node4, -1, nCells_AFT, dist14,  size(AFT_stack_sorted,1)+1, 2];  
    end
else %���Ϊ�ҵ�Ԫ
    if( row ~= -1 ) %����Ѿ�����
        if(direction == 1) %���AFT_stack_sorted�д洢����Ϊ��node2_base, node_select��
            AFT_stack_sorted(row, 4) = nCells_AFT;  %���µ��ҵ�Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT;  %������µ���Ԫ
        end
    else  %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node_select, node2_base����nCells_AFT���µ���Ԫ���ҵ�Ԫ������
        AFT_stack_sorted(end+1,:) = [node1, node4, nCells_AFT, -1, dist14,  size(AFT_stack_sorted,1)+1, 2];              
    end
end