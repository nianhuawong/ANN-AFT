function quality = QualityCheckQuad_new(node1, node2, node3, node4, xCoord_AFT, yCoord_AFT)
if node4 <= 0 
    quality = QualityCheckTri_new(node1, node2, node3, xCoord_AFT, yCoord_AFT);
    return;
end

%% 另一种确定四边形网格质量的方法，如下
% % syms x y;
x1 = xCoord_AFT(node1);y1 = yCoord_AFT(node1);
x2 = xCoord_AFT(node2);y2 = yCoord_AFT(node2);
x3 = xCoord_AFT(node3);y3 = yCoord_AFT(node3);
x4 = xCoord_AFT(node4);y4 = yCoord_AFT(node4);
% % % solve((y-y1)/(y3-y1)-(x-x1)/(x3-x1),(y-y2)/(y4-y2)-(x-x2)/(x4-x2), x, y);
x = (x1*x2*y3 - x2*x3*y1 - x1*x2*y4 + x1*x4*y2 - x1*x4*y3 + x3*x4*y1 + x2*x3*y4 - x3*x4*y2)/(x1*y2 - x2*y1 - x1*y4 + x2*y3 - x3*y2 + x4*y1 + x3*y4 - x4*y3);
y = (x1*y2*y3 - x3*y1*y2 - x2*y1*y4 + x4*y1*y2 - x1*y3*y4 + x3*y1*y4 + x2*y3*y4 - x4*y2*y3)/(x1*y2 - x2*y1 - x1*y4 + x2*y3 - x3*y2 + x4*y1 + x3*y4 - x4*y3);

node5 = length(xCoord_AFT) + 1;
xCoord_tmp = [xCoord_AFT;x];
yCoord_tmp = [yCoord_AFT;y];

alpha1 = QualityCheckTri_new(node1, node2, node5, xCoord_tmp, yCoord_tmp);
alpha2 = QualityCheckTri_new(node2, node3, node5, xCoord_tmp, yCoord_tmp);
alpha3 = QualityCheckTri_new(node3, node4, node5, xCoord_tmp, yCoord_tmp);
alpha4 = QualityCheckTri_new(node4, node1, node5, xCoord_tmp, yCoord_tmp);
tmp = [alpha1,alpha2,alpha3,alpha4];
tmp = sort(tmp);
quality = tmp(1) * tmp(2) / tmp(3) / tmp(4);
end

function quality = QualityCheckTri_new(node1, node2, node3, xCoord_AFT, yCoord_AFT)

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
% r = 2.0 * area / ( ( a + b + c ) );                  %内切圆半径
% R = a * b * c / 4.0 / area + 1e-40;                  %外接圆半径  
% quality =   3.0 * r / R;

%% 三角形网格质量的另一种求法
quality = 4.0 * sqrt(3.0) * area / ( a * a + b * b + c * c );

end