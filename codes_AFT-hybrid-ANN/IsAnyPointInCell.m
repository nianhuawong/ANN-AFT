function flagInCell = IsAnyPointInCell(cellNodeTopo, xCoord, yCoord)
flagInCell = 0;
nNodes = length(xCoord);
for i = 1:nNodes-1
    flag = IsPointInCell(cellNodeTopo, xCoord, yCoord, i);
    if flag == 1
        flagInCell = 1;
        break;
    end
end