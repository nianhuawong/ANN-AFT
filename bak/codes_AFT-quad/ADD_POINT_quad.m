function [x_new, y_new] = ADD_POINT_quad(AFT_stack, xCoord, yCoord, Sp)
node1 = AFT_stack(1,1);
node2 = AFT_stack(1,2);

node1Coord = [xCoord(node1),yCoord(node1)];
node2Coord = [xCoord(node2),yCoord(node2)];

dist = AFT_stack(1,5);

normal = zeros(1,2);
normal(1) = -( yCoord(node2) - yCoord(node1) ) / dist;
normal(2) =  ( xCoord(node2) - xCoord(node1) ) / dist;

new_point1 = node1Coord + normal * Sp * dist;
new_point2 = node2Coord + normal * Sp * dist;

x_new = [new_point1(1),new_point2(1)];
y_new = [new_point1(2),new_point2(2)];