function flag = IsNotCross(node1_base, node2_base, node_test, ...
    frontCandidate, AFT_stack_sorted, xCoord_AFT, yCoord_AFT,ii)
if node_test == -1 || node1_base == -1 || node2_base == -1
    flag = 0;
else   
    nFront = length(frontCandidate);
    flag = 1;
    
    node1_base_Coord = [xCoord_AFT(node1_base), yCoord_AFT(node1_base)];
    node2_base_Coord = [xCoord_AFT(node2_base), yCoord_AFT(node2_base)];
    node_test_Coord  = [xCoord_AFT(node_test),  yCoord_AFT(node_test)];
    
    for i = 1 : nFront
        iFront = frontCandidate(i);
        
        node1Front = AFT_stack_sorted(iFront,1);
        node2Front = AFT_stack_sorted(iFront,2);
        
        node1Front_Coord = [xCoord_AFT(node1Front), yCoord_AFT(node1Front)];
        node2Front_Coord = [xCoord_AFT(node2Front), yCoord_AFT(node2Front)];
        
        flag1 = 0;
        flag2 = 0;
        if( ii == 1)
            flag1 = IsCross(node1_base_Coord, node_test_Coord, node1Front_Coord, node2Front_Coord);
        elseif( ii == 2)
            flag2 = IsCross(node2_base_Coord, node_test_Coord, node1Front_Coord, node2Front_Coord);
        elseif( ii == 0 )
            flag1 = IsCross(node1_base_Coord, node_test_Coord, node1Front_Coord, node2Front_Coord);
            flag2 = IsCross(node2_base_Coord, node_test_Coord, node1Front_Coord, node2Front_Coord);
        end
        
        if(flag1 ~= 0 || flag2 ~= 0)
            flag = 0;
        end
    end
end
end

