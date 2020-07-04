function PlotStencil(nFaces,stencilPoint,targetPoint)
% ×÷Í¼
[~,I] = max(rand(1,nFaces));
for i = [1:40] %1:nFaces
%     plot(xCoord(targetPoint(i)),yCoord(targetPoint(i)),'o');
%     plot(xCoord(targetPoint(i,:)),yCoord(targetPoint(i,:)),'o');

    x = xCoord(stencilPoint(i,:));
    y = yCoord(stencilPoint(i,:));
    plot(x,y,'-*');
    hold on;
%     axis([-4,4,-4,4]);
end
hold off