clear;clc;
grid = importfile("./quad.cas");
%%
%���������Ϣ
gridType        = 0;    % 0-��һ��Ԫ����1-��ϵ�Ԫ����
dimension       = hex2dec(grid(4,2));
nNodes          = hex2dec(grid(6,4));
nFaces          = hex2dec(grid(10,4));
nCells          = hex2dec(grid(14,4));
%%
xCoord = zeros(nNodes,1);
yCoord = zeros(nNodes,1);
for i = 0:nNodes-1
    xCoord(i+1) = grid(17+i,1);
    yCoord(i+1) = grid(17+i,2);
end
plot(xCoord,yCoord,'x');
hold on;
%%
facePos =[];
for i = 1:size(grid,1)
    if(grid(i,1)=="(13")
        facePos = [facePos, i]; 
    end
end
%%
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
%%
%����������targetPoint
% targetPoint  = zeros(nFaces,1);
% for i = 1:nFaces                %����ĳ������
%     leftCellIndex = leftCell(i);
%     %Ѱ��leftCell������1����2����
%     for ii = 1:nFaces
%         if leftCell(ii) == leftCellIndex || rightCell(ii) == leftCellIndex   %�ҵ�����
%             node1OfFace = node1(ii);
%             node2OfFace = node2(ii);
%             if node1OfFace ~= node1(i) && node1OfFace ~= node2(i)
%                 targetPoint(i) = node1OfFace;
%             end
%             if node2OfFace ~= node1(i) && node2OfFace ~= node2(i)
%                 targetPoint(i) = node2OfFace;
%             end                      
%         end
%     end
% end
%%
%�ı�������Ѱ��targetPoint
targetPoint  = zeros(nFaces,2);
for i = 4%1:nFaces                %����ĳ������
    targetTmp = []; 
    leftCellIndex = leftCell(i);
    %Ѱ��leftCell������2����
    for ii = 1:nFaces
        if leftCell(ii) == leftCellIndex || rightCell(ii) == leftCellIndex   %�ҵ�����
            node1OfFace = node1(ii);
            node2OfFace = node2(ii);
            if node1OfFace ~= node1(i) && node1OfFace ~= node2(i)
                targetTmp = [targetTmp,node1OfFace];
            end
            
            if node2OfFace ~= node1(i) && node2OfFace ~= node2(i)
                targetTmp = [targetTmp,node2OfFace];
            end                      
        end
        if size(targetTmp,2) == 2 
            targetPoint(i,:) = targetTmp
            break;
        end
    end
end
%%
stencilPoint = zeros(nFaces,4);
for i = 1:nFaces                %����ĳ������    
    %����Ѱ���ڽ���
    neighborNode1 = [];     %����ڽ���
    neighborNode2 = [];     %�Ҳ��ڽ���
    
    node1InFace = node1(i);     %ȷ����һ��node     
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
    
    %
    pickNode1 = 0;
    pickNode2 = 0;
    while pickNode1 == pickNode2        %ȷ����������һ�����������
        [~,I] = max(rand(1,length(neighborNode1)));
        while neighborNode1(I) == node2InFace
           [~,I] = max(rand(1,length(neighborNode1)));
        end
        pickNode1 = neighborNode1(I);

        [~,I] = max(rand(1,length(neighborNode2)));
        while neighborNode2(I) == node1InFace
           [~,I] = max(rand(1,length(neighborNode2)));
        end
        pickNode2 = neighborNode2(I);  
    end
    stencilPoint(i,:) = [pickNode1,node1InFace,node2InFace,pickNode2];
end
% stencilPoint
%%
%��ͼ
% [~,I] = max(rand(1,nFaces));
for i = 8%1:nFaces
%     plot(xCoord(targetPoint(i)),yCoord(targetPoint(i)),'o');
%     plot(xCoord(targetPoint(i,:)),yCoord(targetPoint(i,:)),'o');
    
    x = xCoord(stencilPoint(i,:));
    y = yCoord(stencilPoint(i,:));
    plot(x,y,'-*');
    hold on;
    axis([-4,4,-4,4]);
end
hold off
%%
%�������
% data_output = []
