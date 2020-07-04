dimension       = hex2dec(grid(4,2));
nNodes          = hex2dec(grid(6,4));
nFaces          = hex2dec(grid(10,4));
nCells          = hex2dec(grid(14,4));
%%
%读入节点坐标
xCoord = zeros(nNodes,1);
yCoord = zeros(nNodes,1);
for i = 0:nNodes-1
    xCoord(i+1) = grid(17+i,1);
    yCoord(i+1) = grid(17+i,2);
end
% plot(xCoord,yCoord,'x');
% axis equal
% hold on;
%%
% 读入face信息，两个节点编号，左右单元编号
facePos =[];
for i = 1:size(grid,1)
    if(grid(i,1)=="(13")
        facePos = [facePos, i]; 
    end
end

node1 = zeros(nFaces,1);
node2 = zeros(nFaces,1);
leftCell    = zeros(nFaces,1);
rightCell   = zeros(nFaces,1);

count = 0;
for j = 2 : length(facePos)
    N = facePos(j);
    nFaces1 = hex2dec(grid(N,4))- hex2dec(grid(N,3)) + 1;
    for i = 1: nFaces1
        if gridType == 0
        %以下针对纯三角形或四边形网格
            node1(i+count) = hex2dec(grid(N+i,1));
            node2(i+count) = hex2dec(grid(N+i,2));
            leftCell(i+count) = hex2dec(grid(N+i,3));
            rightCell(i+count) = hex2dec(grid(N+i,4));
        elseif gridType == 1
        %以下针对混合网格
            node1(i+count) = hex2dec(grid(N+i,2));
            node2(i+count) = hex2dec(grid(N+i,3));
            leftCell(i+count) = hex2dec(grid(N+i,4));
            rightCell(i+count) = hex2dec(grid(N+i,5));
        end
    end
    count = count + nFaces1;
end

    for j = 1:nFaces            %寻找该node对应的face
        if node1(j) == node1InFace      %找到该面
            neighborNode1 = [neighborNode1,node2(j)];    %找到该面的第二个点
        end
        
        if node2(j) == node1InFace       %找到该面
             neighborNode1 = [neighborNode1,node1(j)];    %找到该面的第二个点
        end
    end
    
        node2InFace = node2(i);     %确定其一个node     
    for j = 1:nFaces            %寻找该node对应的face
        if node1(j) == node2InFace      %找到该面
            neighborNode2 = [neighborNode2,node2(j)];    %找到该面的第二个点
        end
        
        if node2(j) == node2InFace       %找到该面
             neighborNode2 = [neighborNode2,node1(j)];    %找到该面的第二个点
        end
    end