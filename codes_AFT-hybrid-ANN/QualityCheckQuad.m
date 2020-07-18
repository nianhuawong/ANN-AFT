function [quality,h] = QualityCheckQuad(node1, node2, node3, node4, xCoord_AFT, yCoord_AFT, Sp)

v_ad =   [xCoord_AFT(node4)-xCoord_AFT(node1), yCoord_AFT(node4)-yCoord_AFT(node1)];
v_cb = - [xCoord_AFT(node2)-xCoord_AFT(node3), yCoord_AFT(node2)-yCoord_AFT(node3)];

dd1 = sqrt( v_ad(1)^2 + v_ad(2)^2 );
dd2 = sqrt( v_cb(1)^2 + v_cb(2)^2 );
angle = acos( v_ad * v_cb' / dd1 / dd2 );
Area = 0.5 * dd1 * dd2 * sin(angle);
h = sqrt(Area);
if Sp == -1
    Sp = h;
else
    Sp = max([h,Sp]);
end

dist12  = DISTANCE(node1, node2, xCoord_AFT, yCoord_AFT);
dist13  = DISTANCE(node1, node3, xCoord_AFT, yCoord_AFT);
dist24  = DISTANCE(node2, node4, xCoord_AFT, yCoord_AFT);
dist34  = DISTANCE(node3, node4, xCoord_AFT, yCoord_AFT);

v12 = [xCoord_AFT(node2)-xCoord_AFT(node1), yCoord_AFT(node2)-yCoord_AFT(node1)];
v13 = [xCoord_AFT(node3)-xCoord_AFT(node1), yCoord_AFT(node3)-yCoord_AFT(node1)];
v24 = [xCoord_AFT(node4)-xCoord_AFT(node2), yCoord_AFT(node4)-yCoord_AFT(node2)];
v34 = [xCoord_AFT(node4)-xCoord_AFT(node3), yCoord_AFT(node4)-yCoord_AFT(node3)];

d12 = sqrt( v12(1)^2 + v12(2)^2 );
d13 = sqrt( v13(1)^2 + v13(2)^2 );
d24 = sqrt( v24(1)^2 + v24(2)^2 );
d34 = sqrt( v34(1)^2 + v34(2)^2 );

angle1 = acos(  v12 * v13' / ( d12 + 1e-40 ) / ( d13  + 1e-40 ) ) * 180 / pi;
angle2 = acos( -v12 * v24' / ( d12 + 1e-40 ) / ( d24  + 1e-40 ) ) * 180 / pi;
angle3 = acos( -v13 * v34' / ( d13 + 1e-40 ) / ( d34  + 1e-40 ) ) * 180 / pi;
angle4 = acos(  v24 * v34' / ( d24 + 1e-40 ) / ( d34  + 1e-40 ) ) * 180 / pi;

if ( abs( 360 - ( angle1 + angle2 + angle3 + angle4 ) )  > 0.1 )   %非凸四边形内角和不为360°
    quality = 0;
else
    %     quality = 1.0 / ( ( 2.0 * dist13/dist12 - Sp ) +( 2.0 * dist24/dist12 - Sp ) + abs(v12 * v13') + abs(v12 * v24'));
    %
    %     quality = Sp * quality / 0.5;
    
    quality = dist13 * sin(angle1/180*pi) / Sp + dist24 * sin(angle2/180*pi) / Sp + d34 / d12;
    quality = quality / 3.0;
end


end