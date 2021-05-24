function [initialStepSize, LOWER, UPPER] = InitialValue(SourceInfo,range)
global num_label flag_label gridDim dx dy;
disp('生成初始网格密度场...');
initialStepSize = zeros(gridDim,gridDim);
xMin = range(1);% xMax = range(2);
yMin = range(3);% yMax = range(4);
%%
LOWER = zeros(gridDim,gridDim);
UPPER = zeros(gridDim,gridDim);
%%
for i = 1 :gridDim
    for j = 1:gridDim
        xNode = xMin + (i-1)*dx;
        yNode = yMin + (j-1)*dy;
        
%         if i == 48 && j == 51 || ...
%            i == 49 && j == 51 || ...
%            i == 49 && j == 52 || ...
%            i == 48 && j == 52
%        kkk = 1;
%         end
        [lower, upper] = SourceImpact(SourceInfo,xNode, yNode);  
        
        LOWER(i,j) = lower;
        UPPER(i,j) = upper;       
        initialStepSize(i,j) = upper / lower;
    end
end

end