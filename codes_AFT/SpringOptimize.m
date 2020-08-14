function [xCoord,yCoord] = SpringOptimize(triMesh,wallNodes,times)
xCoord = triMesh.Points(:,1);
yCoord = triMesh.Points(:,2);

nNodes = length(xCoord);
ti = vertexAttachments(triMesh);
tri = triMesh.ConnectivityList;

for NN = 1:times
    for i = 1:nNodes
        if sum(wallNodes == i) ~= 0 
            continue;
        end
        attachedTri = ti(i,:);
        node_id = tri(attachedTri{:},:);
        node_id = unique(node_id(:),'stable');
        nn = length(node_id);
        xCoord_tmp = 0; yCoord_tmp = 0;
        for j =1:nn
            node = node_id(j);
            xCoord_tmp = xCoord(node) + xCoord_tmp;
            yCoord_tmp = yCoord(node) + yCoord_tmp;
        end
        xCoord(i) = xCoord_tmp / nn;
        yCoord(i) = yCoord_tmp / nn;
    end
end

for i = 1 : size(tri,1)
    node1 = tri(i,1);
    node2 = tri(i,2);
    node3 = tri(i,3);
    if sum( wallNodes == node1 )~= 0 && sum( wallNodes == node2 )~=0 && sum( wallNodes == node3 )~=0 && min([node1,node2,node3])>36
        tri(i,:) = -1;
    end
end
II = tri(:,1)==-1;
tri(II,:) = [];
figure;
triplot(tri,xCoord,yCoord);
axis equal;
axis off
hold on;
% axis([-0.7 0.7 -0.5 0.5])
end