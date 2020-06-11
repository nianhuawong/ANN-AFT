function [x_new, y_new] = ADD_POINT(AFT_stack, xCoord, yCoord, Sp, outGridType)
node1 = AFT_stack(1,1);
node2 = AFT_stack(1,2);

node1Coord = [xCoord(node1),yCoord(node1)];
node2Coord = [xCoord(node2),yCoord(node2)];

dist = AFT_stack(1,5);

normal = zeros(1,2);
normal(1) = -( yCoord(node2) - yCoord(node1) ) / dist;
normal(2) =  ( xCoord(node2) - xCoord(node1) ) / dist;

if outGridType == 0
    new_point = ( node1Coord + node2Coord ) / 2.0 + normal * Sp * dist;
elseif outGridType == 1
    new_point = node2Coord + normal * Sp * dist;
end

x_new = new_point(1);
y_new = new_point(2);