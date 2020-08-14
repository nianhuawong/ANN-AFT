function flagClose = IsEdgeClose2Point(AFT_stack, edge, xCoord, yCoord, node_ex)
flagClose = 0;
nNodes = length(xCoord);
edgeIn1 = edge(1);
edgeIn2 = edge(2);

frontNodes = unique( AFT_stack(:,1:2) );

node_a = [xCoord(edgeIn1), yCoord(edgeIn1)];
node_b = [xCoord(edgeIn2), yCoord(edgeIn2)];

for i = 1:nNodes
    if i == edgeIn1 || i == edgeIn2 || sum( node_ex == i )~= 0 || sum( frontNodes == i ) == 0 
        continue;
    end
    
    node_t = [xCoord(i), yCoord(i)];
    v_ac = node_t - node_a;
    v_ab = node_b - node_a;
    v_bc = node_t - node_b;
    v_ba = - v_ab;
    
    d_ac = sqrt( v_ac(1)^2 + v_ac(2)^2 );
    d_ab = sqrt( v_ab(1)^2 + v_ab(2)^2 );
    d_bc = sqrt( v_bc(1)^2 + v_bc(2)^2 );   
    
    angle1 = acos( v_ac * v_ab' / ( d_ac + 1e-40 ) / ( d_ab  + 1e-40 ) );   
    dist1 = d_ac * sin(angle1);

    angle2 = acos( v_bc * v_ba' / ( d_bc + 1e-40 ) / ( d_ab  + 1e-40 ) );
    dist2 = d_bc * sin(angle2);
    
    if abs(dist1-dist2)>1e-5
        kkk = 1;
    end   
    
    if v_ac * v_ab' <=  0 || v_bc * v_ba' <= 0
        flagClose = 0;
    elseif dist1 * 3.0 / ( d_ab + d_ac + d_bc ) < 0.3
        flagClose = 1;
%         plot(xCoord(edge),yCoord(edge),'r-')
%         plot(xCoord(i),yCoord(i),'*')
        break;
    end   
end

end