function  [AFT_stack_sorted, nCells_AFT] = UpdateTriCells(AFT_stack_sorted, nCells_AFT, xCoord_AFT, yCoord_AFT, node_select, flag_best)
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
% if(node_select ~= node_best)
if flag_best == 0
    neighbor = [node1_base, node2_base];
    for i = 1: size(AFT_stack_sorted,1)
        if( AFT_stack_sorted(i,1)== node_select)
            neighbor(end+1) = AFT_stack_sorted(i,2);
        end
        if( AFT_stack_sorted(i,2) == node_select)
            neighbor(end+1) = AFT_stack_sorted(i,1);
        end
    end
    neighbor = unique(neighbor);
    
    %         �ڵ��������л������ڵģ����γ��µ�Ԫ
    new_cell = [];
    for i = 1:length(neighbor)
        neighborNode = neighbor(i);
        for j = 1: size(AFT_stack_sorted,1)
            if( AFT_stack_sorted(j,1) == neighborNode ) %�ڵ���������
                if( find(neighbor==AFT_stack_sorted(j,2)) )  %�ڵ���ڵ����
                    new_cell(end+1,:) = [node_select, neighborNode, AFT_stack_sorted(j,2)];
                end
            end
            if(AFT_stack_sorted(j,2) == neighborNode)
                if( find(neighbor==AFT_stack_sorted(j,1)) )
                    new_cell(end+1,:) = [node_select, neighborNode, AFT_stack_sorted(j,1)];
                end
            end
        end
    end
    
    %ȥ���ظ��ĵ�Ԫ
    for i = 1 : size(new_cell,1)
        iCell = new_cell(i,:);
        for j = i+1:size(new_cell,1)
            jCell = new_cell(j,:);
            if( sum(jCell([3,2]) == iCell([2,3])) == 2)
                new_cell(j,:)=-1;
            end
        end
    end
    
    II = find(new_cell(:,1) == -1);
    new_cell(II,:)=[];
    
    %��Ҫȥ���Ѿ��еĵ�Ԫ
    for i = 1 : size(new_cell,1)
        iCell = new_cell(i,:);
        if(size(find(iCell==node1_base),2) && size(find(iCell==node2_base),2) && size(find(iCell==node_select),2))
            new_cell(i,:)=-1;
        end
    end
    
    II = find(new_cell(:,1) == -1);
    new_cell(II,:)=[];
    
    %���µ�Ԫ�������ݽṹ
    for i = 1:size(new_cell,1)
        nCells_AFT = nCells_AFT + 1;
        node1 = new_cell(i,1);
        node2 = new_cell(i,2);
        node3 = new_cell(i,3);
        
        AFT_stack_sorted = Update_AFT_INFO_GENERAL_TRI(AFT_stack_sorted, ...
            node1, node2, node3, nCells_AFT , xCoord_AFT, yCoord_AFT);
    end
end

end