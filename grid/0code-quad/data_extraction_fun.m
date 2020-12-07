function [input,target] = data_extraction_fun(gridName, gridType, fileName, stencilType, targetType, mode, perturb)
global standardlizeCoord standardlizeSp;
[~, Coord, Grid_stack, wallNodes] = read_grid(gridName, gridType);

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
if targetType == 1
    targetPoint_Tmp = TargetPointOfFrontTri(Grid_stack); 
elseif targetType == 2
    targetPoint_Tmp = TargetPointOfFrontQuad(Grid_stack);
end
%% 求步长
stepSize_Tmp = zeros(nFaces,1);
for i = 1:nFaces
    node1_base = node1(i);
    node2_base = node2(i);
      
    if targetType == 1
        normal = normal_vector(node1_base, node2_base, xCoord, yCoord);
        v_ac = [xCoord(targetPoint_Tmp(i,1))-xCoord(node1_base), yCoord(targetPoint_Tmp(i,1))-yCoord(node1_base)];      
        
        if standardlizeSp == 1 
            stepSize_Tmp(i) = abs( v_ac * normal' ) / Grid_stack(i,5);
        else
            stepSize_Tmp(i) = abs( v_ac * normal' );
        end
     
    elseif targetType == 2
        v_ad =   [xCoord(targetPoint_Tmp(i,2))-xCoord(node1_base), yCoord(targetPoint_Tmp(i,2))-yCoord(node1_base)];
        v_cb = - [xCoord(targetPoint_Tmp(i,1))-xCoord(node2_base), yCoord(targetPoint_Tmp(i,1))-yCoord(node2_base)];
        dd1 = sqrt( v_ad(1)^2 + v_ad(2)^2 );
        dd2 = sqrt( v_cb(1)^2 + v_cb(2)^2 );
        angle = acos( v_ad * v_cb' / dd1 / dd2 );
        Area = 0.5 * dd1 * dd2 * sin(angle);
        
        if standardlizeSp == 1
            stepSize_Tmp(i) = sqrt(Area) / Grid_stack(i,5);
        else
            stepSize_Tmp(i) = sqrt(Area);
        end
    end
end
%%
%搜寻模板点，左邻1+右邻1
stencilPoint = [];
wdist = [];
count = 1;
frontLength = [];
frontAngle = [];
stepSize = [];
for i = 1:nFaces                %对于某个阵面
%% 引入物面距离作为参数
%     wdist_Tmp = ComputeWallDistOfFace(i, Grid_stack, Coord);
       
    node1_base = node1(i);     %确定其一个node
    node2_base = node2(i);
        
	angle_Tmp = atan( (yCoord(node2_base)-yCoord(node1_base))/(xCoord(node2_base)-xCoord(node1_base)) );
	
    %以下寻找邻近点
    neighborNode1 = NeighborNodes(node1_base, Grid_stack, node2_base);   %左侧邻近点
    neighborNode2 = NeighborNodes(node2_base, Grid_stack, node1_base); %右侧邻近点
    
    if strcmp(stencilType,'random') % 有好几种可能，随机选择一种邻点      
        stencilPoint_Tmp = SelectStencilPointRandomly   (node1_base,node2_base,neighborNode1,neighborNode2);
        stencilPoint(end+1,:) = stencilPoint_Tmp;
        targetPoint  = targetPoint_Tmp;
%         wdist(end+1) = wdist_Tmp;
% 		frontLength(end+1) = Grid_stack(i,5);
% 		frontAngle(end+1)  = angle_Tmp;
        stepSize = stepSize_Tmp;

    else % 或者将所有的可能都做成模板     
        stencilPoint_Tmp = SelectStencilPointAllPossible(node1_base,node2_base, neighborNode1,neighborNode2);
        ntmp = size(stencilPoint_Tmp,1);
        stencilPoint(end+1:end+ntmp,:) = stencilPoint_Tmp;
%         targetPoint(end+1:end+ntmp) = ones(1,ntmp) * targetPoint_Tmp(i);
        targetPoint(end+1:end+ntmp,:) = ones(ntmp,1) * targetPoint_Tmp(i,:);
%         wdist(end+1:end+ntmp) = wdist_Tmp;
% 		frontLength(end+1:end+ntmp) = Grid_stack(i,5);
% 		frontAngle(end+1:end+ntmp)  = angle_Tmp;
        stepSize(end+1:end+ntmp,:) = ones(ntmp,1) * stepSize_Tmp(i,:);
        
        %物面上前后缘的模板多复制50份
%         if ( sum( wallNodes == node1_base )~=0 ||  sum( wallNodes == node2_base )~=0 ) ...
%                 && ( xCoord(node1_base) <= -0.48 || xCoord(node1_base) >= 0.48 )
%             ntmp = size(stencilPoint_Tmp,1);
% %             PLOT_FRONT(Grid_stack, xCoord, yCoord, i);
% %             kkk = 1;
%             for kkk = 1:10                
%                 stencilPoint(end+1:end+ntmp,:) = stencilPoint_Tmp;
%                 targetPoint(end+1:end+ntmp,:) = ones(ntmp,1) * targetPoint_Tmp(i,:);
%                 stepSize(end+1:end+ntmp,:) = ones(ntmp,1) * stepSize_Tmp(i,:);
%             end
%         end
        
    end
    
   %%     
%     plot(xCoord(targetPoint(count)),yCoord(targetPoint(count)),'o'); 
%     for nn = 1:size(stencilPoint_Tmp,1)
%         plot(xCoord(stencilPoint(count+nn-1,:)),yCoord(stencilPoint(count+nn-1,:)),'-o');
%     end
%     count = count + size(stencilPoint_Tmp,1);

%     plot(xCoord(targetPoint(count,:)),yCoord(targetPoint(count,:)),'b*');   
%     for nn = 1:size(stencilPoint_Tmp,1) 
%         plot(xCoord(stencilPoint_Tmp(nn,:)),yCoord(stencilPoint_Tmp(nn,:)),'-o');
%     end
%     count = count + size(stencilPoint_Tmp,1);    
end

%%
PLOT(Grid_stack, xCoord, yCoord)
% axis off
% axis([-0.7 0.7 -0.5 0.5])
% DelaunayMesh(xCoord,yCoord,wallNodes);
%%
% hold on;
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
%     PLOT(Grid_stack, xCoord, yCoord)
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


if mode == 4
    input = [xCoord(stencilPoint),yCoord(stencilPoint)];
    target =[xCoord(targetPoint),yCoord(targetPoint),stepSize];    
else
    target =[xCoord(targetPoint),yCoord(targetPoint)];
end

if targetType == 1
    generateMode = zeros(size(stencilPoint,1),3);
    if mode == 5
        input = [xCoord(stencilPoint),yCoord(stencilPoint)];
        target =[xCoord(targetPoint),yCoord(targetPoint)];
        for i = 1:size(stencilPoint,1)
            if stencilPoint(i,1) == targetPoint(i)
                generateMode(i,2) = 1;
            elseif stencilPoint(i,4) == targetPoint(i)
                generateMode(i,3) = 1;
            else
                generateMode(i,1) = 1;
            end
        end
    end
elseif targetType == 2
    generateMode = zeros(size(stencilPoint,1),4);
    if mode == 5
        input = [xCoord(stencilPoint),yCoord(stencilPoint)];
        target =[xCoord(targetPoint),yCoord(targetPoint)];
        for i = 1:size(stencilPoint,1)
            if stencilPoint(i,1) == targetPoint(i,1) && stencilPoint(i,4) ~= targetPoint(i,2)
                generateMode(i,2) = 1;
            elseif stencilPoint(i,4) == targetPoint(i,2) && stencilPoint(i,1) ~= targetPoint(i,1)
                generateMode(i,3) = 1;
            elseif stencilPoint(i,4) == targetPoint(i,2) && stencilPoint(i,1) == targetPoint(i,1)
                generateMode(i,4) = 1;
            else
                generateMode(i,1) = 1;
            end
        end
    end
end

if standardlizeCoord == 1
    for i = 1:length(stencilPoint)
        point1 = [input(i,1), input(i,5)];
        point2 = [input(i,2), input(i,6)];
        point3 = [input(i,3), input(i,7)];
        point4 = [input(i,4), input(i,8)];
        %%
        %     close all;
        %     figure;
        %     plot([point1(1),point2(1)],[point1(2),point2(2)],'b*-');
        %     hold on;
        %     plot([point3(1),point2(1)],[point3(2),point2(2)],'g*-');
        %     plot([point3(1),point4(1)],[point3(2),point4(2)],'b*-');
        %%
        
        [input(i,1), input(i,5)] = Transform( point1, point2, point3 );
        input(i,2) = 0.0; input(i,6) = 0;
        input(i,3) = 1.0; input(i,7) = 0;
        [input(i,4), input(i,8)] = Transform( point4, point2, point3 );
        %%
        %     plot([input(i,1),input(i,2)],[input(i,5),input(i,6)],'k*-');
        %     plot([input(i,2),input(i,3)],[input(i,6),input(i,7)],'k*-');
        %     plot([input(i,3),input(i,4)],[input(i,7),input(i,8)],'k*-');
        %%
        if targetType == 1
            pointT = [target(i,1), target(i,2)];
            %         plot(pointT(1), pointT(2),'bo-');
            
            [target(i,1), target(i,2)] = Transform( pointT, point2, point3 );
            %         plot(target(i,1), target(i,2),'ko-');
        elseif targetType == 2
            pointT1 = [target(i,1), target(i,3)];
            pointT2 = [target(i,2), target(i,4)];
            [target(i,1), target(i,3)] = Transform( pointT1, point2, point3 );
            [target(i,2), target(i,4)] = Transform( pointT2, point2, point3 );
        end
    end
end
if mode == 5
    target = [target,generateMode];
end
save(fileName,'input','target')

%%
%数据输出
% node_output = [stencilPoint,targetPoint];
% coord_outputX = xCoord(node_output);
% coord_outputY = yCoord(node_output);

% dlmwrite('./coord_outputX.dat',coord_outputX,'delimiter','\t','newline','pc','precision',9 );
% dlmwrite('./coord_outputY.dat',coord_outputY,'delimiter','\t','newline','pc','precision',9 );
end