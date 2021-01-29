% PLOT_FRONT(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, 1)
function PLOT_FRONT(AFT_stack, xCoord, yCoord, fronts)
for i = 1:length(fronts)
    iFront = fronts(i);
    node1 = AFT_stack(iFront,1);
    node2 = AFT_stack(iFront,2);
    
    xx = [xCoord(node1),xCoord(node2)];
    yy = [yCoord(node1),yCoord(node2)];
    
    plot( xx, yy, 'b-');    
    hold on;
end