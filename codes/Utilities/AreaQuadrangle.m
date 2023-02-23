function area = AreaQuadrangle(node1, node2, node3, node4)
v13 = node3-node1;
d13 =  sqrt( v13(1)^2 + v13(2)^2 );

v42 = node2-node4;
d42 = sqrt( v42(1)^2 + v42(2)^2 );

tmp = v13 * v42' / ( d13 + 1e-20 ) / ( d42  + 1e-20 );

if abs(tmp-1.0)<1e-5
    tmp = 1;
end

if abs(tmp+1.0) < 1e-5
    tmp = -1;
end

angle = acos( tmp );

area = 0.5 * d13 * d42 * sin(angle);