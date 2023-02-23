function [quality,h] = QualityCheckTri(node1, node2, node3, xCoord_AFT, yCoord_AFT, Sp)

a = DISTANCE( node1, node2, xCoord_AFT, yCoord_AFT) + 1e-40;  
b = DISTANCE( node2, node3, xCoord_AFT, yCoord_AFT) + 1e-40;       
c = DISTANCE( node3, node1, xCoord_AFT, yCoord_AFT) + 1e-40;

tmp = ( a^2 + b^2 - c^2 ) / ( 2.0 * a * b );
if abs(tmp-1.0)<1e-5
    tmp = 1;
end

if abs(tmp+1.0) < 1e-5
    tmp = -1;
end

theta = acos( tmp );

area = 0.5 * a * b * sin(theta) + 1e-40;             %三角形面积
r = 2.0 * area / ( ( a + b + c ) );                  %内切圆半径
R = a * b * c / 4.0 / area + 1e-40;                  %外接圆半径  

quality =   3.0 * r / R;
 
v_13 = [xCoord_AFT(node3)-xCoord_AFT(node1), yCoord_AFT(node3)-yCoord_AFT(node1)];
normal = normal_vector(node1, node2, xCoord_AFT, xCoord_AFT); 
h = abs( v_13 * normal' );

% if Sp > 0 
    h = max([h,Sp]); 
% end

%% 三角形网格质量的另一种求法
quality = 4.0 * sqrt(3.0) * area / ( a * a + b * b + c * c );
end