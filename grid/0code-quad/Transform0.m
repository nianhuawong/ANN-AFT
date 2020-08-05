function [x_out, y_out] = Transform0( pointIn, refPoint1, refPoint2 )
x1 = refPoint1(1); y1 = refPoint1(2);
x2 = refPoint2(1); y2 = refPoint2(2);
xi = pointIn(1);   yi = pointIn(2);

AB = [ x2 - x1, y2 - y1 ];
dist = sqrt( ( x1 - x2 )^2 + ( y1 - y2 )^2 );
translate_vector = - refPoint1;
scale_factor = 1.0 / dist;

ab = AB ./ dist;
rotate_angle = -acos( ab * [1;0] ) * 180 / pi;

polyin = polyshape([x1 x2 xi],[y1 y2 yi]);
% plot(polyin);
% hold on;
% axis equal

poly_trans = translate(polyin,translate_vector);
% plot(poly_trans);

poly_scale = scale(poly_trans,scale_factor);
% plot(poly_scale);

poly_rotat = rotate(poly_scale,rotate_angle);
% plot(poly_rotat);

p1x = poly_rotat.Vertices(1,1); p1y = poly_rotat.Vertices(1,2);
p2x = poly_rotat.Vertices(2,1); p2y = poly_rotat.Vertices(2,2);
p3x = poly_rotat.Vertices(3,1); p3y = poly_rotat.Vertices(3,2);

edge12 = sqrt( ( p1x - p2x )^2 + ( p1y-p2y )^2 );
edge23 = sqrt( ( p3x - p2x )^2 + ( p3y-p2y )^2 );
edge13 = sqrt( ( p3x - p1x )^2 + ( p3y-p1y )^2 );

if abs( edge12 - 1.0 ) < 1e-15
    x_out = p3x;
    y_out = p3y;
elseif abs( edge13 - 1.0 ) < 1e-15
    x_out = p2x;
    y_out = p2y;
elseif abs( edge23 - 1.0 ) < 1e-15
    x_out = p1x;
    y_out = p1y;
end

end
