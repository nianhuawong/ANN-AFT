function outPoint = AntiStandardlize( pointIn, refPoint1, refPoint2 )

outPoint = zeros(size(pointIn,1),2);
for i = 1:size(pointIn,1)
    [outPoint(i,1), outPoint(i,2)] = AntiTransform(pointIn(i,:), refPoint1, refPoint2);
end