global flag_label num_label;
num_label    = 0;   %是否在图中输出点的编号 
flag_label   = zeros(1,10000);
fig = figure;fig.Color = 'white';hold on;
stepSizeFile     = '../grid/inv_cylinder/tri/inv_cylinder-50-hybrid.cas';
% stepSizeFile     = '../grid/naca0012/tri/naca0012-hybrid.cas';
% stepSizeFile     = '../grid/30p30n/30p30n-fine-hybrid.cas';
% stepSizeFile     = '../grid/30p30n/30p30n-hybrid.cas';
sizeFileType     = 1;
[~,Coord,Grid,~]  = read_grid(stepSizeFile, sizeFileType);
GridQualitySummary([], Coord(:,1), Coord(:,2),Grid);

