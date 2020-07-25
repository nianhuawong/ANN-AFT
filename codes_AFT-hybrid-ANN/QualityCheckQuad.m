function [quality,h] = QualityCheckQuad(node1, node2, node3, node4, xCoord_AFT, yCoord_AFT, Sp)

v_ac = [xCoord_AFT(node3)-xCoord_AFT(node1), yCoord_AFT(node3)-yCoord_AFT(node1)];
v_db = [xCoord_AFT(node2)-xCoord_AFT(node4), yCoord_AFT(node2)-yCoord_AFT(node4)];

dd1 = sqrt( v_ac(1)^2 + v_ac(2)^2 ) + 1e-40;
dd2 = sqrt( v_db(1)^2 + v_db(2)^2 ) + 1e-40;
angle = acos( v_ac * v_db' / dd1 / dd2 );
Area = 0.5 * dd1 * dd2 * sin(angle);
h = sqrt(Area);

% if Sp > 0 
    h = max([h,Sp]); 
% end

if Sp < 0 
    Sp = h;
end

dist12  = DISTANCE(node1, node2, xCoord_AFT, yCoord_AFT);
dist23  = DISTANCE(node2, node3, xCoord_AFT, yCoord_AFT);
dist34  = DISTANCE(node3, node4, xCoord_AFT, yCoord_AFT);
dist41  = DISTANCE(node4, node1, xCoord_AFT, yCoord_AFT);

v12 = [xCoord_AFT(node2)-xCoord_AFT(node1), yCoord_AFT(node2)-yCoord_AFT(node1)];
v23 = [xCoord_AFT(node3)-xCoord_AFT(node2), yCoord_AFT(node3)-yCoord_AFT(node2)];
v34 = [xCoord_AFT(node4)-xCoord_AFT(node3), yCoord_AFT(node4)-yCoord_AFT(node3)];
v41 = [xCoord_AFT(node1)-xCoord_AFT(node4), yCoord_AFT(node1)-yCoord_AFT(node4)];

d12 = sqrt( v12(1)^2 + v12(2)^2 );
d23 = sqrt( v23(1)^2 + v23(2)^2 );
d34 = sqrt( v34(1)^2 + v34(2)^2 );
d41 = sqrt( v41(1)^2 + v41(2)^2 );

angle1 = acos( -v41 * v12' / ( d12 + 1e-40 ) / ( d41  + 1e-40 ) ) * 180 / pi;
angle2 = acos( -v12 * v23' / ( d12 + 1e-40 ) / ( d23  + 1e-40 ) ) * 180 / pi;
angle3 = acos( -v23 * v34' / ( d23 + 1e-40 ) / ( d34  + 1e-40 ) ) * 180 / pi;
angle4 = acos( -v34 * v41' / ( d34 + 1e-40 ) / ( d41  + 1e-40 ) ) * 180 / pi;

if ( abs( 360 - ( angle1 + angle2 + angle3 + angle4 ) )  > 1e-5 )   %非凸四边形内角和不为360°
    quality = 0;
else  
%     quality = dist41 * sin(angle1/180*pi) / Sp + dist23 * sin(angle2/180*pi) / Sp + d34 / d12;    
%     quality = quality / 3.0;
    
%     quality = abs( d41/d12 - Sp ) + abs( d12/d41 - Sp ) + ...
%               abs( d23/d12 - Sp ) + abs( d12/d23 - Sp ) + ...
%               abs( acos( abs(v12 * v41') / d12 / d41 ) - pi / 2.0 ) + ...
%               abs( acos( abs(v12 * v23') / d12 / d23 ) - pi / 2.0 ) + ...
%               (d34 / d12 + d12 / d34 - 2.0);
%     quality = 1.0 / quality

    quality = dist41 * sin(angle1/180*pi) / Sp + dist23 * sin(angle2/180*pi) / Sp + ...
              abs( acos( abs(v12 * v41') / d12 / d41 ) / pi / 2.0 ) + ...
              abs( acos( abs(v12 * v23') / d12 / d23 ) / pi / 2.0 ) + ...
              d34 / d12;
    quality = quality / 5.0;    
          
end

end