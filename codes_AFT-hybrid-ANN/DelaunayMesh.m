function [triMesh,invalidCellIndex] = DelaunayMesh(xCoord,yCoord,wallNodes)
nNodesOnOuterBoundary = 36;  %矩形外边界上的节点数，可能会变化
%%
disp('=================Delaunay网格生成中...=================');
% tri = delaunay(xCoord,yCoord);
triMesh = delaunayTriangulation(xCoord,yCoord); 
tri = triMesh.ConnectivityList;%delaunay生成的网格单元，每个单元由哪几个节点组成
invalidCellIndex = [];
for i = 1 : size(tri,1)
    node1 = tri(i,1);
    node2 = tri(i,2);
    node3 = tri(i,3);
    
    cell_tmp1 = [node1,node2,node3];        %当前单元
    tmp = intersect(wallNodes,cell_tmp1);   %当前单元与物面节点求交
    if length(tmp)>=3 && min([node1,node2,node3])>nNodesOnOuterBoundary %如果求交结果大于等于3，则说明当前单元的3个节点都在物面上，且同时是内部边界（如圆柱表面），则删掉不合理单元      
%         tri(i,:) = -1;                                                  %外部边界3个节点同时在物面上时，仍需保留该单元
        invalidCellIndex(end+1) = i;
    end
end
% II = tri(:,1)==-1;%删除不合理的delaunay单元后，得到真实的网格单元
tri(invalidCellIndex,:) = [];

figure;
triplot(tri,xCoord,yCoord);
axis equal;
axis off

% axis([-0.7 0.7 -0.5 0.5])
% axis([-1 1 -1 1])

disp(['Delaunay网格生成结束，单元数：', num2str(size(tri,1))]);
end