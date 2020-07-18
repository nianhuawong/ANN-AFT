function flagDiag   = IsPointDiagnoal(cellNodeTopo, node1_base, node2_base, node_test)
flagDiag = 0;

nCells = size(cellNodeTopo,1);

for i = 1:nCells
    cell = cellNodeTopo(i,:);
    cell(cell==0) = [];
    if length(cell)==3
        
        
    elseif length(cell)==4
        node1 = cell(1);
        node2 = cell(2);
        node3 = cell(3);
        node4 = cell(4);
        
        if length(node_test) == 2
            if ( node_test(1) == node1 && node_test(2) == node4 ) || ...
               ( node_test(1) == node2 && node_test(2) == node3 )
                flagDiag = 1;
                break;
            end
            node_test = node_test(2);
        end
        
        if ( node1_base == node1 && node_test == node4 ) || ...
                ( node1_base == node2 && node_test == node3 ) || ...
                ( node2_base == node1 && node_test == node4 ) || ...
                ( node2_base == node2 && node_test == node3 ) || ...
                ( node1_base == node1 && node2_base == node4 )|| ...
                ( node1_base == node2 && node2_base == node3 )
            
            flagDiag = 1;
            break;
        end
    end
end