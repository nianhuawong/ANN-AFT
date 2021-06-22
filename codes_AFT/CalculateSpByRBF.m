function SpField = CalculateSpByRBF(SourceInfo,range)
global gridDim dx dy;
disp('RBF插值网格密度场...');
%%
r0 = 10;        %紧支半径
basis = 11;     %基函数类型
%%
xMin = range(1);% xMax = range(2);
yMin = range(3);% yMax = range(4);
numberOfSources = size(SourceInfo,1);
fai = zeros(numberOfSources, numberOfSources);
%% 计算权重系数矩阵W 
for j = 1:numberOfSources
    xSource   = SourceInfo(j,1);
    ySource   = SourceInfo(j,2);  
    for k = 1:numberOfSources
        xNode   = SourceInfo(k,1);
        yNode   = SourceInfo(k,2);      
        rn  = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40; 
        fai(j,k) = RBF_func(rn, r0, basis);
    end
end

W = fai \ SourceInfo(:,3);

SpField = zeros(gridDim,gridDim);
fai = zeros(1,numberOfSources);

for i = 1:gridDim
    for j = 1:gridDim
        xNode = xMin + (i-1)*dx;
        yNode = yMin + (j-1)*dy;
        for k = 1:numberOfSources
            xSource   = SourceInfo(k,1);
            ySource   = SourceInfo(k,2);
            
            rn = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40;
            
            fai(1,k) = RBF_func(rn, r0, basis);
        end
        
        SpField(i,j) = fai(1,:) * W;
    end
end
disp('RBF插值网格密度场...完成！');
end
