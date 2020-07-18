% PLOT_NODES(xCoord_AFT, yCoord_AFT, -1)
function PLOT_NODES(xCoord, yCoord, nodes)
global flag_label;
if nodes == -1 
    nodes = length(xCoord);
end
for i= 1:nodes
    plot(xCoord(i),yCoord(i),'r.')
    if flag_label(i) == 0
        text(xCoord(i),yCoord(i),num2str(i), 'Color', 'red', 'FontSize', 9)
        flag_label(i) = 1;
    end
end

% for i= nodes
%     plot(xCoord(i),yCoord(i),'r.')    
%     text(xCoord(i),yCoord(i),num2str(i), 'Color', 'red', 'FontSize', 9)    
% end

