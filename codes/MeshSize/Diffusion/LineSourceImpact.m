function [In, Jn] = LineSourceImpact(xNode, yNode, P1, P2, fl)
n=20;
x1 = P1(1); y1 = P1(2);
x2 = P2(1); y2 = P2(2);
% k = (y1-y2)/(x1-x2);

ln = sqrt((x1-x2)^2+(y1-y2)^2);
dl = ln / n;
dx = (x2-x1)/n;

In = 0; Jn = 0;
for i=1:n
    xSource = x1 + (2*i-1)/2 * dx;
    ySource = line(xSource, P1, P2);
    
    dis = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40;
    
    In = In + fl * dl / dis / dis;
    Jn = Jn +      dl / dis / dis;
end
In = In / ln;
Jn = Jn / ln;
end

function y = line(x, P1, P2)
x1 = P1(1); y1 = P1(2);
x2 = P2(1); y2 = P2(2);
y = (x-x2)/(x1-x2)*(y1-y2)+y2;
end

