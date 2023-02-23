function [x_new, y_new] = ADD_POINT_tri(AFT_stack, xCoord, yCoord, Sp, outGridType)
% global SpDefined;
if nargin == 4 
    outGridType = 0;
end
node1_base = AFT_stack(1,1);
node2_base = AFT_stack(1,2);

node1Coord = [xCoord(node1_base),yCoord(node1_base)];
node2Coord = [xCoord(node2_base),yCoord(node2_base)];

ds_base = DISTANCE(node1_base, node2_base, xCoord, yCoord);
normal = normal_vector(node1_base, node2_base, xCoord, yCoord);

% if SpDefined == 0
%     Sp = Sp * ds_base;
% end

if AFT_stack(1,7) == 3  %在物面上网格步长采用边界阵元长度的sqrt(3)/2
    Sp = ds_base * sqrt(3.0) / 2.0;
end

if outGridType == 0
    new_point = ( node1Coord + node2Coord ) / 2.0 + normal * Sp;
elseif outGridType == 1
    new_point = node2Coord + normal * Sp;
end

x_new = new_point(1);
y_new = new_point(2);
% plot(x_new, y_new,'*');
end