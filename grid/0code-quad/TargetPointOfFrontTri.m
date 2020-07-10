function targetPoint = TargetPointOfFrontTri(Grid_stack)
nFaces = size(Grid_stack, 1);
node1 = Grid_stack(:,1);
node2 = Grid_stack(:,2);
leftCell = Grid_stack(:,3);
rightCell = Grid_stack(:,4);

targetPoint  = zeros(nFaces,1);
for i = 1:nFaces                %对于某个基准阵面
    leftCellIndex = leftCell(i);
    %寻找leftCell的另外1个点
    for ii = 1:nFaces      %寻找一个面，其左单元或者右单元与基准面的左单元相同
        if leftCell(ii) == leftCellIndex || rightCell(ii) == leftCellIndex   %找到该面
            node1OfFace = node1(ii);        %该面的两个点
            node2OfFace = node2(ii);
            if node1OfFace ~= node1(i) && node1OfFace ~= node2(i)%如果这个面的某个节点不为基准面的点，则该点就为目标点
                targetPoint(i) = node1OfFace;
            end
            if node2OfFace ~= node1(i) && node2OfFace ~= node2(i)
                targetPoint(i) = node2OfFace;
            end                      
        end
    end
end

end