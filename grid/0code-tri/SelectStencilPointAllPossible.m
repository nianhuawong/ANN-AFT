function stencilPoint = SelectStencilPointAllPossible(node1_base,node2_base,neighborNode1,neighborNode2)
pickNode1 = 0;
pickNode2 = 0;
stencilPoint = [];
targetPoint  = [];
for ii = 1:length(neighborNode1)
    if neighborNode1(ii) ~= node2_base
        pickNode1 = neighborNode1(ii);
        for jj = 1:length(neighborNode2)
            if neighborNode2(jj) ~= node1_base
                pickNode2 = neighborNode2(jj);
            end
            
            if pickNode1 ~=0 && pickNode2 ~=0 && pickNode1 ~= pickNode2
                stencilPoint(end+1,:) = [pickNode1,node1_base,node2_base,pickNode2]; 
            end
        end
    end
end