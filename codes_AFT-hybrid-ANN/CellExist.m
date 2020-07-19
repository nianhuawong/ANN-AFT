function [direction, row] = CellExist(node1, node2, node3, node4, cellNodeTopo)
row = -1;
direction = 0;
for i =1:size(cellNodeTopo,1)
    node11 = cellNodeTopo(i,1);
    node22 = cellNodeTopo(i,2);
    node33 = cellNodeTopo(i,3);
    node44 = cellNodeTopo(i,4);
    if( node11== node1 && node22 == node2 && node33 == node3 && node44 == node4 )
        row = i;
        direction = 1;
    elseif( node11== node4 && node22 == node1 && node33 == node2 && node44 == node3 )
        row = i;
        direction = 2;
    elseif( node11== node3 && node22 == node4 && node33 == node1 && node44 == node2 )
        row = i;
        direction = 3;
    elseif( node11== node2 && node22 == node3 && node33 == node4 && node44 == node1 )
        row = i;
        direction = 4;
    end   
end
        