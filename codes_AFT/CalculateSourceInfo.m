function SourceInfo = CalculateSourceInfo(AFT_stack,Coord)
disp('设置热源...');
% an = 1; bn = 0; alpha = 1.0; u = [-1 1];
type = 3;
% type = input('设定SourceInfo的方法（1-人工设置，2-图中点选，3-根据BC设置）：');
%%
if type == 1
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
%   SourceInfo_line =  [];    
elseif type == 2
    %% 在计算域中点选几个点源
    X=[];Y=[];
    button = 1;
    % axis([-0.2 1.2 -0.1 0.1])
    axis([-0.7 0.7 -0.1 0.1])
    while (button~=3)
        [x1,y1,button] = ginput(1);   %前面的点源用鼠标左键选择，最后一个点源用鼠标右键选择
        plot(x1,y1,'b*')
        X = [X;x1];
        Y = [Y,y1];
        if button == 2
            axis tight; axis equal;
        end
    end
    
    nBoundaryFaces = size(AFT_stack,1);
    nSources = size(X,1);
    SourceInfo = zeros(nSources,4); % 存储点源的位置、强度、强度因子
    
    for k = 1:nSources
        xSource = X(k);
        ySource = Y(k);
        
        minDist = 1e40;
        for i = 1:nBoundaryFaces
            node1 = AFT_stack(i,1);
            node2 = AFT_stack(i,2);
            
            xcoord = 0.5 * ( Coord(node1,1) + Coord(node2,1) );
            ycoord = 0.5 * ( Coord(node1,2) + Coord(node2,2) );
            
            dist = sqrt( ( xcoord - xSource )^2 + ( ycoord - ySource )^2 ) + 1e-40;
            if dist < minDist
                minDist = dist;
                index = i;
                xNode = xcoord;
                yNode = ycoord;
            end
        end
        
        %     SourceInfo(k,1) = xSource;
        %     SourceInfo(k,2) = ySource;
        SourceInfo(k,1) = xNode;
        SourceInfo(k,2) = yNode;
        SourceInfo(k,3) = AFT_stack(index,5);
        SourceInfo(k,4) = 1.0;
    end
    SourceInfo
    
elseif type == 3
    %% 直接采用所有边界阵面作为点源，貌似不行?
    nBoundaryFaces = size(AFT_stack,1);
    SourceInfo = zeros(nBoundaryFaces,4); % 存储点源的位置、强度、强度因子
    
    for i = 1:nBoundaryFaces
        node1 = AFT_stack(i,1);
        node2 = AFT_stack(i,2);
        
        xcoord = 0.5 * ( Coord(node1,1) + Coord(node2,1) );
        ycoord = 0.5 * ( Coord(node1,2) + Coord(node2,2) );
        
        sp = sqrt(3.0)/2.0 * DISTANCE( node1, node2, Coord(:,1), Coord(:,2));
        
        intensity = 1.0;      % 强度因子暂时默认为1.0
        SourceInfo(i,:)=[xcoord, ycoord, sp, intensity]; % 存储点源的位置、强度、强度因子
    end       
end
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

