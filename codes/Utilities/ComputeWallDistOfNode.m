function [wdist,index] = ComputeWallDistOfNode(Grid_stack, Coord, xNode, yNode, bc)
xCoord = Coord(:,1);
yCoord = Coord(:,2);
node1 = Grid_stack(:,1);
node2 = Grid_stack(:,2);
bcType = Grid_stack(:,7);

nWallFaces = sum( bcType == bc );  %BC=3为物面，BC=9为外场边界
I = find(bcType==bc);

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
        index = wallFaceIndex;
    end
end