function Sp = StepSize_new(AFT_stack_sorted, xCoord_AFT, yCoord_AFT, SpField, backGrid, backCoord)
node1_base = AFT_stack_sorted(1,1);         
node2_base = AFT_stack_sorted(1,2);
ds_base = DISTANCE( node1_base, node2_base, xCoord_AFT, yCoord_AFT);

node1_b = [ xCoord_AFT(node1_base), yCoord_AFT(node1_base)];
node2_b = [ xCoord_AFT(node2_base), yCoord_AFT(node2_base)];
mid0 = 0.5 * ( node1_b + node2_b );

xCoord = backCoord(:,1); yCoord = backCoord(:,2);

Sp = 0; dist = 0; 
for i=1:size(backGrid,1)
    node1In = backGrid(i,1);
    node2In = backGrid(i,2);
    
    node1 = [xCoord(node1In),yCoord(node1In)];
    node2 = [xCoord(node2In),yCoord(node2In)];
    
    mid1 = 0.5 * ( node1 + node2 );    
    vv = mid1 -mid0;
    dvv = sqrt( vv(1)^2 + vv(2)^2 );
    
    if  dvv > 5 * ds_base
        continue;
    end     

    dist = dist + ( 1.0 / ( dvv + 1e-40 ) );
    val = 0.5 * ( SpField(node1In) + SpField(node2In));
    Sp = Sp + val * ( 1.0 / ( dvv + 1e-40 ) );   %反距离加权
end
Sp = Sp / dist;
% [~, index] = sort(dvv);
% % Sp = mean( SpField(index(1:3)) );
% 
% Sp = 0; dist = 0;
% for i = 1:10
%     iNode = index(i);
%     Sp = Sp + SpField(iNode) * ( 1.0 / ( dvv(iNode) + 1e-7 ) );   %反距离加权
%     dist = dist + ( 1.0 / ( dvv(iNode) + 1e-7 ) );
% end
% Sp = Sp / dist;
end