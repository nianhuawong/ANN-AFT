function [input, output] = StepSizeField(gridFile,gridType,sampleType)

[~,Coord, Grid_stack, ~]  = read_grid(gridFile, gridType);
xCoord = Coord(:,1); yCoord = Coord(:,2);
nFaces = size(Grid_stack,1);

if sampleType == 1
    input  = zeros(nFaces,2);
elseif sampleType == 2
    input  = zeros(nFaces,1);
elseif sampleType == 3
    input  = zeros(nFaces,1);
end
output = zeros(nFaces,1);

% PLOT(Grid_stack, xCoord, yCoord);
maxWdist = ComputeMaxWallDist(Grid_stack, Coord);
if gridType == 0
    targetPoint = TargetPointOfFrontTri(Grid_stack);
    for iFace=1:nFaces
        node1In = Grid_stack(iFace,1);
        node2In = Grid_stack(iFace,2);
        target = targetPoint(iFace);
        
        normal = normal_vector(node1In, node2In, xCoord, yCoord);
        v_ac = [xCoord(target)-xCoord(node1In), yCoord(target)-yCoord(node1In)];
        Sp = abs( v_ac * normal' );
        
        xmid = 0.5 * ( xCoord(node1In) + xCoord(node2In) );%此处也可以用形心坐标
        ymid = 0.5 * ( yCoord(node1In) + yCoord(node2In) );
        bc = 3;
        [wdist,index] = ComputeWallDistOfFace(iFace, Grid_stack, Coord, bc);
        bc = 9;
        [wdist2,index2] = ComputeWallDistOfFace(iFace, Grid_stack, Coord, bc);      
        %PLOT_FRONT(Grid_stack, xCoord, yCoord, index)
     
        if sampleType == 1 
            input(iFace,1) = xmid; 
            input(iFace,2) = ymid;
            output(iFace,1)= Sp/Grid_stack(index2,5);
        elseif sampleType == 2             
            input(iFace,1) = (wdist)^(1.0/6);
%             output(iFace,1)=  (Sp/Grid_stack(index2,5))^(1.0/6);
            output(iFace,1)= ( Sp / (Grid_stack(index,5)^(1.0/6)) )^(1.0/6);
%             input(iFace,1) = log10(wdist+1e-10);
%             output(iFace,1)= log10( Sp / Grid_stack(index2,5) );
        elseif sampleType == 3
%             input(iFace,1) = log10( wdist + 1e-10 );
%             input(iFace,2) = log10( Grid_stack(index,5) ); 
%             input(iFace,2) = Grid_stack(index,5)^(1.0/5);
%             output(iFace,1)= log10( Sp / Grid_stack(index,5) );
%             input(iFace,3) = ( wdist2 + 1e-10 )^(1.0/5);
%             input(iFace,3) = Grid_stack(index2,5)^(1.0/6);

            input(iFace,1) = ((wdist)/maxWdist)^(1.0/6);
%             input(iFace,2) = Grid_stack(index,5)^(1.0/6);  
%             input(iFace,3) = (( wdist2 + 1e-10)/maxWdist )^(1.0/20);
            
            term1 = 1.0/Grid_stack(index,5 )^(1.0/6);
            term2 = 1.0/Grid_stack(index2,5)^(1.0/1);
%             output(iFace,1) = ( Sp * ( term1 + term2 ) )^(1.0/6);
            
            if wdist > 0.25 * maxWdist
                output(iFace,1) = ( Sp * term2 )^(1.0/6);
            else
                output(iFace,1) = ( Sp * ( term1 + term2 ) )^(1.0/6);
%                 output(iFace,1) = ( Sp * ( term1 ) )^(1.0/6);
            end
        end
    end
%     input(:,1) = input(:,1) / max(input(:,1));
elseif gridType == 1
    targetPoint = TargetPointOfFrontQuad(Grid_stack);
    for iFace=1:nFaces
        node1In = Grid_stack(iFace,1);
        node2In = Grid_stack(iFace,2);
        node3In = targetPoint(iFace,2);
        node4In = targetPoint(iFace,1);
        
        node1 = [ xCoord(node1In), yCoord(node1In) ];
        node2 = [ xCoord(node2In), yCoord(node2In) ];
        node3 = [ xCoord(node3In), yCoord(node3In) ];
        node4 = [ xCoord(node4In), yCoord(node4In) ];
        
        area = AreaQuadrangle(node1, node2, node3, node4);        
        Sp = sqrt(area);
        
        input(iFace,1) = 0.5 * ( xCoord(node1In) + xCoord(node2In) );
        input(iFace,2) = 0.5 * ( yCoord(node1In) + yCoord(node2In) );
        output(iFace,1)= Sp; 
        
        if sampleType == 2
            bc = 3;
            [wdist,index] = ComputeWallDistOfFace(iFace, Grid_stack, Coord, bc);
            input(iFace,3) = wdist;
            input(iFace,4) = Grid_stack(index,5);
        elseif sampleType == 3
            bc = 3;
            [wdist,index] = ComputeWallDistOfFace(iFace, Grid_stack, Coord, bc);
            input(iFace,3) = wdist;
            input(iFace,4) = Grid_stack(index,5);
            
            bc = 9;
            [wdist2,index2] = ComputeWallDistOfFace(iFace, Grid_stack, Coord, bc);
            input(iFace,5) = wdist2;
            input(iFace,6) = Grid_stack(index2,5);                     
        end        
    end
end
end