function [x_new, y_new, Sp, mode, nodeIndex] = ADD_POINT_ANN_quad(nn_fun, AFT_stack, xCoord, yCoord, Grid_stack, stencilType, Sp )
global standardlize SpDefined epsilon tolerance;
node1 = AFT_stack(1,1);
node2 = AFT_stack(1,2);

mode = 0;
nodeIndex = [-1 -1];

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
    
    MM = length(neighborNode1);
    NN = length(neighborNode2);
    
    new_point = zeros(MM*NN,8);
    input_node = zeros(MM*NN,4);
    for i = 1:MM
        for j = 1:NN
            neighbor1 = neighborNode1(i);
            neighbor2 = neighborNode2(j);
            
            input_node((i-1)*NN+j,:) = [neighbor1, node1, node2, neighbor2];
            input = [xCoord(input_node((i-1)*NN+j,:)); yCoord(input_node((i-1)*NN+j,:))]';
            
            if standardlize == 1
                input = Standardlize(input);
            end
            
            new_point((i-1)*NN+j,:) = nn_fun(input);
%                 new_point(end+1,:) = nn_fun(input);       
        end
    end
    
    if standardlize == 1
        new_point(:,1:4) = AntiStandardlize( new_point(:,1:4), ...
            [xCoord(node1), yCoord(node1)], [xCoord(node2), yCoord(node2)]);
    end    
    
    out_pointX1 = sum(new_point(:,1)) / size(new_point,1);
    out_pointX2 = sum(new_point(:,2)) / size(new_point,1);
    out_pointY1 = sum(new_point(:,3)) / size(new_point,1);
    out_pointY2 = sum(new_point(:,4)) / size(new_point,1);
    
    x_new = [out_pointX1; out_pointX2];
    y_new = [out_pointY1; out_pointY2];
     
     if SpDefined == 2        
        Sp = sum(new_point(:,5)) / size(new_point,1);
        %     Sp = sum(new_point(:,5)) / size(new_point,1) * ds_base;
     end   
     
    modeArray = new_point(:,5:8);
    MIN = 1000; row = -1; col = -1;
    for i = 1:size(modeArray,1)
        [modeMIN, index]=min(abs(modeArray(i,:)-1));
        if modeMIN < MIN && modeMIN < tolerance
            row = i; 
            col = index;
            MIN = modeMIN;
        end        
    end
    
    if col == 2
        mode = 2;
        nodeIndex = [input_node(row,1),-1];
    elseif col == 3
        mode = 3;
        nodeIndex = [-1,input_node(row,4)];
    elseif col == 4
        mode = 4;
        nodeIndex = [input_node(row,1),input_node(row,4)];        
    else
        mode = 1;
    end    

else
    neighborNode1 = neighborNode1(1);
    neighborNode2 = neighborNode2(1);
%     neighborNode1 = neighborNode1(randi(length(neighborNode1),1,1));
%     neighborNode2 = neighborNode2(randi(length(neighborNode2),1,1));
    input_node = [neighborNode1, node1, node2, neighborNode2];    
    input = [xCoord(input_node); yCoord(input_node)]';
    if standardlize == 1
        input = Standardlize(input);
    end
    
    new_point = nn_fun(input');
    
     if standardlize == 1
        [new_point(1), new_point(3)] = AntiTransform( [new_point(1), new_point(3)],...
            [xCoord(node1), yCoord(node1)], [xCoord(node2), yCoord(node2)]);
        [new_point(2), new_point(4)] = AntiTransform( [new_point(2), new_point(4)],...
            [xCoord(node1), yCoord(node1)], [xCoord(node2), yCoord(node2)]);        
     end
     
    x_new = new_point(1:2);
    y_new = new_point(3:4); 
    
    if SpDefined == 2
        Sp = new_point(5);
        %     Sp = new_point(5) * ds_base;
    end    
end
%%

%plot(x_new,y_new,'*')

xCoord_tmp = [xCoord; x_new];
yCoord_tmp = [yCoord; y_new];
nodeNum = length(xCoord);
[quality1,~] = QualityCheckQuad(node1, node2, nodeNum+2, nodeNum+1, xCoord_tmp, yCoord_tmp, Sp);
[quality2,~] = QualityCheckQuad(node1, node2, nodeNum+1, nodeNum+2, xCoord_tmp, yCoord_tmp, Sp);
if quality2 > quality1 && quality2 > 0
    tmp = [x_new(1), y_new(1)];
    x_new(1) = x_new(2); y_new(1) = y_new(2);
    x_new(2) = tmp(1);   y_new(2) = tmp(2);
end

if abs(quality2) < 1e-8 && abs(quality1) < 1e-8
    flagConvexPoly = IsConvexPloygon(node1, node2, nodeNum+1, nodeNum+2, xCoord_tmp, yCoord_tmp);
    if flagConvexPoly == 1
        tmp = [x_new(1), y_new(1)];
        x_new(1) = x_new(2); y_new(1) = y_new(2);
        x_new(2) = tmp(1);   y_new(2) = tmp(2);
    end
end

quality = max(quality1,quality2);
%%
if quality < epsilon
    x_new = 0.5 * ( x_new(1) + x_new(2) );
    y_new = 0.5 * ( y_new(1) + y_new(2) );
    
%     ds = DISTANCE(node1, node2, xCoord, yCoord);
%     normal = normal_vector(node1, node2, xCoord, yCoord);
%     
%     v_ac = [x_new-xCoord(node1), y_new-yCoord(node1)];
%     %h = abs( v_ac * normal' );    
%     %Sp = max([h,Sp]);
%     %Sp = h;
%     
%     v_ab = [xCoord(node2) - xCoord(node1), yCoord(node2) - yCoord(node1)]./ds;
%     v_ad = ( v_ac * v_ab' ) .* v_ab;
%     v_de = Sp .* normal;
%     pointE = v_ad + v_de + [xCoord(node1), yCoord(node1)];
%     x_new = pointE(1);
%     y_new = pointE(2);
end
end
