function initialStepSize = InitialValue(SourceInfo,range)
global num_label flag_label gridDim dx dy;
initialStepSize = zeros(gridDim,gridDim);
xMin = range(1);% xMax = range(2);
yMin = range(3);% yMax = range(4);

for i = 1 :gridDim
    for j = 1:gridDim
        xNode = xMin + (i-1)*dx;
        yNode = yMin + (j-1)*dy;
        
        [lower, upper] = SourceImpact(SourceInfo,xNode, yNode);        
        initialStepSize(i,j) = upper / lower;
    end
end

end