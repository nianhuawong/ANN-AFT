function [Grid_stack, Coord] = read_grid(fileName, gridType)
grid = importfile(fileName);

%% ���������Ϣ
dimension       = hex2dec(grid(4,2));
nNodes          = hex2dec(grid(6,4));
nFaces          = hex2dec(grid(10,4));
nCells          = hex2dec(grid(14,4));

%% ����ڵ�����
nStart=17;  %�ڵ�������ʼ��
xCoord = str2double( grid(nStart:nStart+nNodes-1,1) );
yCoord = str2double( grid(nStart:nStart+nNodes-1,2) );
Coord =[xCoord,yCoord];

%%
node1 = zeros(nFaces,1);
node2 = zeros(nFaces,1);
leftCell    = zeros(nFaces,1);
rightCell   = zeros(nFaces,1);

%% ����face��Ϣ�������ڵ��ţ����ҵ�Ԫ���
facePos = find(strcmp(grid(:,1),'(13') == 1);
nn = facePos( length(facePos) : -1 : 2 );
nBoundaryFacesList = hex2dec(grid(nn,4))- hex2dec(grid(nn,3)) + 1; %���һ��Ϊ�ڲ��棬����Ϊ�߽���
nBoundaryFaces = sum(nBoundaryFacesList(1:end-1), 1);
bcType = zeros(1,nBoundaryFaces);

count = 1;
for j = length(facePos) : -1 : 2
    N = facePos(j);
    nFaces1 = hex2dec(grid(N,4))- hex2dec(grid(N,3)) + 1;
    startIn = count;
    endIn   = count + nFaces1 - 1;
    bcType(startIn:endIn) = hex2dec(grid(N,5));
    
    if gridType == 0 %������Դ������λ��ı�������
        node1(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,1));
        node2(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,2));
        leftCell(startIn:endIn,1)  = hex2dec(grid(N + 1:N + nFaces1,3));
        rightCell(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,4));
        
    elseif gridType == 1 %������Ի������
        node1(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,2));
        node2(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,3));
        leftCell(startIn:endIn,1)  = hex2dec(grid(N + 1:N + nFaces1,4));
        rightCell(startIn:endIn,1) = hex2dec(grid(N + 1:N + nFaces1,5));
    end
    
    count = count + nFaces1;
end
%%

Grid_stack = zeros(nFaces,7);
for i = 1:nFaces
    Grid_stack(i,1) = node1(i,1);
    Grid_stack(i,2) = node2(i,1);
    Grid_stack(i,3) = leftCell(i,1);
    Grid_stack(i,4) = rightCell(i,1);
    Grid_stack(i,5) = DISTANCE(Grid_stack(i,1), Grid_stack(i,2), xCoord, yCoord);
    Grid_stack(i,6) = i;
    Grid_stack(i,7) = bcType(i);
end
end
