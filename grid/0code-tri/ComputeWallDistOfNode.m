function wdist = ComputeWallDistOfNode(Grid_stack, Coord, xNode, yNode)
xCoord = Coord(:,1);
yCoord = Coord(:,2);
node1 = Grid_stack(:,1);
node2 = Grid_stack(:,2);
bcType = Grid_stack(:,7);

nWallFaces = sum( bcType == 3 );
I = find(bcType==3);

wdist = 1e40;
for i =1:nWallFaces
    wallFaceIndex = I(i);
    node1_w = node1(wallFaceIndex);
    node2_w = node2(wallFaceIndex);
    
    xmid_w = 0.5 * ( xCoord(node1_w) + xCoord(node2_w) );
    ymid_w = 0.5 * ( yCoord(node1_w) + yCoord(node2_w) );
    
    tmp = sqrt((xmid_w-xNode)^2+(ymid_w-yNode)^2);
    if tmp < wdist
        wdist = tmp;
    end
end