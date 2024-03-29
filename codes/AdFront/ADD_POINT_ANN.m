function [x_new, y_new, Sp, mode, nodeIndex] = ADD_POINT_ANN(nn_fun, AFT_stack, xCoord, yCoord, stencilType, Sp)
global standardlize SpDefined tolerance;
node1 = AFT_stack(1,1);
node2 = AFT_stack(1,2);
ds_base = DISTANCE( node1, node2, xCoord, yCoord);
nodeIndex = -1;

% xNode = 0.5 * ( xCoord(node1) + xCoord(node2) );
% yNode = 0.5 * ( yCoord(node1) + yCoord(node2) );
% Coord = [xCoord,yCoord];
% wdist = ComputeWallDistOfNode(Grid, Coord, [xNode, yNode]);

% neighborNode1 = NeighborNodes(node1, [Grid_stack;AFT_stack], node2);
% neighborNode2 = NeighborNodes(node2, [Grid_stack;AFT_stack], node1);

neighborNode1 = NeighborNodes(node1, AFT_stack, node2);
neighborNode2 = NeighborNodes(node2, AFT_stack, node1);

MM = length(neighborNode1);
NN = length(neighborNode2);

mode4flag = -1;
if strcmp(stencilType, 'all')
    new_point = zeros(MM*NN,5);
    input_node = zeros(MM*NN,4);
    for i = 1:MM
        for j = 1:NN
            neighbor1 = neighborNode1(i);
            neighbor2 = neighborNode2(j);
            
            if(neighbor1==neighbor2)
                mode4flag = neighbor1;
            end
            
            input_node((i-1)*NN+j,:) = [neighbor1, node1, node2, neighbor2];
            input = [xCoord(input_node((i-1)*NN+j,:)); yCoord(input_node((i-1)*NN+j,:))]';
            
            if standardlize == 1
                input = Standardlize(input);
            end
            new_point((i-1)*NN+j,:) = nn_fun(input);
            %                 new_point(end+1,:) = nn_fun(input);
        end
    end
    %%
    if standardlize == 1
        new_point(:,1:2) = AntiStandardlize( new_point(:,1:2), ...
            [xCoord(node1), yCoord(node1)], [xCoord(node2), yCoord(node2)]);
    end
    
    x_new = sum(new_point(:,1)) / size(new_point,1);
    y_new = sum(new_point(:,2)) / size(new_point,1);
    
%     if SpDefined == 2
%         Sp = sum(new_point(:,3)) / size(new_point,1);
%         %     Sp = sum(new_point(:,3)) / size(new_point,1) * ds_base;
%     end
    %%
    modeArray = new_point(:,3:5);
    MIN = 1000; row = -1; col = -1;
    for i = 1:size(modeArray,1)
        [modeMIN, index]=min(abs(modeArray(i,:)-1));
        if modeMIN < MIN %&& modeMIN < tolerance
            row = i;
            col = index;
            MIN = modeMIN;
        end
    end
    
    mode = -1;
    if(mode4flag>0)
        mode = 4;
        nodeIndex = mode4flag;
    elseif col == 2
        mode = 2;
        nodeIndex = input_node(row,1);
    elseif col == 3
        mode = 3;
        nodeIndex = input_node(row,4);
    elseif col == 1
        mode = 1;
    end
else
    neighbor1 = neighborNode1(1);
    neighbor2 = neighborNode2(1);
    
    if(neighbor1==neighbor2)
        mode4flag = neighbor1;
    end
    
    input_node = [neighbor1, node1, node2, neighbor2];
    input = [xCoord(input_node); yCoord(input_node)]';
    
    if standardlize == 1
        input = Standardlize(input);
    end
    
    new_point = nn_fun(input);
    
    if standardlize == 1
        [new_point(1), new_point(2)] = AntiTransform( [new_point(1), new_point(2)],...
            [xCoord(node1), yCoord(node1)], [xCoord(node2), yCoord(node2)]);
    end
    
    %     if SpDefined == 2
    %         Sp = new_point(3);
    %         %     Sp = new_point(3) * ds_base;
    %     end
    
    mode = -1;
    modeArray = new_point(3:5);
    [modeMIN, index]=min(abs(modeArray-1));
    %     if modeMIN < tolerance
    if(mode4flag>0)
        mode = 4;
        nodeIndex = mode4flag;
    elseif index == 2
        mode = 2;
        nodeIndex = neighbor1;
    elseif index == 3
        mode = 3;
        nodeIndex = neighbor2;
    elseif index == 1
        mode = 1;
    end
    %     end
    
    x_new = new_point(1);
    y_new = new_point(2);
end
% plot( [xCoord(node1), xCoord(node2)], [yCoord(node1), yCoord(node2)], 'b-' );
% plot(x_new, y_new,'*');
%%
normal = normal_vector(node1, node2, xCoord, yCoord);
v_ac = [x_new-xCoord(node1), y_new-yCoord(node1)];
h = abs( v_ac * normal' );

if AFT_stack(1,7) == 3  %在物面上网格步长采用边界阵元长度的sqrt(3)/2
    Sp = ds_base * sqrt(3.0) / 2.0;
end

% Sp = h;
% if AFT_stack(1,7) == 3 && SpDefined ~= 3
%     Sp = h;
% else
%     if SpDefined == 1 || SpDefined == 3
%
%     elseif SpDefined == 2
%         Sp = max([h,Sp]);
%         % Sp = h;
%     else
%         Sp = h;
%     end
% end

v_ab = [xCoord(node2) - xCoord(node1), yCoord(node2) - yCoord(node1)]./ds_base;
v_ad = ( v_ac * v_ab' ) .* v_ab;
v_de = Sp .* normal;
pointE = v_ad + v_de + [xCoord(node1), yCoord(node1)];
x_new = pointE(1);
y_new = pointE(2);
end

