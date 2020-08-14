function quad = CombineMesh(triMesh,wallNodes,qualCriterion, xCoord, yCoord)
if nargin == 3
    xCoord = triMesh.Points(:,1);
    yCoord = triMesh.Points(:,2);
end
tri = triMesh.ConnectivityList;
neighbor = neighbors(triMesh);
 
nCells_ori = size(tri,1);
quad = zeros( round(nCells_ori/2), 4 );
% for i = 1:nCells_ori
%     plot(xCoord(tri(i,1)),yCoord(tri(i,1)),'r*')
%     hold on;axis equal;
%     plot(xCoord(tri(i,2)),yCoord(tri(i,2)),'go')
%     plot(xCoord(tri(i,3)),yCoord(tri(i,3)),'bx')    
% end
count = 0;
for i = 1:nCells_ori
    node1 = tri(i,1);
    node2 = tri(i,2);
    node3 = tri(i,3);
    if node1 == -1 || node2 == -1 || node3 == -1
        continue;
    end

    TN = neighbor(i,:);
    num_neighbor = length(TN);
    
    quality = 0; node = -1; 
    for j = 1:num_neighbor
        if isnan(TN(j))
            continue;
        end
        
        [~,~,IB] = intersect(tri(i,:),tri(TN(j),:));
        node_t = tri(TN(j),:);
        node_t(IB)=[];
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
        
        flag0 = IsLeftCell(node1, node2, node3, xCoord, yCoord);
        flag1 = IsLeftCell(node1, node2, node_t, xCoord, yCoord);
        flag2 = IsLeftCell(node3, node1, node_t, xCoord, yCoord);
        flag3 = IsLeftCell(node2, node3, node_t, xCoord, yCoord);
        if flag1 == 0
            tmp = QualityCheckQuad_new(node1, node_t, node2, node3, xCoord, yCoord);
            cell_tmp = [node1, node_t, node2, node3];
        elseif flag2 == 0
            tmp = QualityCheckQuad_new(node3, node_t, node1, node2, xCoord, yCoord);
            cell_tmp = [node3, node_t, node1, node2];
        elseif flag3 == 0
            tmp = QualityCheckQuad_new(node2, node_t, node3, node1, xCoord, yCoord);
            cell_tmp = [node2, node_t, node3, node1];
        end      
        
        if tmp > quality && tmp> qualCriterion
            quality = tmp;
            node = node_t; 
            nn = TN(j);
            cell = cell_tmp;
        end
    end
    
   if node == -1  
       if sum( wallNodes == node1 )~= 0 && sum( wallNodes == node2 )~=0 && sum( wallNodes == node3 )~=0 %&& min([node1,node2,node3])>36
           
       else
           quad(count+1,:) = [node1,node2,node3,-1];
           count = count + 1;
           tri(i,:) = -1;
       end
   else      
       if sum( wallNodes == node1 )~= 0 && sum( wallNodes == node2 )~=0 && ...
               sum( wallNodes == node3 )~= 0 && sum( wallNodes == node )~= 0
           
       else
           quad(count+1,:) = cell;
           count = count + 1;
           tri(nn,:) = -1;
           tri(i,:) = -1;
       end
   end
end
quad( quad(:,1)==0, : ) = [];

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
    
    plot(xCoord(edge),yCoord(edge),'r-')
    hold on;
    
end
axis equal;
axis off;
kkk = 1;
end