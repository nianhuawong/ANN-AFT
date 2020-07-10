function neighbors = NeighborNodes(node_base, AFT_stack, node)

neighbors=[];
for i = 1: size(AFT_stack,1)
    if( AFT_stack(i,1)== node_base && AFT_stack(i,2) ~= node)
        neighbors(end+1) = AFT_stack(i,2);
    end
    if( AFT_stack(i,2) == node_base && AFT_stack(i,1) ~= node)
        neighbors(end+1) = AFT_stack(i,1);
    end
end
neighbors = unique(neighbors);
end
