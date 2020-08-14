function targetPoint = TargetPointOfFrontQuad(Grid_stack) 
%四边形网格寻找targetPoint
%%
nFaces = size(Grid_stack, 1);
node1 = Grid_stack(:,1);
node2 = Grid_stack(:,2);
leftCell = Grid_stack(:,3);
rightCell = Grid_stack(:,4);

targetPoint = zeros(nFaces,2);
for i = 1:nFaces                %对于某个阵面
    targetTmp = []; 
    leftCellIndex = leftCell(i);
    %寻找leftCell的另外2个点
    for ii = 1:nFaces
        if leftCell(ii) == leftCellIndex || rightCell(ii) == leftCellIndex   %找到该面
            node1OfFace = node1(ii);
            node2OfFace = node2(ii);
            if node1OfFace ~= node1(i) && node1OfFace ~= node2(i) && size(find(targetTmp==node1OfFace),2) == 0               
                targetTmp = [targetTmp,node1OfFace];
            end
            
            if node2OfFace ~= node1(i) && node2OfFace ~= node2(i) && size(find(targetTmp==node2OfFace),2) == 0
                targetTmp = [targetTmp,node2OfFace];
            end                      
        end
%         if size(targetTmp,2) == 2 
%             targetPoint(i,:) = targetTmp
%             break;
%         end
    end
    %% 对targetPoint进行排序，node1_base的放在前，node2_base的放在后
    if length(targetTmp) == 2
        node1_base = node1(i);
        node2_base = node2(i);
        neighbor1 = NeighborNodes(node1_base,Grid_stack,node2_base);
        %     neighbor2 = NeighborNodes(node2_base,Grid_stack,node1_base);
        
        if( sum(targetTmp(1)==neighbor1) ~= 0 )
            targetPoint(i,:) = [targetTmp(1), targetTmp(2)];
        else
            targetPoint(i,:) = [targetTmp(2), targetTmp(1)];
        end
    else       
        targetPoint(i,:) = targetTmp;
    end
end
