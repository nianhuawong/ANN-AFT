function PLOT_Background_Grid(xcoord,ycoord)
global num_label flag_label gridDim;
mesh(xcoord,ycoord,zeros(gridDim,gridDim));
hold on;
end