% i=randi([1,1000],1);
% plot(input(i,1:4),input(i,5:8),'k-*')
% hold on;
% axis equal;
% axis([-10, 10, -10,10]);
% plot(target(i,1:2),target(i,3:4),'bo');
% target(i,5)
gridType = 1; %0-三角形网格；1-混合网格
figure

for i = 1:size(input,1)
    refPoint1 = [input0(i,2), input0(i,6)];
    refPoint2 = [input0(i,3), input0(i,7)];
    
    point1 = [input(i,1), input(i,5)];
    [point1(1), point1(2)] = AntiTransform(point1, refPoint1, refPoint2);

    point2 = refPoint1;
    point3 = refPoint2;

    point4 = [input(i,4), input(i,8)];
    [point4(1), point4(2)] = AntiTransform(point4, refPoint1, refPoint2);
    if gridType == 0
        pointT = [target(i,1), target(i,2)];
        [pointT(1), pointT(2)] = AntiTransform(pointT, refPoint1, refPoint2);
    elseif gridType == 1
        pointT1 = [target(i,1), target(i,3)];
        pointT2 = [target(i,2), target(i,4)];
        [pointT1(1), pointT1(2)] = AntiTransform(pointT1, refPoint1, refPoint2); 
        [pointT2(1), pointT2(2)] = AntiTransform(pointT2, refPoint1, refPoint2);
    end
        
    plot([point1(1),point2(1)],[point1(2),point2(2)],'b-*');   
    axis equal;hold on;
    plot([point3(1),point2(1)],[point3(2),point2(2)],'b-*');
    plot([point3(1),point4(1)],[point3(2),point4(2)],'b-*');
    
    if gridType == 0
        plot(pointT(1), pointT(2),'ro');
    elseif gridType == 1
        plot(pointT1(1), pointT1(2),'ro');
        plot(pointT2(1), pointT2(2),'ro');
    end
    
    pause();
end
    