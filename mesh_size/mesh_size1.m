clc;clear;
global num_label flag_label;
num_label        = 0;
flag_label       = zeros(10000,1);
% stepSizeFile     = '../grid/inv_cylinder/tri/inv_cylinder-50.cas';
stepSizeFile     = '../grid/naca0012/tri/naca0012-tri.cas';
sizeFileType     = 0;   %输入步长文件的类型，0-三角形网格，1-混合网格
sampleType       = 3;   %1-(x,y,h); 2-(x,y,d1,dx1,h); 3-(x,y,d1,dx1,d2,dx2,h)
fileName         = './data/mesh_size_sample.mat';
[input, output] = StepSizeField(stepSizeFile, sizeFileType, sampleType);

for i = 1:5
    input = [input;input];
    output = [output;output];
end
save(fileName,'input','output')