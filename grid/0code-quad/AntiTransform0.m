function [x_out, y_out] = AntiTransform0( pointIn, refPoint1, refPoint2 )
x1 = refPoint1(1); y1 = refPoint1(2);
x2 = refPoint2(1); y2 = refPoint2(2);
xi = pointIn(1);   yi = pointIn(2);

AB = [ x2 - x1, y2 - y1 ];
dist = sqrt( ( x1 - x2 )^2 + ( y1 - y2 )^2 );
translate_vector = refPoint1;
scale_factor = dist;

ab = AB ./ dist;
rotate_angle = acos( ab * [1;0] ) * 180 / pi;

polyin = polyshape([0 1 xi],[0 0 yi]);
poly_rotat = rotate(polyin,rotate_angle);
poly_scale = scale(poly_rotat,scale_factor);
poly_trans = translate(poly_scale,translate_vector);

% plot(polyin);
% hold on;
% axis equal
% plot(poly_rotat);
% plot(poly_scale);
% plot(poly_trans);

p1x = poly_trans.Vertices(1,1); p1y = poly_trans.Vertices(1,2);
p2x = poly_trans.Vertices(2,1); p2y = poly_trans.Vertices(2,2);
p3x = poly_trans.Vertices(3,1); p3y = poly_trans.Vertices(3,2);

if p1x ~= x1 && p1y ~= y1 && p1x ~= x2 && p1y ~= y2
    x_out = p1x;
    y_out = p1y;
elseif p2x ~= x1 && p2y ~= y1 && p2x ~= x2 && p2y ~= y2
    x_out = p2x;
    y_out = p2y;
elseif p3x ~= x1 && p3y ~= y1 && p3x ~= x2 && p3y ~= y2
    x_out = p3x;
    y_out = p3y;
end
end
