function GridQualitySummaryDelaunay(triMesh, invalidCellIndex, xCoord, yCoord)
if nargin == 2
    xCoord = triMesh.Points(:,1);
    yCoord = triMesh.Points(:,2);
end

Edge = edges(triMesh);
nEdges = size(Edge,1);
areaRatio = zeros(1,nEdges);
qualityRatio = zeros(1,nEdges);

nCells = size(triMesh.ConnectivityList,1);
quality = zeros(1,nCells);
for i=1:nEdges
    ti = edgeAttachments(triMesh,Edge(i,:));  %edge对应的单元
    node1 = Edge(i,1);
    node2 = Edge(i,2);
    
    if node1 == 37 && node2 == 38
        kkk = 1;
    end
    
    node3 = triMesh.ConnectivityList(ti{1}(1),:);%ti{1}(1)为第一个单元编号，node3为第一个单元的几个点
    node3( node3 == node1 ) = [];%去掉已有的node1和node2
    node3( node3 == node2 ) = [];
    areaL = AreaTriangleIndex(node1, node2, node3, xCoord, yCoord);
    [qualityL,~] = QualityCheckTri(node1, node2, node3, xCoord, yCoord, -1);
     
    if size(ti{1},2) == 1
        areaRatio   (i)   = -1;
        qualityRatio(i)   = -1;
        quality(ti{1}(1)) = qualityL;
    elseif size(ti{1},2) == 2 
        node4 = triMesh.ConnectivityList(ti{1}(2),:);
        node4( node4 == node1 ) = [];
        node4( node4 == node2 ) = [];
        areaR = AreaTriangleIndex(node1, node2, node4, xCoord, yCoord);
        [qualityR,~] = QualityCheckTri(node1, node2, node4, xCoord, yCoord, -1);
        
        quality(ti{1}(1))   = qualityL;
        quality(ti{1}(2))   = qualityR;
        if sum( ti{1}(1) == invalidCellIndex ) ~= 0 || sum( ti{1}(2) == invalidCellIndex ) ~= 0
            areaRatio(i)    = -1;
            qualityRatio(i) = -1;
        else
            areaRatio(i) = min([areaL,areaR]) / max([areaL,areaR]);
            if abs( areaL ) < 1e-15 || isnan(areaL) || abs( areaR ) < 1e-15 || isnan(areaR)
                areaRatio(i) = -1;
            end
            
            qualityRatio(i) = min([qualityL,qualityR]) / max([qualityL,qualityR]);
            if abs( qualityL ) < 1e-15 || isnan(qualityL) || abs( qualityR ) < 1e-15 || isnan(qualityR)
                qualityRatio(i)   = -1;
            end
        end        
    end
end
%%
II = areaRatio==-1;
areaRatio( II ) = 100000;
[minAreaRatio, pos1] = min(areaRatio);
hold on;
plot(xCoord(Edge(pos1,:)),yCoord(Edge(pos1,:)),'r-*');
areaRatio( II ) = [];

maxAreaRatio = max(areaRatio);
averAreaRatio = mean(areaRatio);

%%
II = qualityRatio==-1;
qualityRatio( II ) = 100000;
[minQualityRatio, pos2] = min(qualityRatio);
plot(xCoord(Edge(pos2,:)),yCoord(Edge(pos2,:)),'g-o');

qualityRatio( II ) = [];
maxQualityRatio = max(qualityRatio);
averQualityRatio = mean(qualityRatio);

%%
quality( invalidCellIndex ) = 100000;
[minQuality, pos3] = min(quality);
badCell = triMesh.ConnectivityList(pos3,:);
plot(xCoord(badCell),yCoord(badCell),'k-+');
plot(mean(xCoord(badCell)),mean(yCoord(badCell)),'k+');
hold off;
quality( invalidCellIndex ) = [];
maxQuality = max(quality);
averQuality = mean(quality);

disp(['===============  Delaunay网格质量统计  ===============']);
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