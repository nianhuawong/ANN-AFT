function SourceInfo = CalculateSourceInfo(AFT_stack,Coord)

% nBoundaryFaces = size(AFT_stack,1);
% SourceInfo = zeros(nBoundaryFaces,4); % 存储点源的位置、强度、强度因子
% intensity  = ones(nBoundaryFaces,1);  % 强度因子暂时默认为1.0
% 
% for i = 1:nBoundaryFaces
%     node1 = AFT_stack(i,1);
%     node2 = AFT_stack(i,2);
%     
%     xcoord = 0.5 * ( Coord(node1,1) + Coord(node2,1) );
%     ycoord = 0.5 * ( Coord(node1,2) + Coord(node2,2) );
%     
%     sp = sqrt(3.0)/2.0 * DISTANCE( node1, node2, Coord(:,1), Coord(:,2));
%     
%     SourceInfo(i,:)=[xcoord, ycoord, sp, intensity(i)]; % 存储点源的位置、强度、强度因子
% end

%  SourceInfo = [-4, 4, 0.9, 1;
%                -4,-4, 0.9, 1;
%                 4,-4, 0.9, 1;
%                 4, 4, 0.9, 1; 
%                 0, 0, 0.01, 2;
%                 2, 2, 0.01, 1;
%                 -2, -2, 0.01, 1];

 SourceInfo = [-10, 10, 2.2, 1;
               -10,-10, 2.2, 1;
                10,-10, 2.2, 1;
                10, 10, 2.2, 1; 
                0,  10, 2.2, 1;
                0, -10, 2.2, 1;
                -10, 0, 2.2, 1;
                10,  0, 2.2, 1; 
                -0.5, 0, 0.015, 1;
                 0.5, 0, 0.015, 1;
                  0, 0, 0.06, 1];
