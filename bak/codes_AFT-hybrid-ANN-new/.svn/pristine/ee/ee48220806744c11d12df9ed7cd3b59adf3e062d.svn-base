function neighbor2= NeighborOfNeighborNodes(neighbor1, AFT_stack)

neighbor2 = [];
for i = 1:length(neighbor1)
    neighborNode1 = neighbor1(i); %аз╣Ц     
    tmp = NeighborNodes(neighborNode1, AFT_stack, -1);
   
    neighbor2 = [neighbor2, tmp];    
end
neighbor2 = unique(neighbor2);
end
