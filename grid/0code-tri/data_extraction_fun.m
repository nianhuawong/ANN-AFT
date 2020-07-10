function [input,target] = data_extraction_fun(gridName, gridType, fileName, stencilType, mode, perturb)

[~, Coord, Grid_stack] = read_grid(gridName, gridType);

xCoord = Coord(:,1);
yCoord = Coord(:,2);
nNodes = length(xCoord);
nFaces =  size(Grid_stack, 1);
node1 = Grid_stack(:,1);
node2 = Grid_stack(:,2);
leftCell = Grid_stack(:,3);
rightCell = Grid_stack(:,4);
bcType = Grid_stack(:,7);

% PLOT(Grid_stack, xCoord, yCoord);
% hold on;
%%
% 搜索三角形网格targetPoint
targetPoint = [];
targetPoint_Tmp = TargetPointOfFrontTri(Grid_stack);
% targetPoint_Tmp = TargetPointOfFrontQuad(Grid_stack);
%%
%搜寻模板点，左邻1+右邻1
stencilPoint = [];
wdist = [];
count = 1;
frontLength = [];
frontAngle = [];
% disturbance1 = [];
% disturbance2 = [];
for i = 1:nFaces                %对于某个阵面
%% 引入物面距离作为参数
    wdist_Tmp = ComputeWallDistOfFace(i, Grid_stack, Coord);
    
    %以下寻找邻近点
    node1_base = node1(i);     %确定其一个node
    node2_base = node2(i);
    
	angle_Tmp = atan( (yCoord(node2_base)-yCoord(node1_base))/(xCoord(node2_base)-xCoord(node1_base)) );
	
    neighborNode1 = NeighborNodes(node1_base, Grid_stack, node2_base);   %左侧邻近点
    neighborNode2 = NeighborNodes(node2_base, Grid_stack, node1_base); %右侧邻近点
    
    if strcmp(stencilType,'random') % 有好几种可能，随机选择一种邻点      
        stencilPoint(end+1,:) = SelectStencilPointRandomly   (node1_base,node2_base,neighborNode1,neighborNode2);
        targetPoint  = targetPoint_Tmp;
        wdist(end+1) = wdist_Tmp;
		frontLength(end+1) = Grid_stack(i,5);
		frontAngle(end+1)  = angle_Tmp;
%         disturbance1(end+1) = Grid_stack(i,5) * rand() / 20.0;
%         disturbance2(end+1) = Grid_stack(i,5) * rand() / 20.0;
    else % 或者将所有的可能都做成模板     
        stencilPoint_Tmp = SelectStencilPointAllPossible(node1_base,node2_base, neighborNode1,neighborNode2);
        ntmp = size(stencilPoint_Tmp,1);
        stencilPoint(end+1:end+ntmp,:) = stencilPoint_Tmp;
        targetPoint(end+1:end+ntmp) = ones(1,ntmp) * targetPoint_Tmp(i);
        wdist(end+1:end+ntmp) = wdist_Tmp;
		frontLength(end+1:end+ntmp) = Grid_stack(i,5);
		frontAngle(end+1:end+ntmp)  = angle_Tmp;
%         disturbance1(end+1:end+ntmp) = Grid_stack(i,5) * rand() / 20.0;
%         disturbance2(end+1:end+ntmp) = Grid_stack(i,5) * rand() / 20.0;
    end
    
   %%     
%     plot(xCoord(targetPoint(count)),yCoord(targetPoint(count)),'o');    
%     for nn = 1:size(stencilPoint_Tmp,1)        
%         plot(xCoord(stencilPoint(count+nn-1,:)),yCoord(stencilPoint(count+nn-1,:)),'-*');
%     end
    count = count + size(stencilPoint_Tmp,1);
end

%%
PLOT(Grid_stack, xCoord, yCoord)
hold on;
% PlotStencil(nFaces,stencilPoint,targetPoint)
if perturb == 1
    a=-1.0/4;
    b=1.0/4;
    for iNode = 1 : nNodes
        [flag, frontSize] = isNotBoundaryNodes(iNode, Grid_stack);
        if flag == 1
            xCoord(iNode) = xCoord(iNode) + frontSize *  ( a + (b-a).*rand(1,1) );
            yCoord(iNode) = yCoord(iNode) + frontSize *  ( a + (b-a).*rand(1,1) );
        end
    end
    PLOT(Grid_stack, xCoord, yCoord)
end
%%
if mode == 0
    input = [xCoord(stencilPoint),yCoord(stencilPoint)];
elseif mode == 1
    input = [xCoord(stencilPoint),yCoord(stencilPoint),wdist'];
elseif	mode == 2
    input = [xCoord(stencilPoint),yCoord(stencilPoint),frontLength'];
elseif	mode == 3
    input = [xCoord(stencilPoint),yCoord(stencilPoint),frontAngle'];
elseif	mode == 12
     input = [xCoord(stencilPoint),yCoord(stencilPoint),wdist',frontLength'];
elseif	mode == 13
     input = [xCoord(stencilPoint),yCoord(stencilPoint),wdist',frontAngle'];
elseif	mode == 23
    input = [xCoord(stencilPoint),yCoord(stencilPoint),frontLength',frontAngle'];
elseif	mode == 123
    input = [xCoord(stencilPoint),yCoord(stencilPoint),wdist',frontLength',frontAngle'];
end

target =[xCoord(targetPoint),yCoord(targetPoint)];

save(fileName,'input','target')

%%
%数据输出
% node_output = [stencilPoint,targetPoint];
% coord_outputX = xCoord(node_output);
% coord_outputY = yCoord(node_output);

% dlmwrite('./coord_outputX.dat',coord_outputX,'delimiter','\t','newline','pc','precision',9 );
% dlmwrite('./coord_outputY.dat',coord_outputY,'delimiter','\t','newline','pc','precision',9 );
end