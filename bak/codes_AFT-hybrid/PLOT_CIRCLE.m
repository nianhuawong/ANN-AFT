function PLOT_CIRCLE(xb, yb, al, Sp, ds, node_best)
% 可以画出圆来看看临近点有哪些
plot(xb,yb,'*')
hold on;
text(xb+0.05*ds,yb,num2str(node_best), 'Color', 'red', 'FontSize', 14);
syms x y;
% ezplot((x-xb)^2+(y-yb)^2==al*al*Sp*Sp*ds*ds);
% fimplicit(@(x,y) (x-xb)^2+(y-yb)^2-al*al*Sp*Sp*ds*ds);
end