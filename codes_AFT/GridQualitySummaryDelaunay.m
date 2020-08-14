function GridQualitySummaryDelaunay(triMesh, wallNodes, xCoord, yCoord)
if nargin == 2
    xCoord = triMesh.Points(:,1);
    yCoord = triMesh.Points(:,2);
end

Edge = edges(triMesh);
nEdges = size(Edge,1);
areaRatio = zeros(1,nEdges);
qualityRatio = zeros(1,nEdges);
for i=1:nEdges
    ti = edgeAttachments(triMesh,Edge(i,:));
    node1 = Edge(i,1);
    node2 = Edge(i,2);
    
    if size(ti{1},2) == 1
        areaRatio(i) = -1;
        qualityRatio(i) = -1;
    elseif size(ti{1},2) == 2
        node3 = triMesh.ConnectivityList(ti{1}(1),:);
        node3( node3 == node1 ) = [];
        node3( node3 == node2 ) = [];
        
        node4 = triMesh.ConnectivityList(ti{1}(2),:);
        node4( node4 == node1 ) = [];
        node4( node4 == node2 ) = [];
        
        if i == 402 || i == 338
            kkk = 1;
        end
        
        if sum(wallNodes == node1) ~= 0 && ...
            sum(wallNodes == node2) ~= 0 && ...
            ( sum(wallNodes == node3) ~= 0 || sum(wallNodes == node4) ~= 0 )
            areaRatio(i) = -1;
            qualityRatio(i) = -1;
        else
            areaL = AreaTriangleIndex(node1, node2, node3, xCoord, yCoord);
            areaR = AreaTriangleIndex(node1, node2, node4, xCoord, yCoord);
            areaRatio(i) = min([areaL,areaR]) / max([areaL,areaR]);
            if abs( areaL ) < 1e-15 || isnan(areaL) || abs( areaR ) < 1e-15 || isnan(areaR)
                areaRatio(i) = -1;
            end
            
            [qualityL,~] = QualityCheckTri(node1, node2, node3, xCoord, yCoord, -1);
            [qualityR,~] = QualityCheckTri(node1, node2, node4, xCoord, yCoord, -1);
            qualityRatio(i) = min([qualityL,qualityR]) / max([qualityL,qualityR]);
            if abs( qualityL ) < 1e-15 || isnan(qualityL) || abs( qualityR ) < 1e-15 || isnan(qualityR)
                qualityRatio(i) = -1;
            end
        end
    end
end
II = areaRatio==-1;
areaRatio( II ) = 100000;
[minAreaRatio, pos1] = min(areaRatio);
plot(xCoord(Edge(pos1,:)),yCoord(Edge(pos1,:)),'g-*');
areaRatio( II ) = [];

maxAreaRatio = max(areaRatio);
averAreaRatio = mean(areaRatio);
%%
II = qualityRatio==-1;
qualityRatio( II ) = 100000;
[minQualityRatio, pos2] = min(qualityRatio);
plot(xCoord(Edge(pos2,:)),yCoord(Edge(pos2,:)),'m-o');
hold off;

qualityRatio( II ) = [];
maxQualityRatio = max(qualityRatio);
averQualityRatio = mean(qualityRatio);
disp(['****************************************']);
disp(['*************网格质量检测结果************']);
disp(['maxAreaRatio  = ', num2str(maxAreaRatio)]);
disp(['minAreaRatio  = ', num2str(minAreaRatio)]);
disp(['averAreaRatio = ',  num2str(averAreaRatio)]);
disp(['***********************']);
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