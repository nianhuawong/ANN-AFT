function area = AreaTriangle(node1, node2, node3)
v12 = node2-node1;
d12 = sqrt(v12(1)^2+v12(2)^2);

v23 = node3-node2;
d23 = sqrt(v23(1)^2+v23(2)^2);

v13 = node3-node1;
d13 = sqrt(v13(1)^2+v13(2)^2);

tmp = (d12^2+d13^2-d23^2) / 2.0 / ( d12 + 1e-40 ) / ( d13 + 1e-40 );

if abs(tmp-1.0)<1e-5
    tmp = 1;
end

if abs(tmp+1.0) < 1e-5
    tmp = -1;
end

angle = acos( tmp );
area = 0.5 * d12 * d13 * sin(angle);

% if isnan(area)
%     area = 0;
% end