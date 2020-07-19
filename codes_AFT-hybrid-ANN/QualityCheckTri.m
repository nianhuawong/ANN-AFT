function [quality,h] = QualityCheckTri(node1, node2, node3, xCoord_AFT, yCoord_AFT, Sp)

a = DISTANCE( node1, node2, xCoord_AFT, yCoord_AFT) + 1e-40;  
b = DISTANCE( node2, node3, xCoord_AFT, yCoord_AFT) + 1e-40;       
c = DISTANCE( node3, node1, xCoord_AFT, yCoord_AFT) + 1e-40;
    
theta = acos( ( a^2 + b^2 - c^2 ) / ( 2.0 * a * b ) );
area = 0.5 * a * b * sin(theta) + 1e-40;             %���������
r = 2.0 * area / ( ( a + b + c ) );                  %����Բ�뾶
R = a * b * c / 4.0 / area + 1e-40;                  %���Բ�뾶  

quality =   3.0 * r / R;
 
v_13 = [xCoord_AFT(node3)-xCoord_AFT(node1), yCoord_AFT(node3)-yCoord_AFT(node1)];
normal = normal_vector(node1, node2, xCoord_AFT, xCoord_AFT); 
h = abs( v_13 * normal' );

if Sp > 0 
    h = max([h,Sp]); 
end

end