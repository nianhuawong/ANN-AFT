function targetPoint = TargetPointOfFrontTri(Grid_stack)
nFaces = size(Grid_stack, 1);
node1 = Grid_stack(:,1);
node2 = Grid_stack(:,2);
leftCell = Grid_stack(:,3);
rightCell = Grid_stack(:,4);

targetPoint  = zeros(nFaces,1);
for i = 1:nFaces                %����ĳ����׼����
    leftCellIndex = leftCell(i);
    %Ѱ��leftCell������1����
    for ii = 1:nFaces      %Ѱ��һ���棬����Ԫ�����ҵ�Ԫ���׼�����Ԫ��ͬ
        if leftCell(ii) == leftCellIndex || rightCell(ii) == leftCellIndex   %�ҵ�����
            node1OfFace = node1(ii);        %�����������
            node2OfFace = node2(ii);
            if node1OfFace ~= node1(i) && node1OfFace ~= node2(i)%���������ĳ���ڵ㲻Ϊ��׼��ĵ㣬��õ��ΪĿ���
                targetPoint(i) = node1OfFace;
            end
            if node2OfFace ~= node1(i) && node2OfFace ~= node2(i)
                targetPoint(i) = node2OfFace;
            end                      
        end
    end
end

end