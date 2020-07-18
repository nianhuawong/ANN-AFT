function PLOT_NEW_FRONT(AFT_stack, xCoord, yCoord, num)
for i = 1:num
    node1 = AFT_stack(end-i+1,1);
    node2 = AFT_stack(end-i+1,2);
    
%     node1Coord = [xCoord(node1),yCoord(node1)];
%     node2Coord = [xCoord(node2),yCoord(node2)];

    dist = DISTANCE(node1,node2,xCoord,yCoord);
    
    xx = [xCoord(node1),xCoord(node2)];
    yy = [yCoord(node1),yCoord(node2)];

    plot( xx, yy, '-b');
    hold on;
    
    text(xCoord(node1)+0.1*dist,yCoord(node1),num2str(node1), 'Color', 'red', 'FontSize', 14)
%     text(xCoord(node2)+0.1*dist,yCoord(node2),num2str(node2), 'Color', 'red', 'FontSize', 14)
end
axis equal

    
