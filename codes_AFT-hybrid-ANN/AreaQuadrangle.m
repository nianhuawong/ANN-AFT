function area = AreaQuadrangle(node1, node2, node3, node4)
v14 = node4-node1;
d14 =  sqrt( v14(1)^2 + v14(2)^2 );

v32 = node2-node3;
d32 = sqrt( v32(1)^2 + v32(2)^2 );

angle = acos( v14 * v32' / ( d14 + 1e-40 ) / ( d32  + 1e-40 ) );

area = 0.5 * d14 * d32 * sin(angle);