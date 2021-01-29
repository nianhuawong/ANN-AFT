function [direction, row] = FrontExist(node1,node2, AFT_stack)
row = -1;
direction = 0;
for i =1:size(AFT_stack,1)
    node11 = AFT_stack(i,1);
    node22 = AFT_stack(i,2);
    if( node11== node1 && node22 == node2)
        row = i;
        direction = 1;
    elseif( node11 == node2 && node22 == node1)
        row = i;
        direction = -1;        
    end
end
        