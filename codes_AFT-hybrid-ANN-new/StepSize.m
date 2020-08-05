function Sp = StepSize(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, Grid)

node1_base = AFT_stack_sorted(1,1);         %阵面的基准点
node2_base = AFT_stack_sorted(1,2);

Coord = [xCoord_AFT, yCoord_AFT];


x1 = xCoord_AFT(node1_base);
y1 = yCoord_AFT(node1_base);

x2 = xCoord_AFT(node2_base);
y2 = yCoord_AFT(node2_base);

mid_x = 0.5 * ( x1 + x2 );
mid_y = 0.5 * ( y1 + y2 );

wdist = ComputeWallDistOfNode(Grid, Coord, mid_x, mid_y);

sp1 = 0.5;
sp2 = 1.0;
a = (sp2 - sp1) / 9.0;
b = sp1 - a;

% if ds <=3
    Sp = a * wdist + b;
% end

end