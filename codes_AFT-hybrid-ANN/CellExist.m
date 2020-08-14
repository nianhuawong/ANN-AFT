%[row, direction] = CellExist(331,324,323,452, cellNodeTopo)
function [row, direction] = CellExist(node1, node2, node3, node4, cellNodeTopo)
row = -1;
direction = 0;

searchCell = [node1 node2 node3 node4];
searchCell(searchCell<=0) = [];
searchCell = unique(searchCell);

for i =1:size(cellNodeTopo,1)
    iCell = cellNodeTopo(i,:);
    iCell(iCell<=0) = [];
    iCell = unique(iCell);
    
    if length(searchCell) == length(iCell) && length(iCell) == 3 && sum(searchCell==iCell) == 3
        row = i;
        direction = find(cellNodeTopo(i,:)==node1);
    elseif length(searchCell) == length(iCell) && length(iCell) == 4 && sum(searchCell==iCell) == 4
        row = i;
        direction = find(cellNodeTopo(i,:)==node1);
    end
end
end
        