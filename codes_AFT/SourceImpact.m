function [lower, upper] = SourceImpact(SourceInfo,xNode, yNode)
%% �ܶȷ����Կ��Ʋ���
an = 0.2;           % Ӱ��뾶
bn = 1.0;           % ����ǿ������
alpha = 1.0;        % ����ϵ��
u = [0 0]';         % ���÷���
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

if an == 0 
    intensity = 1.0;
    return;
end

rn = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40;
vector_v = [xNode - xSource, yNode - ySource] ./ rn;
fai = ( 1 - abs(alpha)/2.0 ) * vector_v * u + alpha/2.0 * abs(vector_v * u);
% if fai~= 0
%     kkk = 1;
% end

if alpha * vector_v * u < 0 
    beta = 0;
end
% intensity = an * beta + bn * power(abs(fai), k);
%%
coeff_a = 10^( log10(0.01) / an );
intensity = bn * coeff_a ^ rn * beta;

% disp('Ӱ��뾶��intensity >0.01 ��:');
% radius = log10(0.1) /log10(coeff_a)


% coeff_a = ( 1 / 0.01 - 1 ) / an;
% intensity = 1.0 / (coeff_a * rn + 1.0);

% disp('Ӱ��뾶��intensity >0.01 ��:');
% radius = ( 1 / 0.01 - 1 ) / coeff_a
kkk =1;


% term1 = beta * bn * power(abs(fai), k) / rn;
% if rn > an
%     term1 = 1e-40;
% end
% 
% intensity = term1;
end