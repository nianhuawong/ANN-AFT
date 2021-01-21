function PLOT(AFT_stack, xCoord, yCoord)
global flag_label;
global num_label;

len = size(AFT_stack,1);
for i = 1:len
    node1 = AFT_stack(i,1);
    node2 = AFT_stack(i,2);
    
%     node1Coord = [xCoord(node1),yCoord(node1)];
%     node2Coord = [xCoord(node2),yCoord(node2)];
    dist = DISTANCE(node1,node2,xCoord,yCoord);
    
    xx = [xCoord(node1),xCoord(node2)];
    yy = [yCoord(node1),yCoord(node2)];

    plot( xx, yy, '-r');
    hold on;
    
    if flag_label(node1) == 0 && num_label == 1
        text(xCoord(node1)+0.05*dist,yCoord(node1)+0.05*dist,num2str(node1), 'Color', 'red', 'FontSize', 9)
        flag_label(node1) = 1;
    end
    if flag_label(node2) == 0 && num_label == 1
        text(xCoord(node2)+0.05*dist,yCoord(node2)+0.05*dist,num2str(node2), 'Color', 'red', 'FontSize', 9)
        flag_label(node2) = 1;
    end    
end

% nodeList = AFT_stack(:,1:2);
% nNodes = max( max(nodeList)-min(nodeList)+1 );
% for i = 1 : nNodes
%     str = num2str(i);
%     if  flag_label(i) == 0 && num_label == 1
%         text(xCoord(i)+0.05*dist,yCoord(i),str, 'Color', 'red', 'FontSize', 9)
%         flag_label(i) = 1;
%     end
% end

axis equal
axis off
end

    