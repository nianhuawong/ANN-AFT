function [AFT_stack, Coord, Grid_stack, wallNodes] = read_grid(fileName, gridType)
grid = importfile1(fileName);
%%
%读入基本信息
dimension       = hex2dec(grid(4,2));
nNodes          = hex2dec(grid(6,4));
nFaces          = hex2dec(grid(10,4));
nCells          = hex2dec(grid(14,4));
%%
%读入节点坐标
nStart=17;  %节点坐标起始行
xCoord = str2double( grid(nStart:nStart+nNodes-1,1) );
yCoord = str2double( grid(nStart:nStart+nNodes-1,2) );
Coord =[xCoord,yCoord];
% plot(xCoord,yCoord,'x');
%%
node1 = zeros(nFaces,1);
node2 = zeros(nFaces,1);
leftCell    = zeros(nFaces,1);
rightCell   = zeros(nFaces,1);

% 读入face信息，两个节点编号，左右单元编号
facePos = find(strcmp(grid(:,1),'(13') == 1);
nn = facePos( length(facePos) : -1 : 2 );
nBoundaryFacesList = hex2dec(grid(nn,4))- hex2dec(grid(nn,3)) + 1; %最后一个为内部面，其他为边界面
nBoundaryFaces = sum(nBoundaryFacesList(1:end-1), 1);
bcType = zeros(1,nBoundaryFaces);

count = 1;
for j = length(facePos) : -1 : 2
    N = facePos(j);
    nFaces1 = hex2dec(grid(N,4))- hex2dec(grid(N,3)) + 1;
    startIn = count;
    endIn   = count + nFaces1 - 1;
    bcType(startIn:endIn) = hex2dec(grid(N,5));
    
    if gridType == 0 %以下针对纯三角形或四边形网格   
        node1(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,1));
        node2(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,2));
        leftCell(startIn:endIn,1)  = hex2dec(grid(N + 1:N + nFaces1,3));
        rightCell(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,4));

    elseif gridType == 1 %以下针对混合网格  
        node1(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,2));
        node2(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,3));
        leftCell(startIn:endIn,1)  = hex2dec(grid(N + 1:N + nFaces1,4));
        rightCell(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,5));
    end
    
    count = count + nFaces1;
end
%%
% 全局网格显示
wallNodes = [];
Grid_stack = zeros(nFaces,7);
for i = 1:nFaces
    Grid_stack(i,1) = node1(i,1);
    Grid_stack(i,2) = node2(i,1);
    Grid_stack(i,3) = leftCell(i,1);
    Grid_stack(i,4) = rightCell(i,1);
    Grid_stack(i,5) = DISTANCE(Grid_stack(i,1), Grid_stack(i,2), xCoord, yCoord);
    Grid_stack(i,6) = i;
    Grid_stack(i,7) = bcType(i);
    if bcType(i) == 3
        wallNodes(end+1:end+2) = [Grid_stack(i,1),Grid_stack(i,2)];
    end
end
wallNodes = unique(wallNodes);
% PLOT(Grid_stack, xCoord, yCoord);
% hold off
%%
% 完成边界面信息的提取，建立阵面信息
AFT_stack = zeros(nBoundaryFaces,6);
for i = 1:nBoundaryFaces
    AFT_stack(i,1) = node1(i,1);
    AFT_stack(i,2) = node2(i,1);
    AFT_stack(i,3) = -1;
    AFT_stack(i,4) = rightCell(i,1);
    AFT_stack(i,5) = DISTANCE(AFT_stack(i,1), AFT_stack(i,2), xCoord, yCoord);
    AFT_stack(i,6) = i;
end
