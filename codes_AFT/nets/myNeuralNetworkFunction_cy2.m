function [Y,Xf,Af] = myNeuralNetworkFunction_cy2(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 04-Jul-2020 17:25:01.
%
% [Y] = myNeuralNetworkFunction(X,~,~) takes these arguments:
%
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = Qx8 matrix, input #1 at timestep ts.
%
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = Qx2 matrix, output #1 at timestep ts.
%
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1_xoffset = [-10;-10;-10;-10;-10;-10;-10;-10];
x1_step1_gain = [0.1;0.1;0.1;0.1;0.1;0.1;0.1;0.1];
x1_step1_ymin = -1;

% Layer 1
b1 = [1.6227496963195374;0.64159481426525977;0.46434213236289856;1.3184479209869882;0.82309573359774935;-0.77165131354663496;2.0952221374504605;0.014671151846192393;0.015674020023469223;-0.22152013294509912;-0.4003734015985197;2.7930374345002051;-0.043767696688462095;0.05620405260424003;-0.30802428415657623;3.5032989132810735;-2.0756386755695599;-2.0383432078839983;-1.4895906950297892;-0.87176356012923206];
IW1_1 = [-0.040910662870155712 -0.85073828570816412 2.2928488429521132 0.16652526865947676 0.15044847622016858 1.4371162064912457 -0.78223029375568764 0.0030305156500172905;0.0082421980534913425 0.068657411485472511 -0.22211407644666495 -0.0070488979197030803 0.003701664050781559 0.19492177368577959 -0.15406591446299975 -0.012370396021032296;-0.09694899805076157 0.75668299297615182 0.44047366181830999 0.076559322821319678 0.11925942892670995 3.5215746931732976 0.43549293511850301 -0.16987212478647454;-0.27452805159029137 -4.5383415825327615 4.0583994130466072 0.20167476536256612 0.11170368939633853 -1.5641237470298179 2.4590505484756489 0.27918374649605371;0.21143753562415737 2.8842562502179856 -5.2124836026495425 -0.30600989691838676 -0.2482110192742028 -0.63021450759336228 -0.36963737670349456 -0.0059608795167071307;-0.19733949020082905 -2.8015992908574012 5.0103560409265553 0.29340850200467777 0.22895094487116163 0.50287739125725694 0.45361192399441552 0.019982375343350935;-0.023824533150477001 1.1878566088509723 1.6324652056930431 -0.013186718405462358 0.14149072538724225 4.501210005057092 -6.3552355431025473 -0.34677224157803721;0.56079064240286525 10.350404342963948 -10.633259759279198 -0.45520553939298775 -0.089592455042077912 4.5279660174640819 -4.150209341034067 -0.37879830426124361;0.28806569076840671 8.1563323594963961 -7.7061590856379683 -0.58354270305468559 -0.44236022046457901 -4.8737858150248243 5.2811965738554347 -0.0079021419103441175;-0.33082186546790809 -6.8618303082010286 2.7577298810666848 0.4136204730593212 -0.10395371069162805 -0.30224514362942417 -1.7859221024876264 0.09103602264936457;0.046069992923726821 -2.2600783419424366 5.386958859349483 0.22174640099054635 0.087472272425488523 -4.91476161795691 2.2597761574981057 -0.16238776897252616;-0.40269759895556884 -4.3995286336391626 0.55598300400280409 -0.0447964335702963 -0.20457979209874025 -7.0648659298863725 8.3117287945664859 0.53924731416769645;-0.16379418007117894 -0.99177804184456031 1.3879342300777919 -0.1546683051808114 -0.33945048101687253 -7.9833400692295777 8.0088237390775028 0.27841477102983025;0.3716095689996658 7.5003525719374915 -6.1328310312500864 -0.41360381051827633 -0.31002422380859473 -6.52236571506368 3.8871540078571387 -0.11433879532333759;-0.0071958900548403206 -0.11305970019863382 0.10696114364087848 0.0054685649735929081 0.0010874425986766975 -0.09622132385232994 0.012525312445123039 0.0048196438997112952;0.17523268595678221 2.9299713634324482 -5.3655601253365282 -0.64239424822639712 -0.65509831933846097 -8.1069170184256727 4.3294582720371491 0.19319851388679787;-0.68477441993784893 -4.9707705085678731 5.5455418861478671 0.66953277307163739 0.077331881236641906 -1.3030906636884474 5.6880064399898673 0.31681790295837547;0.024455994485256864 -1.2671785227597951 -1.4970561173108097 0.0091560060304422559 -0.12649575592613049 -4.2905034052147499 6.0691316113025318 0.33540547286967759;-0.023887360890741685 0.091705487466178251 -0.78715883075318649 -0.05682337154217338 0.080393167746358754 2.1414538143608519 -1.5036760427596771 -0.12978962123982754;-0.13691938772947795 -2.2034766594827713 2.1054045685566969 0.12303915349495757 0.044973600107703605 -0.77928614124552387 1.198687285618081 0.12559098510553227];

% Layer 2
b2 = [1.7434144510804617;-2.3062583795134626];
LW2_1 = [0.2131152605940293 -5.4533800857885044 0.014859219425486089 -0.11128724098424182 0.7726023031976772 0.87163563692232249 -0.025416631471890938 0.026748303507509154 -0.068170967014822559 -0.018673425158671274 0.022052116851782443 -0.043271649737415832 -0.12021143131820762 0.031467248889071125 -3.1157637230422885 -0.060974668371275194 0.0026690944518401797 -0.072923380048518407 -0.2066866638323383 -0.31261972797556475;0.032176752781190553 -0.76652992583228508 0.027827530119862651 0.19782682495948342 -1.4179544228081005 -1.520113657459931 1.5038715130282287 -0.1013880130420842 -0.097904561612449939 -0.034356225067368323 -0.029100743123582965 0.017000986065937553 0.016058360700445119 0.019119401652552579 -9.6904892259753908 -0.02468326988222869 0.036010160480332329 1.5490000974558564 0.014354618075808165 0.43856234091572643];

% Output 1
y1_step1_ymin = -1;
y1_step1_gain = [0.1;0.1];
y1_step1_xoffset = [-10;-10];

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX, X = {X}; end;

% Dimensions
TS = size(X,2); % timesteps
if ~isempty(X)
    Q = size(X{1},1); % samples/series
else
    Q = 0;
end

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS
    
    % Input 1
    X{1,ts} = X{1,ts}';
    Xp1 = mapminmax_apply(X{1,ts},x1_step1_gain,x1_step1_xoffset,x1_step1_ymin);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = repmat(b2,1,Q) + LW2_1*a1;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1_gain,y1_step1_xoffset,y1_step1_ymin);
    Y{1,ts} = Y{1,ts}';
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