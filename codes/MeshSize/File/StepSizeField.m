function [SpField, Grid_stack, Coord] = StepSizeField(gridFile,gridType)

[Grid_stack, Coord]  = read_grid(gridFile, gridType);
xCoord = Coord(:,1); yCoord = Coord(:,2);
nFaces = size(Grid_stack,1);
SpField = zeros(1,nFaces);

% PLOT(Grid_stack, xCoord, yCoord);

if gridType == 0
    targetPoint = TargetPointOfFrontTri(Grid_stack);
    for i=1:nFaces
%         PLOT_FRONT(Grid_stack, xCoord, yCoord, 1)
        node1In = Grid_stack(i,1);
        node2In = Grid_stack(i,2);
        target = targetPoint(i);
        
        normal = normal_vector(node1In, node2In, xCoord, yCoord);
        v_ac = [xCoord(target)-xCoord(node1In), yCoord(target)-yCoord(node1In)];
        
        SpField(i) = abs( v_ac * normal' );
    end
elseif gridType == 1
    targetPoint = TargetPointOfFrontQuad(Grid_stack);
    for i=1:nFaces
        node1In = Grid_stack(i,1);
        node2In = Grid_stack(i,2);
        node3In = targetPoint(i,2);
        node4In = targetPoint(i,1);
        
        node1 = [ xCoord(node1In), yCoord(node1In) ];
        node2 = [ xCoord(node2In), yCoord(node2In) ];
        node3 = [ xCoord(node3In), yCoord(node3In) ];
        node4 = [ xCoord(node4In), yCoord(node4In) ];
        
        area = AreaQuadrangle(node1, node2, node3, node4);        
        SpField(i) = sqrt(area);
    end
end
end