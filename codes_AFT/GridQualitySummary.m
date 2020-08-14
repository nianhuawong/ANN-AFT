function GridQualitySummary(Grid_stack, xCoord, yCoord, cellNodeTopo)
nFaces = size(Grid_stack,1);

targetPoint = TargetPointOfFrontTri(Grid_stack);
areaRatio = zeros(1,nFaces);
qualityRatio = zeros(1,nFaces);
for i = 1:nFaces
    node1 = Grid_stack(i,1);
    node2 = Grid_stack(i,2);
    node3 = targetPoint(i);

    leftCell = Grid_stack(i,3);
    rightCell = Grid_stack(i,4);
    
    node4 = cellNodeTopo(leftCell,1);
    node5 = cellNodeTopo(leftCell,2);
    node6 = cellNodeTopo(leftCell,3);
    if rightCell == 0
        areaRatio(i) = -1;
        qualityRatio(i) = -1;
    else
        node7 = cellNodeTopo(rightCell,1);
        node8 = cellNodeTopo(rightCell,2);
        node9 = cellNodeTopo(rightCell,3);
        
        areaL = AreaTriangleIndex(node4, node5, node6, xCoord, yCoord);
        areaR = AreaTriangleIndex(node7, node8, node9, xCoord, yCoord);
        areaRatio(i) = min([areaL,areaR]) / max([areaL,areaR]);
        
        [qualityL,~] = QualityCheckTri(node4, node5, node6, xCoord, yCoord, -1);
        [qualityR,~] = QualityCheckTri(node7, node8, node9, xCoord, yCoord, -1);
        qualityRatio(i) = min([qualityL,qualityR]) / max([qualityL,qualityR]);
    end
end
II = areaRatio==-1;
areaRatio( II ) = 100000;
[minAreaRatio, pos1] = min(areaRatio);
Edge = Grid_stack(pos1,1:2);
plot(xCoord(Edge),yCoord(Edge),'g-*');
areaRatio( II ) = [];

maxAreaRatio = max(areaRatio);
averAreaRatio = mean(areaRatio);
%%
II = qualityRatio==-1;
qualityRatio( II ) = 100000;
[minQualityRatio, pos2] = min(qualityRatio);
Edge = Grid_stack(pos2,1:2);
plot(xCoord(Edge),yCoord(Edge),'m-o');
hold off;

qualityRatio( II ) = [];
maxQualityRatio = max(qualityRatio);
averQualityRatio = mean(qualityRatio);

disp(['maxAreaRatio  = ', num2str(maxAreaRatio)]);
disp(['minAreaRatio  = ', num2str(minAreaRatio)]);
disp(['averAreaRatio = ',  num2str(averAreaRatio)]);
disp(['****************************************']);
disp(['maxQualityRatio  = ', num2str(maxQualityRatio)]);
disp(['minQualityRatio  = ', num2str(minQualityRatio)]);
disp(['averQualityRatio = ',  num2str(averQualityRatio)]);
end

function area = AreaTriangleIndex(nodeIn1, nodeIn2, nodeIn3, xCoord, yCoord)
node1 = [xCoord(nodeIn1), yCoord(nodeIn1)];
node2 = [xCoord(nodeIn2), yCoord(nodeIn2)];
node3 = [xCoord(nodeIn3), yCoord(nodeIn3)];

area = AreaTriangle(node1, node2, node3);
end