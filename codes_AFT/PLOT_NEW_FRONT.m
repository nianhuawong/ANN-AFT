function PLOT_NEW_FRONT(AFT_stack, xCoord, yCoord, num, flag_best)
global flag_label;
global num_label;

for i = 1:num
    node1 = AFT_stack(end-i+1,1);
    node2 = AFT_stack(end-i+1,2);
    
%     node1Coord = [xCoord(node1),yCoord(node1)];
%     node2Coord = [xCoord(node2),yCoord(node2)];

    dist = DISTANCE(node1,node2,xCoord,yCoord);
    
    xx = [xCoord(node1),xCoord(node2)];
    yy = [yCoord(node1),yCoord(node2)];

    if flag_best == 1
%         plot( xx, yy, '.r-','MarkerSize',14);
        plot( xx, yy, 'r-');
    else
%         plot( xx, yy, '.r-','MarkerSize',14);
        plot( xx, yy, 'b-');
    end
    hold on;
    
    if flag_label(node1) == 0 && num_label == 1
        text(xCoord(node1)+0.05*dist,yCoord(node1),num2str(node1), 'Color', 'red', 'FontSize', 9)
        flag_label(node1) = 1;
    end
    if flag_label(node2) == 0 && num_label == 1
        text(xCoord(node2)+0.05*dist,yCoord(node2),num2str(node2), 'Color', 'red', 'FontSize', 9)
        flag_label(node2) = 1;
    end
end
% axis equal
axis off;
hold on;
pause(0.000001);
    
