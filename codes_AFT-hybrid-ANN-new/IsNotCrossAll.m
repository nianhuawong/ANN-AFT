function flag = IsNotCrossAll(node1_base, node2_base, node_select1, node_select2,...
                              frontCandidate, AFT_stack, faceCandidate, Grid_stack, ...
                              xCoord, yCoord)
    flag = 1;
                          
    flagNotCross1 = IsNotCross(node1_base, node2_base, node_select1, ...   %node1_base和node_select1
        frontCandidate, AFT_stack, xCoord, yCoord,1);
    if flagNotCross1 == 0
        flag = 0;
        return;
    end
    
    flagNotCross2 = IsNotCross(node1_base, node2_base, node_select1, ...   %node1_base和node_select1    
        faceCandidate, Grid_stack, xCoord, yCoord,1);
    if flagNotCross2 == 0
        flag = 0;
        return;
    end
    
    flagNotCross3 = IsNotCross(node1_base, node2_base, node_select2, ...   %node2_base和node_select2    
        frontCandidate, AFT_stack, xCoord, yCoord,2);
    if flagNotCross3 == 0
        flag = 0;
        return;
    end
    
    flagNotCross4 = IsNotCross(node1_base, node2_base, node_select2, ...   %node2_base和node_select2     
        faceCandidate, Grid_stack, xCoord, yCoord,2);
    if flagNotCross4 == 0
        flag = 0;
        return;
    end
    
    flagNotCross5 = IsNotCross(node_select1, node2_base, node_select2, ... %node_select1和node_select2         
        frontCandidate, AFT_stack, xCoord, yCoord,1);
    if flagNotCross5 == 0
        flag = 0;
        return;
    end
    
    flagNotCross6 = IsNotCross(node_select1, node2_base, node_select2, ...  %node_select1和node_select2        
        faceCandidate, Grid_stack, xCoord, yCoord,1);
    if flagNotCross6 == 0
        flag = 0;
        return;
    end
end