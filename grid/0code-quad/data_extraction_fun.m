function [input,target] = data_extraction_fun(gridName, gridType, fileName, stencilType, targetType, mode, perturb)

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
% ��������������targetPoint
targetPoint = [];
if targetType == 1
    targetPoint_Tmp = TargetPointOfFrontTri(Grid_stack); 
elseif targetType == 2
    targetPoint_Tmp = TargetPointOfFrontQuad(Grid_stack);
end
%% �󲽳�
stepSize_Tmp = zeros(nFaces,1);
for i = 1:nFaces
    node1_base = node1(i);
    node2_base = node2(i);
      
    if targetType == 1
        normal = normal_vector(node1_base, node2_base, xCoord, yCoord);
        v_ac = [xCoord(targetPoint_Tmp(i,1))-xCoord(node1_base), yCoord(targetPoint_Tmp(i,1))-yCoord(node1_base)];
        stepSize_Tmp(i) = abs( v_ac * normal' );
    elseif targetType == 2
        v_ad =   [xCoord(targetPoint_Tmp(i,2))-xCoord(node1_base), yCoord(targetPoint_Tmp(i,2))-yCoord(node1_base)];
        v_cb = - [xCoord(targetPoint_Tmp(i,1))-xCoord(node2_base), yCoord(targetPoint_Tmp(i,1))-yCoord(node2_base)];
        dd1 = sqrt( v_ad(1)^2 + v_ad(2)^2 );
        dd2 = sqrt( v_cb(1)^2 + v_cb(2)^2 );
        angle = acos( v_ad * v_cb' / dd1 / dd2 );
        Area = 0.5 * dd1 * dd2 * sin(angle);
        stepSize_Tmp(i) = sqrt(Area);
    end
end
%%
%��Ѱģ��㣬����1+����1
stencilPoint = [];
wdist = [];
count = 1;
frontLength = [];
frontAngle = [];
stepSize = [];
for i = 1:nFaces                %����ĳ������
%% �������������Ϊ����
    wdist_Tmp = ComputeWallDistOfFace(i, Grid_stack, Coord);
       
    node1_base = node1(i);     %ȷ����һ��node
    node2_base = node2(i);
        
	angle_Tmp = atan( (yCoord(node2_base)-yCoord(node1_base))/(xCoord(node2_base)-xCoord(node1_base)) );
	
    %����Ѱ���ڽ���
    neighborNode1 = NeighborNodes(node1_base, Grid_stack, node2_base);   %����ڽ���
    neighborNode2 = NeighborNodes(node2_base, Grid_stack, node1_base); %�Ҳ��ڽ���
    
    if strcmp(stencilType,'random') % �кü��ֿ��ܣ����ѡ��һ���ڵ�      
        stencilPoint_Tmp = SelectStencilPointRandomly   (node1_base,node2_base,neighborNode1,neighborNode2);
        stencilPoint(end+1,:) = stencilPoint_Tmp;
        targetPoint  = targetPoint_Tmp;
        wdist(end+1) = wdist_Tmp;
		frontLength(end+1) = Grid_stack(i,5);
		frontAngle(end+1)  = angle_Tmp;
        stepSize = stepSize_Tmp;

    else % ���߽����еĿ��ܶ�����ģ��     
        stencilPoint_Tmp = SelectStencilPointAllPossible(node1_base,node2_base, neighborNode1,neighborNode2);
        ntmp = size(stencilPoint_Tmp,1);
        stencilPoint(end+1:end+ntmp,:) = stencilPoint_Tmp;
%         targetPoint(end+1:end+ntmp) = ones(1,ntmp) * targetPoint_Tmp(i);
        targetPoint(end+1:end+ntmp,:) = ones(ntmp,1) * targetPoint_Tmp(i,:);
        wdist(end+1:end+ntmp) = wdist_Tmp;
		frontLength(end+1:end+ntmp) = Grid_stack(i,5);
		frontAngle(end+1:end+ntmp)  = angle_Tmp;
        stepSize(end+1:end+ntmp,:) = ones(ntmp,1) * stepSize_Tmp(i,:);
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

save(fileName,'input','target')

%%
%�������
% node_output = [stencilPoint,targetPoint];
% coord_outputX = xCoord(node_output);
% coord_outputY = yCoord(node_output);

% dlmwrite('./coord_outputX.dat',coord_outputX,'delimiter','\t','newline','pc','precision',9 );
% dlmwrite('./coord_outputY.dat',coord_outputY,'delimiter','\t','newline','pc','precision',9 );
end