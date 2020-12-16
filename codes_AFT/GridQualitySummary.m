function GridQualitySummary(cellNodeTopo, xCoord, yCoord, Grid_stack)
if nargin == 3
    Grid_stack = ConstructGridTopo(cellNodeTopo,xCoord, yCoord);
end

nFaces = size(Grid_stack,1);
nCells = size(cellNodeTopo,1);

areaRatio = zeros(1,nFaces);
qualityRatio = zeros(1,nFaces);
quality = zeros(1,nCells);
for i = 1:nFaces
    leftCell = Grid_stack(i,3);
    rightCell = Grid_stack(i,4);
    
    node4 = cellNodeTopo(leftCell,1);
    node5 = cellNodeTopo(leftCell,2);
    node6 = cellNodeTopo(leftCell,3);
    
    [qualityL,~] = QualityCheckTri(node4, node5, node6, xCoord, yCoord, -1);
       
    if rightCell <= 0
        areaRatio(i)      = -1;
        qualityRatio(i)   = -1;
        quality(leftCell) = qualityL;
    else
        node7 = cellNodeTopo(rightCell,1);
        node8 = cellNodeTopo(rightCell,2);
        node9 = cellNodeTopo(rightCell,3);
        
        areaL = AreaTriangleIndex(node4, node5, node6, xCoord, yCoord);
        areaR = AreaTriangleIndex(node7, node8, node9, xCoord, yCoord);
        areaRatio(i) = min([areaL,areaR]) / max([areaL,areaR]);
        
        [qualityR,~] = QualityCheckTri(node7, node8, node9, xCoord, yCoord, -1);
        quality(leftCell)  = qualityL;
        quality(rightCell) = qualityR;
        
        qualityRatio(i) = min([qualityL,qualityR]) / max([qualityL,qualityR]);
    end
end
%%
II = areaRatio==-1;
areaRatio( II ) = 100000;
[minAreaRatio, pos1] = min(areaRatio);

Edge = Grid_stack(pos1,1:2);
plot(xCoord(Edge),yCoord(Edge),'r-*');

areaRatio( II ) = [];
maxAreaRatio = max(areaRatio);
averAreaRatio = mean(areaRatio);
%%
II = qualityRatio==-1;
qualityRatio( II ) = 100000;
[minQualityRatio, pos2] = min(qualityRatio);

Edge = Grid_stack(pos2,1:2);
plot(xCoord(Edge),yCoord(Edge),'g-o');

qualityRatio( II ) = [];
maxQualityRatio = max(qualityRatio);
averQualityRatio = mean(qualityRatio);
%%
[minQuality, pos3] = min(quality);

badCell = cellNodeTopo(pos3,:);
badCell(badCell<=0)=[];
plot(xCoord(badCell),yCoord(badCell),'k-+');
plot(mean(xCoord(badCell)),mean(yCoord(badCell)),'k+');
hold off;
maxQuality = max(quality);
averQuality = mean(quality);

disp(['===============  网格质量统计  ===============']);
disp(['maxAreaRatio  = ', num2str(maxAreaRatio)]);
disp(['minAreaRatio  = ', num2str(minAreaRatio)]);
disp(['averAreaRatio = ', num2str(averAreaRatio)]);
disp(['*****************************************************']);
disp(['maxQualityRatio  = ', num2str(maxQualityRatio)]);
disp(['minQualityRatio  = ', num2str(minQualityRatio)]);
disp(['averQualityRatio = ', num2str(averQualityRatio)]);
disp(['*****************************************************']);
disp(['maxQuality       = ', num2str(maxQuality)]);
disp(['minQuality       = ', num2str(minQuality)]);
disp(['averQuality      = ', num2str(averQuality)]);
end

function area = AreaTriangleIndex(nodeIn1, nodeIn2, nodeIn3, xCoord, yCoord)
node1 = [xCoord(nodeIn1), yCoord(nodeIn1)];
node2 = [xCoord(nodeIn2), yCoord(nodeIn2)];
node3 = [xCoord(nodeIn3), yCoord(nodeIn3)];

area = AreaTriangle(node1, node2, node3);
end

function Grid_stack = ConstructGridTopo(cellNodeTopo, xCoord, yCoord)
Grid_stack = [];
nCells = size(cellNodeTopo,1);
for i=1:nCells
    cellNodes = cellNodeTopo(i,:);
    node1 = cellNodes(1);
    node2 = cellNodes(2);
    node3 = cellNodes(3);
    
    Grid_stack = Update_AFT_INFO_GENERAL_TRI(Grid_stack, node1, node2, node3, i, xCoord, yCoord);
end
tmp = Grid_stack(:,3);
Grid_stack(:,3) = Grid_stack(:,4);
Grid_stack(:,4) = tmp;
end