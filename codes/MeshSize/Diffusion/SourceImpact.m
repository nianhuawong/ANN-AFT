function [lower, upper] = SourceImpact(SourceInfo,xNode, yNode)
%% 密度方向性控制参数
an = 1.5;           % 影响半径1,4
bn = 1.0;           % 方向强度因子
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
    line_source_sn = SourceInfo(k,5);
    
    intensity = Cal_Intensity_Single(an, bn, u, alpha, xSource, ySource, xNode, yNode);
    
    if line_source_sn > 0
        P1 = [SourceInfo(k,1),SourceInfo(k,2)];
        P2 = [SourceInfo(k,3),SourceInfo(k,4)];
        fl = line_source_sn;
        [In, Jn] = LineSourceImpact(xNode, yNode, P1, P2, fl);
    else
        dis = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40;
        In  = Sn  / dis / dis;
        Jn  = 1.0 / dis / dis;
    end
    
    upper = upper + intensity * In;
    lower = lower + intensity * Jn;
end
lower = lower + 1e-40;
end

function intensity = Cal_Intensity_Single(an, bn, u, alpha, xSource, ySource, xNode, yNode)
% if an == 0 
%     intensity = 1.0;
%     return;
% end
%% pirzadeh 1993论文中计算source intensity的方式
rn = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40;
vector_v = [xNode - xSource, yNode - ySource] ./ rn;
fai = ( 1 - abs(alpha)/2.0 ) * vector_v * u + alpha/2.0 * abs(vector_v * u);
k = 10; beta = 1;
if alpha * vector_v * u < 0 
    beta = 0;
end
intensity = an * beta + bn * power(abs(fai), k);

%% 按照a^x的变化规律设置影响域
% rn = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40;
% coeff_a = 10^( log10(0.01) / an );
% intensity = bn * coeff_a ^ rn;

% disp('影响半径（intensity >0.01 ）:');
% radius = log10(0.1) /log10(coeff_a)

%% 按照1/(1+ax)的规律设置影响域
% rn = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40;
% coeff_a = ( 1 / 0.01 - 1 ) / an;
% intensity = bn * 1.0 / (coeff_a * rn + 1.0);

% disp('影响半径（intensity >0.01 ）:');
% radius = ( 1 / 0.01 - 1 ) / coeff_a
%%

%% 按照紧支基函数确定强度
% rn = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40;
% ksi = rn / an;
% if ksi >= 1
%     intensity = 0.0;
% else
%% Wendland's C0
%     intensity = ( 1 - ksi )^2;                      
%% Wendland's C2    
%     intensity = ( 1 - ksi )^4 * ( 4.0 * ksi + 1 );
%% Wendland's C4
%     intensity = ( 1 - ksi )^6 * ( 35.0 * ksi^2 + 18.0 * ksi + 3 );    
%% Wendland's C6
%     intensity = ( 1 - ksi )^8 * ( 32.0 * ksi^3 + 25.0 * ksi^2 + 8.0 * ksi + 1 ); 
%% compact TPS C0
%     intensity = ( 1 - ksi )^5;
%% compact TPS C1
%     intensity = 3 + 80 * ksi^2 - 120 * ksi^3 + 45 * ksi^4 - 8 * ksi^5 + 60 * ksi^2 * log(ksi);
%% compact TPS C2a
%     intensity = 1 - 30 * ksi^2 - 10 * ksi^3 + 45 * ksi^4 - 6 * ksi^5 - 60 * ksi^3 * log(ksi);
%% compact TPS C2b
%     intensity = 1 - 20 * ksi^2 + 80 * ksi^3 - 45 * ksi^4 - 16 * ksi^5 + 60 * ksi^4 * log(ksi);
% end
% intensity = intensity * bn;
%%
end
