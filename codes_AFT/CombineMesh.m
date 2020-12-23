function quad = CombineMesh(triMesh, invalidCellIndex, wallNodes, qualCriterion, xCoord, yCoord)
global rectangularBoudanryNodes;
if nargin == 3
    xCoord = triMesh.Points(:,1);
    yCoord = triMesh.Points(:,2);
end

tri = triMesh.ConnectivityList;
neighbor = neighbors(triMesh);
nCells_ori = size(tri,1);

% tri_bak = tri; 
% wallCells = [];
% for i = 1:nCells_ori
%     tmp = intersect(wallNodes,tri(i,:));
%     if length(tmp) >= 2
%         wallCells(end+1) = i;%找到边界单元
%     end
% end
% 
% nWallCells = length(wallCells);
% for i = 1:nWallCells    
%     tmp = tri(i,:);
%     tri(i,:) = tri(wallCells(i),:);%把边界单元放在单元列表最前面
%     tri(wallCells(i),:) = tmp;
%     
%     tmp2 = neighbor(i,:);
%     neighbor(i,:) = neighbor(wallCells(i),:);
%     neighbor(wallCells(i),:) = tmp2;   
% end

quad = zeros( round(nCells_ori/2), 4 );
% for i = 1:nCells_ori
%     plot(xCoord(tri(i,1)),yCoord(tri(i,1)),'r*')
%     hold on;axis equal;
%     plot(xCoord(tri(i,2)),yCoord(tri(i,2)),'go')
%     plot(xCoord(tri(i,3)),yCoord(tri(i,3)),'bx')    
% end
count = 0;
nQuadCells = 0;
nTriCells  = 0;
for i = 1:nCells_ori  %遍历每个原始单元
    if i==45
        kkk = 1;
    end
    node1 = tri(i,1);
    node2 = tri(i,2);
    node3 = tri(i,3);
    if node1 == -1 || node2 == -1 || node3 == -1
        continue;
    end

    TN = neighbor(i,:);  %找到其相邻单元
    num_neighbor = length(TN);
    
    quality = 0; node = -1; 
    for j = 1:num_neighbor  %对每个相邻单元，都要计算其合并后的单元质量
        if isnan(TN(j)) || sum(invalidCellIndex==TN(j))~=0
            continue;
        end
        
        [~,~,IB] = intersect(tri(i,:),tri(TN(j),:));  %找到相邻单元的相同节点
        node_t = tri(TN(j),:);
        node_t(IB)=[];%找到相邻单元的另一个点
        if node_t(1) == -1
            continue;
        end
        
%         if node1 == 40 || node1 == 41 || node1 == 210 || node1 == 209 || node1 == 499 
%             kkk = 1;
%             plot(xCoord(node1),yCoord(node1),'r*')
%             hold on;axis equal;
%             plot(xCoord(node2),yCoord(node2),'go')
%             plot(xCoord(node3),yCoord(node3),'bx')
%             plot(xCoord(node_t),yCoord(node_t),'k+')
%         end
        
%         flag0 = IsLeftCell(node1, node2, node3, xCoord, yCoord);
        flag1 = IsLeftCell(node1, node2, node_t, xCoord, yCoord);
        flag2 = IsLeftCell(node3, node1, node_t, xCoord, yCoord);
        flag3 = IsLeftCell(node2, node3, node_t, xCoord, yCoord);
        if flag1 == 0
            tmp = QualityCheckQuad(node1, node_t, node2, node3, xCoord, yCoord,-1);
%             tmp = QualityCheckQuad_new(node1, node_t, node2, node3, xCoord, yCoord);
            cell_tmp = [node1, node_t, node2, node3];
        elseif flag2 == 0
            tmp = QualityCheckQuad(node3, node_t, node1, node2, xCoord, yCoord,-1);
%             tmp = QualityCheckQuad_new(node3, node_t, node1, node2, xCoord, yCoord);
            cell_tmp = [node3, node_t, node1, node2];
        elseif flag3 == 0
            tmp = QualityCheckQuad(node2, node_t, node3, node1, xCoord, yCoord,-1);
%             tmp = QualityCheckQuad_new(node2, node_t, node3, node1, xCoord, yCoord);
            cell_tmp = [node2, node_t, node3, node1];
        end      
        
        if tmp > quality && tmp> qualCriterion
            quality = tmp;
            node = node_t; 
            nn = TN(j);   %邻居单元的编号
            cell = cell_tmp;
        end
    end
    
   if node == -1  %如果没有合并成功，因为不满足qualCriterion
       cell_tmp1 = [node1,node2,node3]; %则仍然是三角形
       tmp = intersect(wallNodes,cell_tmp1);
       if length(tmp)>=3 && min([node1,node2,node3])>rectangularBoudanryNodes
           
       else
           quad(count+1,:) = [node1,node2,node3,-1];
           count = count + 1;
           nTriCells = nTriCells + 1;
           tri(i,:) = -1;
       end
   else   
       cell_tmp1 = [node1,node2,node3,node];
       tmp = intersect(wallNodes,cell_tmp1);
       if length(tmp)>=3 && min([node1,node2,node3])>rectangularBoudanryNodes
           
       else
           quad(count+1,:) = cell;
           count = count + 1;
           nQuadCells = nQuadCells + 1;
           tri(nn,:) = -1;
           tri(i,:) = -1;
       end
   end
end
quad( quad(:,1)==0, : ) = [];

nTotalCells = size(quad,1);
disp('==========网格合并完成！=========');
disp(['合并后总单元数   ：', num2str(nTotalCells)]);
disp(['合并后quad单元数 ：', num2str(nQuadCells)]);
disp(['合并后tri 单元数 ：', num2str(nTriCells)]);

figure; 
for i = 1:size(quad,1)
    edge1 = [quad(i,1),quad(i,2)];
    edge2 = [quad(i,2),quad(i,3)];
    
    if quad(i,4) ~= -1
        edge3 = [quad(i,3),quad(i,4)];
        edge4 = [quad(i,4),quad(i,1)];
        edge = [edge1;edge2;edge3;edge4];
    else
        edge3 = [quad(i,3),quad(i,1)];
        edge = [edge1;edge2;edge3];
    end
    
    plot(xCoord(edge),yCoord(edge),'b-')
    hold on;
    
end
axis equal;
axis off;
kkk = 1;
end