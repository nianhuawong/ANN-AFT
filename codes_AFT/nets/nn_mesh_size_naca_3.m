function [Y,Xf,Af] = nn_mesh_size_naca_3(X,~,~)
%NN_MESH_SIZE_NACA_3 neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 25-Jan-2021 16:37:34.
% 
% [Y] = nn_mesh_size_naca_3(X,~,~) takes these arguments:
% 
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = 1xQ matrix, input #1 at timestep ts.
% 
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = 1xQ matrix, output #1 at timestep ts.
% 
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1_xoffset = 0;
x1_step1_gain = 2.00345633024112;
x1_step1_ymin = -1;

% Layer 1
b1 = [0.29271920138760577;-3.2686988078694865;-7.7191624793180011;5.4063799592726651;1.6713220357927443;-0.30372159792581838;1.3358767444051878;0.9052369507724578;0.60655489678269958;-1.6537745481700405];
IW1_1 = [-0.48633076945478554;5.9298669320206816;13.117849221235288;-9.2903917753197831;-3.5399544168707235;-6.3241985099160241;6.4553036285202934;2.1857151768515264;4.6737583520612542;-1.6156862190423469];

% Layer 2
b2 = 0.62287053098386291;
LW2_1 = [0.77661175854803521 -2.2423587106213416 -1.5852276862226526 -2.793211909235191 -1.6860753927455481 -1.071098743163228 1.0818293213410255 1.4857021855165111 -2.4501822658947852 1.6440776152282903];

% Output 1
y1_step1_ymin = -1;
y1_step1_gain = 2.56709073138056;
y1_step1_xoffset = 0.323266012932347;

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX, X = {X}; end;

% Dimensions
TS = size(X,2); % timesteps
if ~isempty(X)
    Q = size(X{1},2); % samples/series
else
    Q = 0;
end

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS

    % Input 1
    Xp1 = mapminmax_apply(X{1,ts},x1_step1_gain,x1_step1_xoffset,x1_step1_ymin);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = repmat(b2,1,Q) + LW2_1*a1;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1_gain,y1_step1_xoffset,y1_step1_ymin);
end

% Final Delay States
Xf = cell(1,0);
Af = cell(2,0);

% Format Output Arguments
if ~isCellX, Y = cell2mat(Y); end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings_gain,settings_xoffset,settings_ymin)
y = bsxfun(@minus,x,settings_xoffset);
y = bsxfun(@times,y,settings_gain);
y = bsxfun(@plus,y,settings_ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n)
a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings_gain,settings_xoffset,settings_ymin)
x = bsxfun(@minus,y,settings_ymin);
x = bsxfun(@rdivide,x,settings_gain);
x = bsxfun(@plus,x,settings_xoffset);
end
