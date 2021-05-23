function Sp = Interpolate2Grid(xNode, yNode, StepSize, range)
global num_label flag_label gridDim dx dy;
ddx = xNode - range(1);
ddy = yNode - range(3);

ni1 = fix( ddx / dx ) + 1;       
nj1 = fix( ddy / dy ) + 1;
if ni1 == gridDim
    ni1 = ni1 - 1;
end
if nj1 == gridDim
    nj1 = nj1 - 1;
end

x1 = range(1) + (ni1-1) * dx;
y1 = range(3) + (nj1-1) * dy;
Sp1 = StepSize(ni1,nj1);
dist1 = sqrt( ( xNode - x1 )^2 + ( yNode - y1 )^2 ) + 1e-40;

ni2 = ni1 + 1;
nj2 = nj1;
x2 = range(1) + (ni2-1) * dx;
y2 = range(3) + (nj2-1) * dy;
Sp2 = StepSize(ni2,nj2);
dist2 = sqrt( ( xNode - x2 )^2 + ( yNode - y2 )^2 ) + 1e-40;

ni3 = ni1 + 1;
nj3 = nj1 + 1; 
x3 = range(1) + (ni3-1) * dx;
y3 = range(3) + (nj3-1) * dy;
Sp3 = StepSize(ni3,nj3);
dist3 = sqrt( ( xNode - x3 )^2 + ( yNode - y3 )^2 ) + 1e-40;

ni4 = ni1;
nj4 = nj1 + 1;
x4 = range(1) + (ni4-1) * dx;
y4 = range(3) + (nj4-1) * dy;
Sp4 = StepSize(ni4,nj4);
dist4 = sqrt( ( xNode - x4 )^2 + ( yNode - y4 )^2 ) + 1e-40;

%% inverse distance weighting
Sp = (Sp1 / dist1 / dist1 + Sp2 / dist2 / dist2 + Sp3 / dist3 / dist3 + Sp4 / dist4 / dist4) ...
    /(1.0 / dist1 / dist1 + 1.0 / dist2 / dist2 + 1.0 / dist3 / dist3 + 1.0 / dist4 / dist4);

end