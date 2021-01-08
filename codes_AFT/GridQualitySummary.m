function GridQualitySummary(cellNodeTopology, xCoord, yCoord, Grid_stack)
if nargin == 3
    Grid_stack = ConstructGridStack(cellNodeTopology,xCoord, yCoord);
end

if isempty(cellNodeTopology)
    cellNodeTopology = ConstructGridTopo(Grid_stack);
    PLOT(Grid_stack, xCoord, yCoord);
end

nFaces = size(Grid_stack,1);
nCells = size(cellNodeTopology,1);

areaRatio = zeros(1,nFaces);
qualityRatio = zeros(1,nFaces);
quality = zeros(1,nCells);
for i = 1:nFaces
    if i == 2926
        kkk = 1;
    end
    leftCell = Grid_stack(i,3);
    rightCell = Grid_stack(i,4);
    
    node5 = cellNodeTopology(leftCell,1);
    node6 = cellNodeTopology(leftCell,2);
    node7 = cellNodeTopology(leftCell,3);
    node8 = cellNodeTopology(leftCell,4);
    
    qualityL = QualityCheckQuad_new(node5, node6, node7, node8, xCoord, yCoord);
       
    if rightCell <= 0
        areaRatio(i)      = -1;
        qualityRatio(i)   = -1;
        quality(leftCell) = qualityL;
    else
        node9 = cellNodeTopology(rightCell,1);
        node10 = cellNodeTopology(rightCell,2);
        node11 = cellNodeTopology(rightCell,3);
        node12 = cellNodeTopology(rightCell,4);
        
        areaL = AreaQuadangleIndex(node5, node6, node7, node8, xCoord, yCoord);
        areaR = AreaQuadangleIndex(node9, node10, node11, node12, xCoord, yCoord);
        areaRatio(i) = min([areaL,areaR]) / max([areaL,areaR]);

        qualityR = QualityCheckQuad_new(node9, node10, node11, node12, xCoord, yCoord);    
        quality(leftCell) = qualityL;
        quality(rightCell) = qualityR;
        qualityRatio(i) = min([qualityL,qualityR]) / max([qualityL,qualityR]);
    end
end
%%
II = areaRatio==-1;
areaRatio( II ) = 100000;
[minAreaRatio, pos1] = min(areaRatio);

Edge = Grid_stack(pos1,1:2);
% plot(xCoord(Edge),yCoord(Edge),'r-*');

areaRatio( II ) = [];
maxAreaRatio = max(areaRatio);
averAreaRatio = mean(areaRatio);
%%
II = qualityRatio==-1;
qualityRatio( II ) = 100000;
[minQualityRatio, pos2] = min(qualityRatio);

Edge = Grid_stack(pos2,1:2);
% plot(xCoord(Edge),yCoord(Edge),'g-o');

qualityRatio( II ) = [];
maxQualityRatio = max(qualityRatio);
averQualityRatio = mean(qualityRatio);
%%
[minQuality, pos3] = min(quality);

badCell = cellNodeTopology(pos3,:);
badCell(badCell<=0)=[];
% plot(xCoord(badCell),yCoord(badCell),'k+');
% plot(mean(xCoord(badCell)),mean(yCoord(badCell)),'k+');
hold off;
maxQuality = max(quality);
averQuality = mean(quality);

disp(['===============  网格质量统计  ===============']);
disp(['maxAreaRatio  = ', num2str(maxAreaRatio)]);
disp(['minAreaRatio  = ', num2str(minAreaRatio)]);
disp(['averAreaRatio = ', num2str(averAreaRatio)]);
% disp(['*****************************************************']);
% disp(['maxQualityRatio  = ', num2str(maxQualityRatio)]);
% disp(['minQualityRatio  = ', num2str(minQualityRatio)]);
% disp(['averQualityRatio = ', num2str(averQualityRatio)]);
disp(['*****************************************************']);
disp(['maxQuality       = ', num2str(maxQuality)]);
disp(['minQuality       = ', num2str(minQuality)]);
disp(['averQuality      = ', num2str(averQuality)]);
end

% function area = AreaTriangleIndex(nodeIn1, nodeIn2, nodeIn3, xCoord, yCoord)
% node1 = [xCoord(nodeIn1), yCoord(nodeIn1)];
% node2 = [xCoord(nodeIn2), yCoord(nodeIn2)];
% node3 = [xCoord(nodeIn3), yCoord(nodeIn3)];
% 
% area = AreaTriangle(node1, node2, node3);
% end

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

function Grid_stack = ConstructGridStack(cellNodeTopo, xCoord, yCoord)
Grid_stack = [];
nCells = size(cellNodeTopo,1);
for i=1:nCells
    cellNodes = cellNodeTopo(i,:);
    node1 = cellNodes(1);
    node2 = cellNodes(2);
    node3 = cellNodes(3);
    if length(cellNodes) == 4
        node4 = cellNodes(4);
        if node4 < 0
            Grid_stack = Update_AFT_INFO_GENERAL_TRI_new(Grid_stack, node1, node2, node3, i, xCoord, yCoord);
        elseif node4 > 0
            [Grid_stack, ~] = Update_AFT_INFO_GENERAL_quad_new(Grid_stack, node1, node2, node3, node4, i, xCoord, yCoord);
        end
    end
end
tmp = Grid_stack(:,3);
Grid_stack(:,3) = Grid_stack(:,4);
Grid_stack(:,4) = tmp;
end
