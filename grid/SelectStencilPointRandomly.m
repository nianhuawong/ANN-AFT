function stencilPoint = SelectStencilPointRandomly(node1_base,node2_base,neighborNode1,neighborNode2)
pickNode1 = 0;
pickNode2 = 0;
while pickNode1 == pickNode2        %确保不会连成一个封闭三角形
    [~,I] = max(rand(1,length(neighborNode1)));
    while neighborNode1(I) == node2_base
        [~,I] = max(rand(1,length(neighborNode1)));
    end
    pickNode1 = neighborNode1(I);
    
    [~,I] = max(rand(1,length(neighborNode2)));
    while neighborNode2(I) == node1_base
        [~,I] = max(rand(1,length(neighborNode2)));
    end
    pickNode2 = neighborNode2(I);
end

stencilPoint = [pickNode1, node1_base, node2_base, pickNode2];

end