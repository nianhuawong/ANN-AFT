function normal = normal_vector(node1_base, node2_base, xCoord, yCoord)
ds = DISTANCE(node1_base, node2_base, xCoord, yCoord) + 1e-40;
normal = zeros(1,2);
normal(1) = -( yCoord(node2_base) - yCoord(node1_base) ) / ds;
normal(2) =  ( xCoord(node2_base) - xCoord(node1_base) ) / ds;
end