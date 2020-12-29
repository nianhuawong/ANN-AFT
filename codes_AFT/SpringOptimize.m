function [xCoord,yCoord] = SpringOptimize(triMesh,invalidCells,wallNodes,times)
xCoord_old = triMesh.Points(:,1);
yCoord_old = triMesh.Points(:,2);

nNodes = length(xCoord_old);
xCoord = zeros(nNodes,1);
yCoord = zeros(nNodes,1);

ti = vertexAttachments(triMesh);
tri = triMesh.ConnectivityList;

figure;
for NN = 1:times
    for i = 1:nNodes
        if sum(wallNodes == i) ~= 0 
            xCoord(i) = xCoord_old(i);
            yCoord(i) = yCoord_old(i);            
        else          
            attachedTri = ti(i,:);
            node_id = tri(attachedTri{:},:);
            node_id = unique(node_id(:),'stable');
            nn = length(node_id);
            xCoord_tmp = 0; yCoord_tmp = 0;
            for j =1:nn
                node = node_id(j);
                xCoord_tmp = xCoord_old(node) + xCoord_tmp;
                yCoord_tmp = yCoord_old(node) + yCoord_tmp;
            end
            xCoord(i) = xCoord_tmp / nn;
            yCoord(i) = yCoord_tmp / nn;
        end
        xCoord_old(i) = xCoord(i);%更新点i坐标后，立马采用新坐标进行后续更新
        yCoord_old(i) = yCoord(i);
    end
    xCoord_old = xCoord;
    yCoord_old = yCoord;
    
    tri_plot = tri;
    tri_plot(invalidCells,:) = [];
    clf
    triplot(tri_plot,xCoord,yCoord);
    axis equal;
    axis off
    hold on;
    pause(0.5)
end
end
%%
% function [xCoord,yCoord] = SpringOptimize(triMesh,invalidCells,wallNodes,times)
% xCoord = triMesh.Points(:,1);
% yCoord = triMesh.Points(:,2);
% 
% nNodes = length(xCoord);
% ti = vertexAttachments(triMesh);
% tri = triMesh.ConnectivityList;
% figure;
% for NN = 1:times
%     for i = 1:nNodes
%         if sum(wallNodes == i) ~= 0 
%             continue;
%         end
%         attachedTri = ti(i,:);
%         node_id = tri(attachedTri{:},:);
%         node_id = unique(node_id(:),'stable');
%         nn = length(node_id);
%         xCoord_tmp = 0; yCoord_tmp = 0;
%         for j =1:nn
%             node = node_id(j);
%             xCoord_tmp = xCoord(node) + xCoord_tmp;
%             yCoord_tmp = yCoord(node) + yCoord_tmp;
%         end
%         xCoord(i) = xCoord_tmp / nn;
%         yCoord(i) = yCoord_tmp / nn;
%     end
%       
%     tri_plot = tri;
%     tri_plot(invalidCells,:) = [];
% %     for i = 1 : size(tri_plot,1)
% %         node1 = tri_plot(i,1);
% %         node2 = tri_plot(i,2);
% %         node3 = tri_plot(i,3);
% %         cell_tmp1 = [node1,node2,node3];
% %         tmp = intersect(wallNodes,cell_tmp1);
% %         if length(tmp)>=3 && min([node1,node2,node3])>nNodesOnOuterBoundary
% % %         if sum( wallNodes == node1 )~= 0 && sum( wallNodes == node2 )~=0 && sum( wallNodes == node3 )~=0 && min([node1,node2,node3])>36
% %             tri_plot(i,:) = -1;
% %         end
% %     end
% %     II = tri_plot(:,1)==-1;
% %     tri_plot(II,:) = [];
% %     figure;
%     clf
%     triplot(tri_plot,xCoord,yCoord);
%     axis equal;
%     axis off
%     hold on;
%     % axis([-0.7 0.7 -0.5 0.5])
%     pause(0.5)
% end
% end