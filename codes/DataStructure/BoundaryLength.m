function maxSp = BoundaryLength(Grid)
nFaces = size(Grid,1);
for iFace = 1:nFaces
    if Grid(iFace,7) == 9
       maxSp = Grid(iFace,5);
       break;
    end
end