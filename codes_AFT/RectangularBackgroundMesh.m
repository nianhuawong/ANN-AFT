function [range,xcoord,ycoord] = RectangularBackgroundMesh(AFT_stack,Coord)
global num_label flag_label gridDim dx dy;
xmin = 1e40; ymin = 1e40;
xmax = -1e40; ymax = -1e40;
nBoundaryFaces = size(AFT_stack,1);
for i = 1:nBoundaryFaces
    node1 = AFT_stack(i,1);
    node2 = AFT_stack(i,2);
    xcoord = Coord(node1,1);
    ycoord = Coord(node1,2);
    
    xmin = min(xmin,xcoord);
    xmax = max(xmax,xcoord);
    
    ymin = min(ymin,ycoord);
    ymax = max(ymax,ycoord);    
    
    xcoord = Coord(node2,1);
    ycoord = Coord(node2,2);   
    
    xmin = min(xmin,xcoord);
    xmax = max(xmax,xcoord);
    
    ymin = min(ymin,ycoord);
    ymax = max(ymax,ycoord);  
end
maxVal = max(abs([xmin,xmax,ymin,ymax]));

% range = [xmin,xmax,ymin,ymax];
range = [-maxVal,maxVal,-maxVal,maxVal];

xmin = -maxVal;xmax = maxVal;
ymin = -maxVal;ymax = maxVal;

x_scale = xmax - xmin;
y_scale = ymax - ymin;

dx = x_scale / (gridDim-1);
dy = y_scale / (gridDim-1);

xcoord = zeros(gridDim,gridDim);
ycoord = zeros(gridDim,gridDim);
for i = 1:gridDim
    for j = 1:gridDim
        xcoord(i,j) = xmin+(i-1)*dx;
        ycoord(i,j) = ymin+(j-1)*dy;
    end
end
% xcoord = xcoord';
% ycoord = ycoord';
