dimension       = hex2dec(grid(4,2));
nNodes          = hex2dec(grid(6,4));
nFaces          = hex2dec(grid(10,4));
nCells          = hex2dec(grid(14,4));
%%
%����ڵ�����
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
% ����face��Ϣ�������ڵ��ţ����ҵ�Ԫ���
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
        %������Դ������λ��ı�������
            node1(i+count) = hex2dec(grid(N+i,1));
            node2(i+count) = hex2dec(grid(N+i,2));
            leftCell(i+count) = hex2dec(grid(N+i,3));
            rightCell(i+count) = hex2dec(grid(N+i,4));
        elseif gridType == 1
        %������Ի������
            node1(i+count) = hex2dec(grid(N+i,2));
            node2(i+count) = hex2dec(grid(N+i,3));
            leftCell(i+count) = hex2dec(grid(N+i,4));
            rightCell(i+count) = hex2dec(grid(N+i,5));
        end
    end
    count = count + nFaces1;
end

    for j = 1:nFaces            %Ѱ�Ҹ�node��Ӧ��face
        if node1(j) == node1InFace      %�ҵ�����
            neighborNode1 = [neighborNode1,node2(j)];    %�ҵ�����ĵڶ�����
        end
        
        if node2(j) == node1InFace       %�ҵ�����
             neighborNode1 = [neighborNode1,node1(j)];    %�ҵ�����ĵڶ�����
        end
    end
    
        node2InFace = node2(i);     %ȷ����һ��node     
    for j = 1:nFaces            %Ѱ�Ҹ�node��Ӧ��face
        if node1(j) == node2InFace      %�ҵ�����
            neighborNode2 = [neighborNode2,node2(j)];    %�ҵ�����ĵڶ�����
        end
        
        if node2(j) == node2InFace       %�ҵ�����
             neighborNode2 = [neighborNode2,node1(j)];    %�ҵ�����ĵڶ�����
        end
    end