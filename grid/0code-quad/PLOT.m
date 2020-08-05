function PLOT(AFT_stack, xCoord, yCoord)
len = size(AFT_stack,1);
for i = 1:len
    node1 = AFT_stack(i,1);
    node2 = AFT_stack(i,2);
    
%     node1Coord = [xCoord(node1),yCoord(node1)];
%     node2Coord = [xCoord(node2),yCoord(node2)];

    xx = [xCoord(node1),xCoord(node2)];
    yy = [yCoord(node1),yCoord(node2)];

    plot( xx, yy, 'r-');
    hold on;
end

% nodeList = AFT_stack(:,1:2);
% nNodes = max( max(nodeList)-min(nodeList)+1 );
% for i = 1 : nNodes
%     str = num2str(i);
%     text(xCoord(i)+0.1,yCoord(i),str, 'Color', 'red', 'FontSize', 14)
% end

axis equal
% hold off

    
