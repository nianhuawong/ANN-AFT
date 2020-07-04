function [flag, frontSize] = isNotBoundaryNodes(nodeIndex, Grid_stack)
nFaces = size(Grid_stack,1);
boundaryNodes = [];
frontSize = 0;
count = 0;
for i = 1:nFaces
    bcType = Grid_stack(i,7);
    node1 = Grid_stack(i,1);
    node2 = Grid_stack(i,2);
    
    if bcType ~= 2        
        boundaryNodes = [boundaryNodes, node1, node2] ;       
    end
    
    if node1 == nodeIndex || node2 == nodeIndex
        frontSize = frontSize + Grid_stack(i,5);
        count = count + 1;
    end
end

if sum(boundaryNodes==nodeIndex)~= 0         
    flag = 0;
    frontSize = -1;
else
    flag = 1;
    frontSize = frontSize / count;
end

end
        
