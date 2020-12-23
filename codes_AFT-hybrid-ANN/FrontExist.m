% [row, direction] = FrontExist(452,331, AFT_stack_sorted)
function [row, direction] = FrontExist(node1,node2, AFT_stack,faceCandidate)
row = -1;
direction = 0;
if node1 == -1 || node2 == -1 
    return;
end

if nargin == 3
    faceCandidate = 1:size(AFT_stack,1);
end

nFaces = size(faceCandidate,2);
for i =1:nFaces
    iFace = faceCandidate(i);
    node11 = AFT_stack(iFace,1);
    node22 = AFT_stack(iFace,2);
    if( node11== node1 && node22 == node2 )
        row = i;
        direction = 1;
    elseif( node11 == node2 && node22 == node1)
        row = i;
        direction = -1;        
    end
end
        