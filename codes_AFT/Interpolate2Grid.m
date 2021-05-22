function Sp = Interpolate2Grid(xNode, yNode, StepSize, range)
global num_label flag_label gridDim dx dy;
ddx = xNode - range(1);
ddy = yNode - range(3);

ni = fix( ddx / dx ) + 1;
nj = fix( ddy / dy ) + 1;

Sp = StepSize(ni,nj);

end