i=randi([1,1000],1);
plot(input(i,1:4),input(i,5:8),'k-*')
hold on;
axis equal;
axis([-10, 10, -10,10]);
plot(target(i,1:2),target(i,3:4),'bo');
target(i,5)