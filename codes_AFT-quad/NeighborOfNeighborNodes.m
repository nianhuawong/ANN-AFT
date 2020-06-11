function neighbor2= NeighborOfNeighborNodes(neighbor1, AFT_stack)

neighbor2 = [];
for i = 1:length(neighbor1)
    neighborNode1 = neighbor1(i); %аз╣Ц 
    neighbor2(i,:)=NeighborNodes(neighborNode1, AFT_stack);
end

end
