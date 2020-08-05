function [x_new, y_new, Sp] = ADD_POINT_ANN(nn_fun, AFT_stack, xCoord, yCoord, Grid_stack, stencilType)
node1 = AFT_stack(1,1);
node2 = AFT_stack(1,2);
ds_base = DISTANCE( node1, node2, xCoord, yCoord);

% xNode = 0.5 * ( xCoord(node1) + xCoord(node2) );
% yNode = 0.5 * ( yCoord(node1) + yCoord(node2) );
% Coord = [xCoord,yCoord];
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
            input = Standardlize(input);
            
            new_point(end+1,:) = nn_fun(input');
        end
    end
    new_point(:,1:2) = AntiStandardlize( new_point(:,1:2), [xCoord(node1), yCoord(node1)], [xCoord(node2), yCoord(node2)]);      
    
    x_new = sum(new_point(:,1)) / size(new_point,1);
    y_new = sum(new_point(:,2)) / size(new_point,1);
%     Sp = sum(new_point(:,3)) / size(new_point,1);
    Sp = sum(new_point(:,3)) / size(new_point,1) * ds_base;
else
    neighborNode1 = neighborNode1(1);
    neighborNode2 = neighborNode2(1);
    input_node = [neighborNode1, node1, node2, neighborNode2];
    
    % input = [xCoord(input_node); yCoord(input_node);wdist]';
    input = [xCoord(input_node); yCoord(input_node)]';
    
    input = Standardlize(input);   
    new_point = nn_fun(input');  
    [new_point(1), new_point(2)] = AntiTransform( new_point(1:2), [xCoord(node1), yCoord(node1)], [xCoord(node2), yCoord(node2)]);  
    
    x_new = new_point(1);
    y_new = new_point(2);
%     Sp = new_point(3);
    Sp = new_point(3) * ds_base;
end
% plot( [xCoord(node1), xCoord(node2)], [yCoord(node1), yCoord(node2)], 'b-' );
% plot(x_new, y_new,'*');
%%
normal = zeros(1,2);
normal(1) = -( yCoord(node2) - yCoord(node1) ) / ds_base;
normal(2) =  ( xCoord(node2) - xCoord(node1) ) / ds_base;
v_ac = [x_new-xCoord(node1), y_new-yCoord(node1)];
h = abs( v_ac * normal' );

% % Sp = h;
Sp = max([h,Sp]);
% % Sp = 0.5 * ( Sp + h );

v_ab = [xCoord(node2) - xCoord(node1), yCoord(node2) - yCoord(node1)]./ds_base;
v_ad = ( v_ac * v_ab' ) .* v_ab;
v_de = Sp .* normal;
pointE = v_ad + v_de + [xCoord(node1), yCoord(node1)];
x_new = pointE(1);
y_new = pointE(2);
end

