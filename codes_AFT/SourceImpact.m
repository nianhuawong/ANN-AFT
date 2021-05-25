function [lower, upper] = SourceImpact(SourceInfo,xNode, yNode)
%% 密度方向性控制参数
an = 1;           % 影响半径
bn = 0.0;           % 方向强度因子
alpha = 1.0;        % 方向系数
u = [0 0]';         % 作用方向
%%
numberOfSources = size(SourceInfo,1);
upper = 0; lower = 0;
for k = 1:numberOfSources
    xSource   = SourceInfo(k,1);
    ySource   = SourceInfo(k,2);
    Sn        = SourceInfo(k,3);
%     intensity = SourceInfo(k,4);
    intensity = Cal_Intensity_Single(an, bn, u, alpha, xSource, ySource, xNode, yNode);
    
    dis = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40;
    In  = Sn  / dis / dis;
    Jn  = 1.0 / dis / dis;
    
    upper = upper + intensity * In;
    lower = lower + intensity * Jn;
end

end

function intensity = Cal_Intensity_Single(an, bn, u, alpha, xSource, ySource, xNode, yNode)
k = 10; beta = 1;
% if size(u,1) == 1 && size(u,2) == 2
%     u = u';  %把u转换成列向量
% end
if an == 0 
    intensity = 1.0;
    return;
end

rn = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40;
vector_v = [xNode - xSource, yNode - ySource] ./ rn;
fai = ( 1 - abs(alpha)/2.0 ) * vector_v * u + alpha/2.0 * abs(vector_v * u);

if alpha * vector_v * u < 0 
    beta = 0;
end
intensity = an * beta + bn * power(abs(fai), k);
end