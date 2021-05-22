function [lower, upper] = SourceImpact(SourceInfo,xNode, yNode)
numberOfSources = size(SourceInfo,1);
upper = 0; lower = 0;
for k = 1:numberOfSources
    xSource   = SourceInfo(k,1);
    ySource   = SourceInfo(k,2);
    Sn        = SourceInfo(k,3);
    intensity = SourceInfo(k,4);
    
    dis = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40;
    In  = Sn  / dis / dis;
    Jn  = 1.0 / dis / dis;
    
    upper = upper + intensity * In;
    lower = lower + intensity * Jn;
end
end