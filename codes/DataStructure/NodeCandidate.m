function nodeCandidate = NodeCandidate(AFT_stack, node1_base, node2_base, xCoord, yCoord, Point, radius)
nodeCandidate = zeros(1,1000);
count = 0;
x_best = Point(1);
y_best = Point(2);
for i = 2:size(AFT_stack,1)
    node1 = AFT_stack(i,1);
    node2 = AFT_stack(i,2);
    x_p1 = xCoord(node1);
    y_p1 = yCoord(node1);
    
    x_p2 = xCoord(node2);
    y_p2 = yCoord(node2);
    
    if( (x_p1-x_best)^2 + (y_p1-y_best)^2 < radius * radius &&  node1 ~= node1_base && node1 ~= node2_base)
        count = count + 1;
        nodeCandidate(count) = node1;
    end
    
    if( (x_p2-x_best)^2 + (y_p2-y_best)^2 < radius * radius &&  node2 ~= node1_base && node2 ~= node2_base)
        count = count + 1;
        nodeCandidate(count) = node2;
    end
end

% nodeCandidate( nodeCandidate == 0 ) = [];
nodeCandidate( count+1:end ) = [];
nodeCandidate = unique(nodeCandidate);