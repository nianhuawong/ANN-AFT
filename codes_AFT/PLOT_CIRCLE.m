function PLOT_CIRCLE(xb, yb, al, Sp, ds, node_best)
global flag_label;
global num_label;

% 可以画出圆来看看临近点有哪些
plot(xb,yb,'*')
hold on;

if  flag_label(node_best) == 0 && num_label == 1
    text(xb+0.05*ds,yb,num2str(node_best), 'Color', 'red', 'FontSize', 9);
    flag_label(node_best) = 1;
end

syms x y;
% ezplot((x-xb)^2+(y-yb)^2==al*al*Sp*Sp*ds*ds);
% fimplicit(@(x,y) (x-xb)^2+(y-yb)^2-al*al*Sp*Sp*ds*ds);
end