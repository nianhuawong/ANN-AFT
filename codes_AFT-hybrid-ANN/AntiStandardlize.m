function outPoint = AntiStandardlize( pointIn, refPoint1, refPoint2 )

outPoint = zeros( size( pointIn, 1 ), size( pointIn, 2 ) );
if size( pointIn, 2 ) == 2
    for i = 1:size(pointIn,1)
        [outPoint(i,1), outPoint(i,2)] = AntiTransform(pointIn(i,:), refPoint1, refPoint2);
    end    
elseif size( pointIn, 2 ) == 4
    for i = 1:size(pointIn,1)
        [outPoint(i,1), outPoint(i,3)] = AntiTransform([pointIn(i,1), pointIn(i,3)], refPoint1, refPoint2);
        [outPoint(i,2), outPoint(i,4)] = AntiTransform([pointIn(i,2), pointIn(i,4)], refPoint1, refPoint2);
    end
end