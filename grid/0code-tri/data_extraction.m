clear;clc;
grid = importfile("../naca0012/tri/naca0012-tri-coarse.cas");
%%
%读入基本信息
gridType        = 0;    % 0-单一单元网格，1-混合单元网格
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
plot(xCoord,yCoord,'x');
hold on;
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
%%
%搜索三角形网格targetPoint
% targetPoint  = zeros(nFaces,1);
% for i = 1:nFaces                %对于某个阵面
%     leftCellIndex = leftCell(i);
%     %寻找leftCell的另外1个点
%     for ii = 1:nFaces
%         if leftCell(ii) == leftCellIndex || rightCell(ii) == leftCellIndex   %找到该面
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
%四边形网格寻找targetPoint
targetPoint  = zeros(nFaces,2);
for i = 1:nFaces                %对于某个阵面
    targetTmp = []; 
    leftCellIndex = leftCell(i);
    %寻找leftCell的另外2个点
    for ii = 1:nFaces
        if leftCell(ii) == leftCellIndex || rightCell(ii) == leftCellIndex   %找到该面
            node1OfFace = node1(ii);
            node2OfFace = node2(ii);
            if node1OfFace ~= node1(i) && node1OfFace ~= node2(i) && size(find(targetTmp==node1OfFace),2) == 0               
                targetTmp = [targetTmp,node1OfFace];
            end
            
            if node2OfFace ~= node1(i) && node2OfFace ~= node2(i) && size(find(targetTmp==node2OfFace),2) == 0
                targetTmp = [targetTmp,node2OfFace];
            end                      
        end
%         if size(targetTmp,2) == 2 
%             targetPoint(i,:) = targetTmp
%             break;
%         end
    end
    targetPoint(i,:) = targetTmp;
end
%%
%搜寻模板点，左邻1+右邻1
stencilPoint = zeros(nFaces,4);
for i = 1:nFaces                %对于某个阵面    
    %以下寻找邻近点
    neighborNode1 = [];     %左侧邻近点
    neighborNode2 = [];     %右侧邻近点
    
    node1InFace = node1(i);     %确定其一个node     
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
    %有好几种可能，随机选择一种邻点
    pickNode1 = 0;
    pickNode2 = 0;
    while pickNode1 == pickNode2        %确保不会连成一个封闭三角形
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
%作图
% [~,I] = max(rand(1,nFaces));
for i = [1:40:nFaces]%1:nFaces
%     plot(xCoord(targetPoint(i)),yCoord(targetPoint(i)),'o');
    plot(xCoord(targetPoint(i,:)),yCoord(targetPoint(i,:)),'o');
    
    x = xCoord(stencilPoint(i,:));
    y = yCoord(stencilPoint(i,:));
    plot(x,y,'-*');
    hold on;
%     axis([-4,4,-4,4]);
end
hold off
%%
%数据输出
node_output = [stencilPoint,targetPoint];
coord_outputX = xCoord(node_output);
coord_outputY = yCoord(node_output);

% dlmwrite('./coord_outputX.dat',coord_outputX,'delimiter','\t','newline','pc','precision',9 );
% dlmwrite('./coord_outputY.dat',coord_outputY,'delimiter','\t','newline','pc','precision',9 );
