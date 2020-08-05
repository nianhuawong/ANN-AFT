function flagConvexPoly = IsConvexPloygon(node1, node2, node3, node4, xCoord, yCoord)
flagConvexPoly = 1;

if node3 == -1 || node4 == -1
    flagConvexPoly = 0;
    return;
end


node1Coor = [xCoord(node1),yCoord(node1)];
node2Coor = [xCoord(node2),yCoord(node2)];
node3Coor = [xCoord(node3),yCoord(node3)];
node4Coor = [xCoord(node4),yCoord(node4)];

v12 = node2Coor - node1Coor;
v23 = node3Coor - node2Coor;
v34 = node4Coor - node3Coor;
v41 = node1Coor - node4Coor;

v21 = - v12;
v32 = - v23;
v43 = - v34;
v14 = - v41;

d12 =  sqrt( v12(1)^2 + v12(2)^2 );
d23 =  sqrt( v23(1)^2 + v23(2)^2 );
d34 =  sqrt( v34(1)^2 + v34(2)^2 );
d41 =  sqrt( v41(1)^2 + v41(2)^2 );

angle1 = acos( v12 * v14' / d12 / d41 ) ;
angle2 = acos( v21 * v23' / d12 / d23 );
angle3 = acos( v32 * v34' / d23 / d34 );
angle4 = acos( v41 * v43' / d41 / d34 );

angle1 = angle1 / pi * 180;
angle2 = angle2 / pi * 180;
angle3 = angle3 / pi * 180;
angle4 = angle4 / pi * 180;

% if angle1 > pi || angle2 > pi || angle3 > pi || angle4 > pi
if ( abs( 360 - ( angle1 + angle2 + angle3 + angle4 ) )  > 1e-5 )   %非凸四边形内角和不为360°
    flagConvexPoly = 0;
end