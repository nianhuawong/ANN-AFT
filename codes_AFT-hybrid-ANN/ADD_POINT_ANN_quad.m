function [x_new, y_new, Sp] = ADD_POINT_ANN_quad(nn_fun, AFT_stack, xCoord, yCoord, Grid_stack, stencilType, epsilon )
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
%     neighborNode1 = neighborNode1(1);
%     neighborNode2 = neighborNode2(1);
    neighborNode1 = neighborNode1(randi(length(neighborNode1),1,1));
    neighborNode2 = neighborNode2(randi(length(neighborNode2),1,1));
    input_node = [neighborNode1, node1, node2, neighborNode2];
    
    % input = [xCoord(input_node); yCoord(input_node);wdist]';
    input = [xCoord(input_node); yCoord(input_node)]';
    
    new_point = nn_fun(input);
%     x_new = new_point(1);
%     y_new = new_point(2); 
    x_new = new_point(1:2);
    y_new = new_point(3:4); 
    Sp    = new_point(5);
end
%%
%     v_ad =   [x_new(2)-xCoord(node1), y_new(2)-yCoord(node1)];
%     v_cb = - [x_new(1)-xCoord(node2), y_new(1)-yCoord(node2)];
%     
%     dd1 = sqrt( v_ad(1)^2 + v_ad(2)^2 );
%     dd2 = sqrt( v_cb(1)^2 + v_cb(2)^2 );
%     angle = acos( v_ad * v_cb' / dd1 / dd2 );
%     Area = 0.5 * dd1 * dd2 * sin(angle);
%     h = sqrt(Area);
%     
%     Sp = max([h,Sp]);
    
%     mid = 0.5 * [x_new(1)+x_new(2), y_new(1)+y_new(2)];
    
%     plot(x_new,y_new,'*')
%     plot(mid(1),mid(2),'*')
    
%     v_new1 = [x_new(1)-mid(1), y_new(1)-mid(1)];
%     v_new2 = [x_new(2)-mid(2), y_new(2)-mid(2)];
%     v_new1 = Sp * v_new1;
%     v_new2 = Sp * v_new2;
%     
%     tmp = v_new1 + mid;
%     x_new(1) = tmp(1);
%     y_new(1) = tmp(2);
%     
%     tmp2 = v_new2 + mid;
%     x_new(2) = tmp2(1);
%     y_new(2) = tmp2(2); 
%  
%     plot(x_new,y_new,'*')
    
    xCoord_tmp = [xCoord; x_new'];
    yCoord_tmp = [yCoord; y_new'];
    nodeNum = length(xCoord);
    [quality,~] = QualityCheckQuad(node1, node2, nodeNum+1, nodeNum+2, xCoord_tmp, yCoord_tmp, Sp);
    
if abs( quality - 1.0 ) > epsilon          
    %%
    v_base = [xCoord(node2)-xCoord(node1), yCoord(node2)-yCoord(node1)];
    v_newpoint = [x_new(2)-x_new(1), y_new(2)-y_new(1)];
    
    dd1 = sqrt( v_base(1)^2 + v_base(2)^2 );
    dd2 = sqrt( v_newpoint(1)^2 + v_newpoint(2)^2 );
    angle = acos( v_base * v_newpoint'/ dd1 / dd2 );
    angle = angle / pi * 180;
    
%     if  dd2 / dd1 < 0.2 || abs( ( abs(angle) - 90 ) ) < 30 || abs(h-Sp)/h > 0.2
        x_new = 0.5 * ( x_new(1) + x_new(2) );
        y_new = 0.5 * ( y_new(1) + y_new(2) );
        
        ds = DISTANCE(node1, node2, xCoord, yCoord);
        normal = normal_vector(node1, node2, xCoord, yCoord);
        
        v_ac = [x_new-xCoord(node1), y_new-yCoord(node1)];
        h = abs( v_ac * normal' );
        
        Sp = max([h,Sp]);
        
        v_ab = [xCoord(node2) - xCoord(node1), yCoord(node2) - yCoord(node1)]./ds;
        v_ad = ( v_ac * v_ab' ) .* v_ab;
        v_de = Sp .* normal;
        pointE = v_ad + v_de + [xCoord(node1), yCoord(node1)];
        x_new = pointE(1);
        y_new = pointE(2);
%     end
end


