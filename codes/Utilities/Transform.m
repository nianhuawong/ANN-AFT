function [x_out, y_out] = Transform( pointIn, refPoint1, refPoint2 )
plotOrNot = 0;
x1 = refPoint1(1); y1 = refPoint1(2);
x2 = refPoint2(1); y2 = refPoint2(2);

AB = [ x2 - x1, y2 - y1 ];
dist = sqrt( ( x1 - x2 )^2 + ( y1 - y2 )^2 );
translate_vector = - refPoint1;
scale_factor = 1.0 / dist;

ab = AB ./ dist;
rotate_angle = - acos( ab * [1;0] ) * 180 / pi;
if ab(2) < 0 %与x轴的夹角可能是在第34象限
    rotate_angle = - rotate_angle;
end

if plotOrNot == 1
    PlotPolygon(pointIn, refPoint1, refPoint2, 'r*-');
end
%%
[x_trans, y_trans] = Translation(pointIn, translate_vector);
[x1, y1] = Translation(refPoint1, translate_vector);
[x2, y2] = Translation(refPoint2, translate_vector);
if plotOrNot == 1
    PlotPolygon([x_trans, y_trans], [x1, y1], [x2, y2], 'b+-');
end
%%
[x_scale, y_scale] = Scale([x_trans, y_trans], scale_factor, [x1, y1]);
[x2, y2] = Scale([x2, y2], scale_factor, [x1, y1]);
if plotOrNot == 1
    PlotPolygon([x_scale, y_scale], [x1, y1], [x2, y2], 'ko-');
end
%%
[x_out, y_out] = Rotate([x_scale, y_scale], rotate_angle, [x1, y1]);
[x2, y2] = Rotate([x2, y2], rotate_angle, [x1, y1]);
if plotOrNot == 1
    PlotPolygon([x_out, y_out], [x1, y1], [x2, y2], 'gx-');
end
end

function [x_trans, y_trans] = Translation(pointIn, translate_vector)
xi = pointIn(1); yi = pointIn(2);
x_trans = xi + translate_vector(1);
y_trans = yi + translate_vector(2);
end

function [x_scale, y_scale] = Scale(pointIn, scale_factor, refPoint)
v_AB = pointIn - refPoint;
d_AB = sqrt( v_AB(1)^2 + v_AB(2)^2 );
d_ab = d_AB * scale_factor;
v_ab = d_ab .* v_AB ./ d_AB;
pointOut = v_ab + refPoint;

x_scale = pointOut(1);
y_scale = pointOut(2);
end

function [x_rotate, y_rotate] = Rotate(pointIn, rotate_angle, refPoint)
rotate_angle = rotate_angle * pi / 180.0;

v_AB = pointIn - refPoint;
d_AB = sqrt( v_AB(1)^2 + v_AB(2)^2 );
v_ab = v_AB ./ d_AB;
theta = acos( v_ab * [1;0] );

if pointIn(2) < 0 %与x轴的夹角可能是在第34象限
    theta = - theta;
end

x_rotate = d_AB * cos( rotate_angle + theta );
y_rotate = d_AB * sin( rotate_angle + theta );
end

function PlotPolygon(pointIn, refPoint1, refPoint2, style)
x1 = refPoint1(1); y1 = refPoint1(2);
x2 = refPoint2(1); y2 = refPoint2(2);
xi = pointIn(1);   yi = pointIn(2);

plot([x1 x2],[y1 y2], style);
hold on;
axis equal
plot([x1 xi],[y1 yi], style);
plot([x2 xi],[y2 yi], style);
end