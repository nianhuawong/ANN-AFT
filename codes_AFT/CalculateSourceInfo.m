function SourceInfo = CalculateSourceInfo(AFT_stack,Coord)
%%
% SourceInfo = [
%   -0.501948924731183  -0.002352150537634   0.009842558438987   1.000000000000000
%    0.497244623655914  -0.001411290322581   0.009999998532301   1.000000000000000
%   -0.120900537634408  -0.000470430107527   0.058413987159376   1.000000000000000
%    0.388104838709678  -0.000470430107527   0.030335064541944   1.000000000000000
%   -0.474663978494624  -0.000470430107527   0.012131356216223   1.000000000000000
%   -9.882198952879580   9.829842931937169   2.222222222222221   10.000000000000000
%    9.908376963350783   9.882198952879577   2.222222222222221   10.000000000000000
%   -9.777486910994764  -9.777486910994767   2.222222222222221   10.000000000000000
%    9.777486910994760  -9.829842931937176   2.222222222222221   10.000000000000000
%   ];
% return;
  
%% 在计算域中点选几个点源
% X=[];Y=[];
% button = 1;
% % axis([-0.2 1.2 -0.1 0.1])
% axis([-0.7 0.7 -0.1 0.1])
% while (button~=3)
%     [x1,y1,button] = ginput(1);   %前面的点源用鼠标左键选择，最后一个点源用鼠标右键选择
%     plot(x1,y1,'b*')
%     X = [X;x1];
%     Y = [Y,y1];
%     if button == 2
%         axis tight; axis equal;
%     end
% end
% 
% nBoundaryFaces = size(AFT_stack,1);
% nSources = size(X,1);
% SourceInfo = zeros(nSources,4); % 存储点源的位置、强度、强度因子
% intensity  = ones(nSources,1);  % 强度因子暂时默认为1.0
% for k = 1:nSources
%     xSource = X(k);
%     ySource = Y(k);
%     
%     minDist = 1e40;
%     for i = 1:nBoundaryFaces
%         node1 = AFT_stack(i,1);
%         node2 = AFT_stack(i,2);
%         
%         xcoord = 0.5 * ( Coord(node1,1) + Coord(node2,1) );
%         ycoord = 0.5 * ( Coord(node1,2) + Coord(node2,2) );
%         
%         dist = sqrt( ( xcoord - xSource )^2 + ( ycoord - ySource )^2 ) + 1e-40;
%         if dist < minDist
%             minDist = dist;
%             index = i;
%             xNode = xcoord;
%             yNode = ycoord;
%         end
%     end
%     
% %     SourceInfo(k,1) = xSource;
% %     SourceInfo(k,2) = ySource;
%     SourceInfo(k,1) = xNode;
%     SourceInfo(k,2) = yNode;
%     SourceInfo(k,3) = AFT_stack(index,5);
%     SourceInfo(k,4) = intensity(k) / nSources;
% end
% SourceInfo

% end
%% 直接采用所有边界阵面作为点源，貌似不行
nBoundaryFaces = size(AFT_stack,1);
SourceInfo = zeros(nBoundaryFaces,4); % 存储点源的位置、强度、强度因子
intensity  = ones(nBoundaryFaces,1);  % 强度因子暂时默认为1.0

for i = 1:nBoundaryFaces
    node1 = AFT_stack(i,1);
    node2 = AFT_stack(i,2);
    
    xcoord = 0.5 * ( Coord(node1,1) + Coord(node2,1) );
    ycoord = 0.5 * ( Coord(node1,2) + Coord(node2,2) );
    
    sp = sqrt(3.0)/2.0 * DISTANCE( node1, node2, Coord(:,1), Coord(:,2));
    
    SourceInfo(i,:)=[xcoord, ycoord, sp, intensity(i)/nBoundaryFaces]; % 存储点源的位置、强度、强度因子
end

%% 矩形算例
%  SourceInfo = [-4, 4, 0.9, 1;
%                -4,-4, 0.9, 1;
%                 4,-4, 0.9, 1;
%                 4, 4, 0.9, 1; 
%                 0, 0, 0.01, 5;
%                 2, 2, 0.01, 1;
%                 -2, -2, 0.01, 1];
%% 圆柱算例
%  SourceInfo = [
%  0 0 0.3 1
%  -10, 10, 2.2, 1;
%  -10,-10, 2.2, 1;
%  10,-10, 2.2, 1;
%  10, 10, 2.2, 1;
%  ];

%% NACA0012 quadBC
%  SourceInfo = [-10, 10, 2.2, 1;
%                -10,-10, 2.2, 1;
%                 10,-10, 2.2, 1;
%                 10, 10, 2.2, 1; 
%                 0,  10, 2.2, 1;
%                 0, -10, 2.2, 1;
%                 -10, 0, 2.2, 1;
%                 10,  0, 2.2, 1; 
%                 -0.5, 0, 0.015, 1;
%                  0.5, 0, 0.015, 1;
%                   0, 0, 0.06, 1];

