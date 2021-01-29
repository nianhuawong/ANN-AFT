function [x_new, y_new,d] = ADD_POINT_quad(AFT_stack, xCoord, yCoord, Sp)
global epsilon;
% theta1 = 110;
theta1 = 120;
theta2 = 200;

node1 = AFT_stack(1,1);
node2 = AFT_stack(1,2);

A = [xCoord(node1),yCoord(node1)];
B = [xCoord(node2),yCoord(node2)];

neighborNode1 = NeighborNodes(node1, AFT_stack, node2);
neighborNode2 = NeighborNodes(node2, AFT_stack, node1);

C = [xCoord(neighborNode1(1)),yCoord(neighborNode1(1))];
D = [xCoord(neighborNode2(1)),yCoord(neighborNode2(1))];

AC = C - A;
AB = B - A;
BD = D - B;

ds_AB = DISTANCE(node1, node2, xCoord, yCoord);
ds_AC = sqrt( AC(1)^2 + AC(2)^2 );
ds_BD = sqrt( BD(1)^2 + BD(2)^2 );
%%
dref = 0.5 * ( ds_AB + DISTANCE(1, 2, [A(1), C(1)], [A(2), C(2)]) );
d = min(1.25*ds_AB, max([0.8*ds_AB, Sp, dref]));
% d = Sp;
% d = min(1.25*ds_AB, max(0.8*ds_AB,Sp));
%%
theta = acos( AB * AC' / ds_AB / ds_AC ) * 180 / pi;
theta = real(theta);

flagLeftCell = IsLeftCell(node1, node2, neighborNode1(1), xCoord, yCoord);
if flagLeftCell == 0
   theta = 360 - theta;
end
    
if theta < theta1 
    x_new1 = C(1);
    y_new1 = C(2);
elseif theta1 <= theta && theta < theta2
    normal = normal_vector(1, 2, [C(1),B(1)], [C(2),B(2)]);
    tmp = A + normal .* d;
    x_new1 = tmp(1);
    y_new1 = tmp(2);
elseif theta >= theta2
    normal = normal_vector(node1, node2, xCoord, yCoord);
    tmp = A + normal .* d;
    x_new1 = tmp(1);
    y_new1 = tmp(2);    
end
%%
dref = 0.5 * ( ds_AB + DISTANCE(1, 2, [B(1), D(1)], [B(2), D(2)]) );
d = min(1.25*ds_AB, max([0.8*ds_AB, Sp, dref]));
% d = Sp;
%%
theta = acos( -AB * BD' / ds_AB / ds_BD ) * 180 / pi;
theta = real(theta);

flagLeftCell = IsLeftCell(node1, node2, neighborNode2(1), xCoord, yCoord);
if flagLeftCell == 0
   theta = 360 - theta;
end

if theta < theta1 
    x_new2 = D(1);
    y_new2 = D(2);
elseif theta1 <= theta && theta < theta2
    normal = normal_vector(1, 2, [A(1),D(1)], [A(2),D(2)]);
    tmp = B + normal .* d;
    x_new2 = tmp(1);
    y_new2 = tmp(2);
elseif theta >= theta2
    normal = normal_vector(node1, node2, xCoord, yCoord);
    tmp = B + normal .* d;
    x_new2 = tmp(1);
    y_new2 = tmp(2);    
end
x_new = [x_new1;x_new2];
y_new = [y_new1;y_new2];

xCoord_tmp = [xCoord; x_new];
yCoord_tmp = [yCoord; y_new];
nodeNum = length(xCoord);
[quality,~]=QualityCheckQuad(node1, node2, nodeNum+2, nodeNum+1, xCoord_tmp, yCoord_tmp, d);
if quality < epsilon
    x_new = 0.5 * ( x_new(1) + x_new(2) );
    y_new = 0.5 * ( y_new(1) + y_new(2) );
end

%plot(x_new, y_new,'bx');
% hold on;
   