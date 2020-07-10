function [x_new, y_new] = ADD_POINT_ANN_quad(nn_fun, AFT_stack, xCoord, yCoord, Grid_stack, stencilType)
node1 = AFT_stack(1,1);
node2 = AFT_stack(1,2);

xNode = 0.5 * ( xCoord(node1) + xCoord(node2) );
yNode = 0.5 * ( yCoord(node1) + yCoord(node2) );
Coord = [xCoord,yCoord];
% wdist = ComputeWallDistOfNode(AFT_stack, Coord, xNode, yNode);

neighborNode1 = NeighborNodes(node1, AFT_stack, node2);
neighborNode2 = NeighborNodes(node2, AFT_stack, node1);

if strcmp(stencilType, 'all')
    tmp1 = NeighborNodes(node1, Grid_stack, node2);
    tmp2 = NeighborNodes(node2, Grid_stack, node1);
    
    neighborNode1 = [neighborNode1, tmp1];
    neighborNode2 = [neighborNode2, tmp2];
    
    neighborNode1 = unique(neighborNode1);
    neighborNode2 = unique(neighborNode2);
    
    new_point = [];
    for i = 1:length(neighborNode1)
        neighborNode11 = neighborNode1(i);
        for j = 1:length(neighborNode2)
            neighborNode22 = neighborNode2(j);
            input_node = [neighborNode11, node1, node2, neighborNode22];
            % input = [xCoord(input_node); yCoord(input_node);wdist]';
            input = [xCoord(input_node); yCoord(input_node)]';
            new_point(end+1,:) = nn_fun(input);
        end
    end
    
%     out_pointX = sum(new_point(:,1)) / size(new_point,1);
%     out_pointY = sum(new_point(:,2)) / size(new_point,1);
%     x_new = out_pointX;
%     y_new = out_pointY;   
    
    out_pointX1 = sum(new_point(:,1)) / size(new_point,1);
    out_pointX2 = sum(new_point(:,2)) / size(new_point,1);
    out_pointY1 = sum(new_point(:,3)) / size(new_point,1);
    out_pointY2 = sum(new_point(:,4)) / size(new_point,1);
    
    x_new = [out_pointX1, out_pointX2];
    y_new = [out_pointY1, out_pointY2];
else
    neighborNode1 = neighborNode1(1);
    neighborNode2 = neighborNode2(1);
    input_node = [neighborNode1, node1, node2, neighborNode2];
    
    % input = [xCoord(input_node); yCoord(input_node);wdist]';
    input = [xCoord(input_node); yCoord(input_node)]';
    
    new_point = nn_fun(input);
%     x_new = new_point(1);
%     y_new = new_point(2); 
    x_new = new_point(1:2);
    y_new = new_point(3:4);    

end
