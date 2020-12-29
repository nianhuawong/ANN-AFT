function [xCoord,yCoord] = SpringOptimize_new(Grid_stack,xCoord_old,yCoord_old,wallNodes,times)
nNodes = length(xCoord_old);
xCoord = zeros(nNodes,1);
yCoord = zeros(nNodes,1);

figure;
for NN = 1:times
    for i = 1:nNodes
        if sum(wallNodes == i) ~= 0 
            xCoord(i) = xCoord_old(i);
            yCoord(i) = yCoord_old(i);
            continue;
        else       
            neighbors = NeighborNodes(i,Grid_stack,-1);%% 确定点相邻的点
            nn = length(neighbors);
            xCoord_tmp = 0; yCoord_tmp = 0;
            for j =1:nn
                node = neighbors(j);
                xCoord_tmp = xCoord_old(node) + xCoord_tmp;
                yCoord_tmp = yCoord_old(node) + yCoord_tmp;
            end
            xCoord(i) = xCoord_tmp / nn;
            yCoord(i) = yCoord_tmp / nn;
        end
        xCoord_old(i) = xCoord(i);%更新点i坐标后，立马采用新坐标进行后续更新
        yCoord_old(i) = yCoord(i);
    end
    xCoord_old = xCoord; 
    yCoord_old = yCoord; 
    
    clf;
    PLOT(Grid_stack, xCoord, yCoord)
    pause(0.5)
end
end