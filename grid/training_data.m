clc;clear;
startIn = 16;
samples = 10;
% filePath = 'f:/ANN_Grid/grid/naca0012/naca-';
filePath = 'f:/ANN_Grid/grid/inv_cylinder/quad/cy-';
savePath = strcat(filePath, 'all.mat');
input = [];
target = [];
for i = startIn:samples+startIn-1 
    varName = strcat('S', num2str(i));
    infile = strcat(filePath, 'q', num2str(i),'.mat')
    varName = load(infile, 'input','target');
    input = [input; varName.input];
    target = [target;varName.target];
end
save(savePath,'input','target')

