function [SpField,SelectedSourcesIndex] = CalculateSpByRBF_Greedy(SourceInfo,range)
global gridDim dx dy;
disp('RBF插值网格密度场...');
tstart = tic;
%%
% r0 = 50;            %紧支半径
r0 = 0.25 * max(range(2)-range(1),range(4)-range(3));
basis = 11;         %基函数类型
errorLimit = 0.01;   %相对误差的最大值不超过 
%%
xMin = range(1);% xMax = range(2);
yMin = range(3);% yMax = range(4);
numberOfSources = size(SourceInfo,1);
%% 精简物面点
disp(['原始物面点数 = ', num2str(numberOfSources)]);

SelectedSourcesIndex = [];
count = 1;maxID = randi(numberOfSources,1,1); Loo = 1.0;
while Loo > errorLimit                        %最大相对误差5%
    SelectedSourcesIndex(end+1,1)=maxID;
    numberOfSelectedSources = size(SelectedSourcesIndex,1);
    fai = zeros(numberOfSelectedSources, numberOfSelectedSources);
    for j = 1:numberOfSelectedSources
        index = SelectedSourcesIndex(j);
        xSource   = SourceInfo(index,1);
        ySource   = SourceInfo(index,2);
        for k = 1:numberOfSelectedSources
            index2 = SelectedSourcesIndex(k);
            xNode   = SourceInfo(index2,1);
            yNode   = SourceInfo(index2,2);
            rn  = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40;
            fai(j,k) = RBF_func(rn, r0, basis);
        end
    end
    
    W = fai \ SourceInfo(SelectedSourcesIndex,3);
    fai = zeros(1,numberOfSelectedSources);
    Loo = -1e40;
    
    for j = 1:numberOfSources
        xSource   = SourceInfo(j,1);
        ySource   = SourceInfo(j,2);
        for k = 1:numberOfSelectedSources
            index2 = SelectedSourcesIndex(k);
            xNode   = SourceInfo(index2,1);
            yNode   = SourceInfo(index2,2);
            rn  = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40;
            fai(1,k) = RBF_func(rn, r0, basis);
        end
        Sp = fai(1,:) * W;
        error = abs(Sp-SourceInfo(j,3))/SourceInfo(j,3);
        if (error>Loo)
            Loo = error;
            maxID = j;
        end
    end
    
    if sum(maxID==SelectedSourcesIndex)~=0    %确保选择的点不为已有参考点
        index = 1:numberOfSources;
        index(SelectedSourcesIndex)=[];
        maxID = index(uint16(rand * (length(index) - 1) + 1));
    end
    count = count + 1;
end

numberOfSelectedSources = size(SelectedSourcesIndex,1);
disp(['精简后物面点数 = ', num2str(numberOfSelectedSources)]);
disp(['精简后最大相对误差 = ', num2str(Loo)]);

plot(SourceInfo(SelectedSourcesIndex,1),SourceInfo(SelectedSourcesIndex,2),'b.','MarkerSize',15)
plot(SourceInfo(SelectedSourcesIndex(1),1),SourceInfo(SelectedSourcesIndex(1),2),'g.','MarkerSize',15)

SpField = zeros(gridDim,gridDim);
fai = zeros(1,numberOfSelectedSources);
%% 利用W计算内场点的Sp
for i = 1:gridDim
    for j = 1:gridDim
        xNode = xMin + (i-1)*dx;
        yNode = yMin + (j-1)*dy;
        for k = 1:numberOfSelectedSources
            index2 = SelectedSourcesIndex(k);
            xSource   = SourceInfo(index2,1);
            ySource   = SourceInfo(index2,2);
            
            rn = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40;
            fai(1,k) = RBF_func(rn, r0, basis);
        end
        
        SpField(i,j) = fai(1,:) * W;
    end
end
telapsed = toc(tstart);
disp(['RBF interpolation time = ', num2str(telapsed)]);
disp('RBF插值网格密度场...完成！');
end
