function SpField = CalculateSpByRBF(SourceInfo,range)
global num_label flag_label gridDim dx dy;
disp('RBF插值网格密度场...');
xMin = range(1);% xMax = range(2);
yMin = range(3);% yMax = range(4);
numberOfSources = size(SourceInfo,1);
fai = zeros(numberOfSources, numberOfSources);

r0 = 1;        %紧支半径
for j = 1:numberOfSources
    xSource   = SourceInfo(j,1);
    ySource   = SourceInfo(j,2);
    
    for k = 1:numberOfSources
        xNode   = SourceInfo(k,1);
        yNode   = SourceInfo(k,2);
        
        rn  = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40;
        
        
        fai(j,k) = RBF_func(rn, r0);
    end
end

W = fai \ SourceInfo(:,3);

SpField = zeros(gridDim,gridDim);
fai = zeros(1,numberOfSources);

for i = 1:gridDim
    for j = 1:gridDim
        xNode = xMin + (i-1)*dx;
        yNode = yMin + (j-1)*dy;
        for k = 1:numberOfSources
            xSource   = SourceInfo(k,1);
            ySource   = SourceInfo(k,2);
            
            rn = sqrt( ( xNode - xSource )^2 + ( yNode - ySource )^2 ) + 1e-40;
            
            fai(1,k) = RBF_func(rn, r0);
        end
        
        SpField(i,j) = fai(1,:) * W;
    end
end
disp('RBF插值网格密度场...完成！');
end

function fai = RBF_func(rn, r0)
%% 全局基函数
%% Volume Spline
fai = rn;
%% Thin Plate Spline
% fai = rn^2 * log10(rn);   %不行
%% Multi-Quadric
% c=1e-4;
% fai = sqrt(c^2 + rn^2);
%% Inverse Multi-Quadric
% c=1e-4;
% fai = sqrt(c^2 + rn^2);
% fai = 1.0 / fai;            %不行
%% Inverse Quadric
% fai = 1.0 / (1 + rn^2);   %不行
%% =============================
%% 紧支基函数
% ksi = rn / r0;
% if ksi >= 1
%     fai = 0.0;
% else
    %% Wendland's C0
%         fai = ( 1 - ksi )^2;
    %% Wendland's C2
%     fai = ( 1 - ksi )^4 * ( 4.0 * ksi + 1 );
    %% Wendland's C4
%         fai = ( 1 - ksi )^6 * ( 35.0 * ksi^2 + 18.0 * ksi + 3 );
    %% Wendland's C6
%         fai = ( 1 - ksi )^8 * ( 32.0 * ksi^3 + 25.0 * ksi^2 + 8.0 * ksi + 1 );
    %% compact TPS C0
%         fai = ( 1 - ksi )^5;
    %% compact TPS C1
    %     fai = 3 + 80 * ksi^2 - 120 * ksi^3 + 45 * ksi^4 - 8 * ksi^5 + 60 * ksi^2 * log10(ksi);
% end
end