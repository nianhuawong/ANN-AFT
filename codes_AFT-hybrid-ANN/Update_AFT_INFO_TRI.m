function AFT_stack_sorted = Update_AFT_INFO_TRI(AFT_stack_sorted, node1_base, node2_base, node_select, nCells_AFT , xCoord_AFT, yCoord_AFT)
global cellNodeTopo nCells_tri;
cellNodeTopo(end+1,:) = [node1_base, node2_base, node_select, 0];
nCells_tri = nCells_tri + 1;
%%
dist1 = DISTANCE(node1_base, node_select, xCoord_AFT, yCoord_AFT);
dist2 = DISTANCE(node2_base, node_select, xCoord_AFT, yCoord_AFT);

%%
%���ڻ�׼���棬���������߼����£���Ԫ=>��Ԫ���ҵ�Ԫ=>�ҵ�Ԫ
flag1 = IsLeftCell(node1_base, node2_base, node_select, xCoord_AFT, yCoord_AFT);     
if( flag1 == 1 )
    AFT_stack_sorted(1,3) = nCells_AFT;
else
    AFT_stack_sorted(1,4) = nCells_AFT;
end

%%
%���ڷǻ�׼���棬��2����������Ѵ��ڵ����水�������߼����£���������������棬���շ����߼�������
flag2 = IsLeftCell(node_select, node1_base, node2_base, xCoord_AFT, yCoord_AFT);  %�ж�������Ԫ�Ƿ�Ϊ��node_select��node1_base����Ԫ
[row, direction] = FrontExist(node_select,node1_base, AFT_stack_sorted);  %�ж����棨node_select��node1_base���Ƿ��Ѿ����ڼ�����AFT_stack_sorted�еķ���
if( flag2 == 1 )  %���Ϊ��Ԫ
    if( row ~= -1 )   %����Ѿ�����
        if(direction == 1) %���AFT_stack_sorted�д洢����Ϊ��node_select��node1_base��
            AFT_stack_sorted(row, 3) = nCells_AFT;  %����µ���Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 4) = nCells_AFT;  %������µ��ҵ�Ԫ
        end
    else    %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node1_base, node_select����nCells_AFT���µ��ҵ�Ԫ����Ԫ������
        AFT_stack_sorted(end+1,:) = [node1_base, node_select, -1, nCells_AFT, dist1,  size(AFT_stack_sorted,1)+1,2];  
    end
else   %���Ϊ�ҵ�Ԫ
    if( row ~= -1 )  %����Ѿ�����
        if(direction == 1)  %���AFT_stack_sorted�д洢����Ϊ��node_select��node1_base��
            AFT_stack_sorted(row, 4) = nCells_AFT; %���µ��ҵ�Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT; %������µ���Ԫ
        end
    else  %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node1_base, node_select����nCells_AFT���µ���Ԫ���ҵ�Ԫ������
        AFT_stack_sorted(end+1,:) = [node1_base, node_select, nCells_AFT, -1, dist1,  size(AFT_stack_sorted,1)+1,2];  
    end
end 

flag3 = IsLeftCell(node2_base, node_select, node1_base, xCoord_AFT, yCoord_AFT);
[row, direction] = FrontExist(node2_base,node_select, AFT_stack_sorted); 
if( flag3 == 1 ) %���Ϊ��Ԫ
    if( row ~= -1 )%����Ѿ�����
        if(direction == 1)%���AFT_stack_sorted�д洢����Ϊ��node2_base, node_select��
            AFT_stack_sorted(row, 3) = nCells_AFT;%����µ���Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 4) = nCells_AFT;%������µ��ҵ�Ԫ
        end
    else  %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node1_base, node_select����nCells_AFT���µ��ҵ�Ԫ����Ԫ������           
        AFT_stack_sorted(end+1,:) = [node_select, node2_base, -1, nCells_AFT, dist2,  size(AFT_stack_sorted,1)+1,2];  
    end
else %���Ϊ�ҵ�Ԫ
    if( row ~= -1 ) %����Ѿ�����
        if(direction == 1) %���AFT_stack_sorted�д洢����Ϊ��node2_base, node_select��
            AFT_stack_sorted(row, 4) = nCells_AFT;  %���µ��ҵ�Ԫ
        elseif(direction == -1)
            AFT_stack_sorted(row, 3) = nCells_AFT;  %������µ���Ԫ
        end
    else  %��������ڣ��򰴷����߼��������棬�����淽�򷴹�����node_select, node2_base����nCells_AFT���µ���Ԫ���ҵ�Ԫ������
        AFT_stack_sorted(end+1,:) = [node_select, node2_base, nCells_AFT, -1, dist2,  size(AFT_stack_sorted,1)+1,2];              
    end
end      