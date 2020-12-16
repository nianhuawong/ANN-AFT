function Sp = StepSize(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, SpField, backGrid, backCoord)
node1_base = AFT_stack_sorted(1,1);         
node2_base = AFT_stack_sorted(1,2);
% ds_base = DISTANCE( node1_base, node2_base, xCoord_AFT, yCoord_AFT);

node1_b = [ xCoord_AFT(node1_base), yCoord_AFT(node1_base)];
node2_b = [ xCoord_AFT(node2_base), yCoord_AFT(node2_base)];
mid0 = 0.5 * ( node1_b + node2_b );

% % wdist = ComputeWallDistOfNode(Grid, [xCoord_AFT, yCoord_AFT], mid0);
% sp1 = 0.15;
% sp2 = 1.0;
% a = (sp2 - sp1) / 10.0;
% b = sp1 - a;
% % if ds <=3
%     Sp = a * wdist + b;
% % end

xCoord = backCoord(:,1); yCoord = backCoord(:,2);
dvv = zeros(1,size(backGrid,1));
for i=1:size(backGrid,1)
    node1In = backGrid(i,1);
    node2In = backGrid(i,2);
    
    node1 = [xCoord(node1In),yCoord(node1In)];
    node2 = [xCoord(node2In),yCoord(node2In)];
    
    mid1 = 0.5 * ( node1 + node2 );
    
    vv = mid1 -mid0;
    dvv(i) = sqrt( vv(1)^2 + vv(2)^2 );
end
% [minv, Index] = min(dvv); 
% Sp = SpField(Index);

[~, index] = sort(dvv);
Sp = mean( SpField(index(1:3)) );
% Sp = mean( SpField(index(1:10)) );
end