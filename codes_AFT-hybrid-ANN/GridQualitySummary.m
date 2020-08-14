function GridQualitySummary(Grid_stack, xCoord, yCoord, cellNodeTopo)
nFaces = size(Grid_stack,1);

targetPoint = TargetPointOfFrontQuad(Grid_stack);
areaRatio = zeros(1,nFaces);
qualityRatio = zeros(1,nFaces);
for i = 1:nFaces
    if i == 1854 || i == 1915
        kkk = 1;
    end
    node1 = Grid_stack(i,1);
    node2 = Grid_stack(i,2);
    node3 = targetPoint(i,2);
    node4 = targetPoint(i,1);

    leftCell = Grid_stack(i,3);
    rightCell = Grid_stack(i,4);
    
    node5 = cellNodeTopo(leftCell,1);
    node6 = cellNodeTopo(leftCell,2);
    node7 = cellNodeTopo(leftCell,3);
    node8 = cellNodeTopo(leftCell,4);
    if rightCell == 0
        areaRatio(i) = -1;
        qualityRatio(i) = -1;
    else
        node9 = cellNodeTopo(rightCell,1);
        node10 = cellNodeTopo(rightCell,2);
        node11 = cellNodeTopo(rightCell,3);
        node12 = cellNodeTopo(rightCell,4);
        
        areaL = AreaQuadangleIndex(node5, node6, node7, node8, xCoord, yCoord);
        areaR = AreaQuadangleIndex(node9, node10, node11, node12, xCoord, yCoord);
        areaRatio(i) = min([areaL,areaR]) / max([areaL,areaR]);

        qualityL = QualityCheckQuad_new(node5, node6, node7, node8, xCoord, yCoord);
        qualityR = QualityCheckQuad_new(node9, node10, node11, node12, xCoord, yCoord);
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

function area = AreaQuadangleIndex(nodeIn1, nodeIn2, nodeIn3, nodeIn4, xCoord, yCoord)
node1 = [xCoord(nodeIn1), yCoord(nodeIn1)];
node2 = [xCoord(nodeIn2), yCoord(nodeIn2)];
node3 = [xCoord(nodeIn3), yCoord(nodeIn3)];
if nodeIn4 > 0
    node4 = [xCoord(nodeIn4), yCoord(nodeIn4)];
    area = AreaQuadrangle(node1, node2, node3, node4);
else
    area = AreaTriangle(node1, node2, node3);    
end
end