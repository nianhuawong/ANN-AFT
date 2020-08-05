function DelaunayMesh(xCoord,yCoord,wallNodes)
%%
disp('================================');
disp('======Delaunay网格生成中...======');
figure;
tri = delaunay(xCoord,yCoord);
for i = 1 : size(tri,1)
    node1 = tri(i,1);
    node2 = tri(i,2);
    node3 = tri(i,3);
    if sum( wallNodes == node1 )~= 0 && sum( wallNodes == node2 )~=0 && sum( wallNodes == node3 )~=0
        tri(i,:) = -1;
    end
end
II = tri(:,1)==-1;
tri(II,:) = [];
triplot(tri,xCoord,yCoord);
axis equal;
axis off
% axis([-0.7 0.7 -0.5 0.5])
% axis([-1 1 -1 1])

disp(['Delaunay网格生成结束，单元数：', num2str(size(tri,1))]);
end