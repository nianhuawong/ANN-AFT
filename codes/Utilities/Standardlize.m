function input = Standardlize(input)
point1 = [input(1), input(5)];
point2 = [input(2), input(6)];
point3 = [input(3), input(7)];
point4 = [input(4), input(8)];

[input(1), input(5)] = Transform( point1, point2, point3 );
input(2) = 0.0; input(6) = 0;
input(3) = 1.0; input(7) = 0;
[input(4), input(8)] = Transform( point4, point2, point3 );
end