function flagDiag   = IsPointDiagnoal(cellNodeTopo, node1_base, node2_base, node_check, nodeCandidate)
flagDiag = 0;

nCells = size(cellNodeTopo,1);

for i = 1:nCells
    node_test = node_check;
    cell = cellNodeTopo(i,:);
    cell(cell==0) = [];
    if i == 104 
        kkk = 1;
    end
    if length(cell)==3
        continue;        
    elseif length(cell)==4
        node1 = cell(1);
        node2 = cell(2);
        node3 = cell(3);
        node4 = cell(4);
        
        if sum(node1 == nodeCandidate) == 0 && sum(node2 == nodeCandidate) == 0 && ...
                sum(node3 == nodeCandidate) == 0 && sum(node4 == nodeCandidate) == 0
            continue;
        end
        
        if length(node_test) == 2
            if ( node_test(1) == node1 && node_test(2) == node3 ) || ...
               ( node_test(1) == node2 && node_test(2) == node4 ) || ...
               ( node_test(2) == node1 && node_test(1) == node3 ) || ...
               ( node_test(2) == node2 && node_test(1) == node4 )
                flagDiag = 1;
                break;
            end
            node_test = node_test(2);%测完node_select(1)和node_test的连线后，再单独测node_test
        end
        
        if ( node1_base == node1 && node_test == node3 ) || ...
           ( node1_base == node2 && node_test == node4 ) || ...
           ( node1_base == node3 && node_test == node1 ) || ...
           ( node1_base == node4 && node_test == node2 ) || ...
           ( node2_base == node1 && node_test == node3 ) || ...
           ( node2_base == node2 && node_test == node4 ) || ...
           ( node2_base == node3 && node_test == node1 ) || ...
           ( node2_base == node4 && node_test == node2 ) || ... 
           ( node1_base == node1 && node2_base == node3 )|| ...
           ( node1_base == node2 && node2_base == node4 )|| ...
           ( node1_base == node3 && node2_base == node1 )|| ...
           ( node1_base == node4 && node2_base == node2 )
            
            flagDiag = 1;
            break;
        end
    end
end