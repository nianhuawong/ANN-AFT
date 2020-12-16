function [triMesh,invalidCellIndex] = DelaunayMesh(xCoord,yCoord,wallNodes)
nNodesOnOuterBoundary = 36;  %������߽��ϵĽڵ��������ܻ�仯
%%
disp('=================Delaunay����������...=================');
% tri = delaunay(xCoord,yCoord);
triMesh = delaunayTriangulation(xCoord,yCoord); 
tri = triMesh.ConnectivityList;%delaunay���ɵ�����Ԫ��ÿ����Ԫ���ļ����ڵ����
invalidCellIndex = [];
for i = 1 : size(tri,1)
    node1 = tri(i,1);
    node2 = tri(i,2);
    node3 = tri(i,3);
    
    cell_tmp1 = [node1,node2,node3];        %��ǰ��Ԫ
    tmp = intersect(wallNodes,cell_tmp1);   %��ǰ��Ԫ������ڵ���
    if length(tmp)>=3 && min([node1,node2,node3])>nNodesOnOuterBoundary %����󽻽�����ڵ���3����˵����ǰ��Ԫ��3���ڵ㶼�������ϣ���ͬʱ���ڲ��߽磨��Բ�����棩����ɾ��������Ԫ      
%         tri(i,:) = -1;                                                  %�ⲿ�߽�3���ڵ�ͬʱ��������ʱ�����豣���õ�Ԫ
        invalidCellIndex(end+1) = i;
    end
end
% II = tri(:,1)==-1;%ɾ���������delaunay��Ԫ�󣬵õ���ʵ������Ԫ
tri(invalidCellIndex,:) = [];

figure;
triplot(tri,xCoord,yCoord);
axis equal;
axis off

% axis([-0.7 0.7 -0.5 0.5])
% axis([-1 1 -1 1])

disp(['Delaunay�������ɽ�������Ԫ����', num2str(size(tri,1))]);
end