function flagClose = IsPointClose2Edge(AFT_stack,faceCandidate, xCoord, yCoord, node_test, Sp)
flagClose = 0;
nFaces = size(faceCandidate,2);
node_t = [xCoord(node_test), yCoord(node_test)];
for i =1:nFaces
    iFace = faceCandidate(i);
    nodeIn1 = AFT_stack(iFace,1);
    nodeIn2 = AFT_stack(iFace,2);
    
    dd = DISTANCE( nodeIn1, nodeIn2, xCoord, yCoord);
    
    node1 = [xCoord(nodeIn1), yCoord(nodeIn1)];
    node2 = [xCoord(nodeIn2), yCoord(nodeIn2)];
    
    v_ac = node_t - node1;
    v_ab = node2  - node1;
    v_bc = node_t - node2;
    v_ba = - v_ab;
    
    d_ac = sqrt( v_ac(1)^2 + v_ac(2)^2 );
    d_ab = sqrt( v_ab(1)^2 + v_ab(2)^2 );
    d_bc = sqrt( v_bc(1)^2 + v_bc(2)^2 );
    
    angle = acos( v_ac * v_ab' / ( d_ac + 1e-40 ) / ( d_ab  + 1e-40 ) );   
    dist = d_ac * sin(angle);

    angle2 = acos( v_bc * v_ba' / ( d_bc + 1e-40 ) / ( d_ab  + 1e-40 ) );
    dist2 = d_bc * sin(angle2);
    
    if abs(dist-dist2)>1e-5
        kkk = 1;
    end
    if v_ac * v_ab' <=  0 || v_bc * v_ba' <= 0
        flagClose = 0;
    elseif dist / Sp < 0.3  && dist / dd < 0.3
        flagClose = 1;
%         plot(xCoord([nodeIn1,nodeIn2]),yCoord([nodeIn1,nodeIn2]),'r-')
%         plot(xCoord(node_test),yCoord(node_test),'*')
        break;
    end
end