function wdist = ComputeWallDistOfFace(iFace, Grid_stack, Coord)
node1 = Grid_stack(:,1);
node2 = Grid_stack(:,2);
xCoord = Coord(:,1);
yCoord = Coord(:,2);

node1_base = node1(iFace);     %确定其一个node
node2_base = node2(iFace);

xmid = 0.5 * ( xCoord(node1_base) + xCoord(node2_base) );
ymid = 0.5 * ( yCoord(node1_base) + yCoord(node2_base) );

wdist = ComputeWallDistOfNode(Grid_stack, Coord, xmid, ymid);
end
