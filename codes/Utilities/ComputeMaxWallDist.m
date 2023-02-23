function maxWdist = ComputeMaxWallDist(Grid, Coord)
xCoord = Coord(:,1);
yCoord = Coord(:,2);
nFaces = size(Grid,1);
maxWdist = 0;
for iFace1 = 1:nFaces
    if Grid(iFace1,7) == 9
%         PLOT_FRONT(Grid, xCoord, yCoord, iFace1);
        node1 = Grid(iFace1,1);
        node2 = Grid(iFace1,2);
        node11 = 0.5 * [ xCoord(node1) + xCoord(node2), ...
                         yCoord(node1) + yCoord(node2)];
        for iFace2 = 1:nFaces
            if Grid(iFace2,7) == 9
%                 PLOT_FRONT(Grid, xCoord, yCoord, iFace2);
                node3 = Grid(iFace2,1);
                node4 = Grid(iFace2,2);
                node22 = 0.5 * [ xCoord(node3) + xCoord(node4), ...
                                 yCoord(node3) + yCoord(node4)];   
                node = node22 - node11;
                wdt = sqrt( node(1)^2 + node(2)^2 );            
                if wdt > maxWdist
                    maxWdist = wdt;
                    index = [iFace1, iFace2];
                end
            end
        end
    end
end
maxWdist = 0.5 * maxWdist;
end