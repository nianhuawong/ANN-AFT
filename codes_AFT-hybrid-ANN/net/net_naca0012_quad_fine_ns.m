function [Y,Xf,Af] = net_naca0012_quad_fine_ns(X,~,~)
%NET_NACA0012_QUAD_FINE_NS neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 12-Aug-2020 17:44:02.
% 
% [Y] = net_naca0012_quad_fine_ns(X,~,~) takes these arguments:
% 
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = 8xQ matrix, input #1 at timestep ts.
% 
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = 4xQ matrix, output #1 at timestep ts.
% 
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [-10;-10;-10;-10;-10;-10;-10;-10];
x1_step1.gain = [0.1;0.1;0.1;0.1;0.1;0.1;0.1;0.1];
x1_step1.ymin = -1;

% Layer 1
b1 = [-3.0822450193485537717;1.0890529611450956438;0.40577726824518489668;-0.037981017824081149403;2.1711529989816500397;-0.039037246722644608488;-0.063607486724790052168;-0.046071219956972352116;0.28613893432069764655;-1.0016779126164034874;0.50291600322144658364;-0.83081386895306219564;0.010487026113861390789;0.43523012269088701132;-0.98904589078337457053];
IW1_1 = [0.074326162517233798632 -0.080011420786574777297 0.71132617887517113342 0.070957145762899298536 0.3321769045989471647 1.0215909385114287922 1.0153501989513917803 -0.028636638419106557468;-0.0056054600009608742187 -0.52384197733915027761 -0.12643149727700256357 0.0076798304210124136368 -0.004521247828349580708 -0.21925100010114398352 0.13521932946517586926 -0.0070542302928683136773;0.010065231113284554484 0.52299720720034537091 0.01530698104618955814 -0.0055610811328350752414 -0.00028546715559164094001 0.11540997029259833506 -0.038208667435801250967 0.0087279357637131040754;-0.023303074023971925149 -0.96873105001939852077 2.2225099003594284142 -0.029421316715626737864 -0.073979683941814200487 -2.3426873811652551005 2.6949077232998246423 0.1616912936414747759;-0.00064859382596507730075 0.50804506170520657982 -0.75040649925895719363 0.037406546873027253508 -0.065328335017065822243 -2.2690568742767953658 0.57408322601257466555 0.0090900653710155997905;0.73462918328038795401 1.4233996546798217686 2.2681939129997599203 0.51719310992956579742 -0.62639152466889591597 -1.2914624962891498861 -2.1063434433701400117 -0.66729495797147064806;-0.037778725353830915068 -4.2458741364399639195 4.1550931974016638293 0.098245169286019159993 0.040671663027332993767 5.3886651737008017804 -5.4298134810732321398 -0.06109076368862906975;0.0088400552703594443421 1.6161930460484368322 -1.6285925274182913025 -0.041137512733848032032 -0.022286480058647004793 -2.2293691995217930213 2.3755133231256575499 0.024531458428052013016;0.055543749811364798163 2.3914248829521049799 -2.4628079970539307197 0.015716628165675552986 0.016844721858215505605 0.46599013103627934251 -1.0490470109332414861 -0.016648482515507968815;-0.029087565069080133229 -1.2630524991092215714 1.3117587364137652806 -0.045776368914165525836 -0.069802460739985985883 -1.9072325603608095701 0.57150738797461653196 0.02119555978551632483;-0.030652028380952905939 -1.3408638805675039407 1.2266010834079097425 -0.0071408505084325658158 -0.0037199421762788222219 1.3225354252795489263 -0.8073516947922746434 0.011945954334015955467;0.0067950147805591861253 0.73888513048128157124 -0.77413503507383152336 -0.008871770890285573738 -0.019207664119202157854 -0.88826450755329056097 -0.022399816838186224766 -0.0027404685455923779441;-0.017199030610126127272 -2.3543624348966085691 2.2691946972002647875 0.056731511551378274727 0.010797690058787660916 3.2577443568475135116 -3.0592389512675906005 -0.025984002146547214435;0.038571171106088888991 2.1087648036818316122 -2.1648928259361484017 0.0067332990985072291648 0.01409292932457195148 -0.0010521211864080125525 -0.70821431458289629823 -0.014352981532345676988;-0.017276834768236985773 -1.7907150823498629855 0.98919053804538303876 0.055669981308675169085 0.01834646955795023876 1.3631345641271397362 -1.5206799277977378626 -0.026738431584859743972];

% Layer 2
b2 = [2.4249641437441513681;-0.33062129875187873385;-1.8651883409175620265;-0.077186725196963665296;0.28732487550062607573;0.40247283014240148313;0.39227882308119665922;-0.13518427033936072923];
LW2_1 = [0.23579766418350397994 -0.9535808682761919286 0.46625398576189502897 0.074743709118385806556 -0.48709308473483436952 0.10420874556839213043 0.76611391017904639789 0.21930431841587957886 -0.096781619992074907621 -0.40169856921841684549 0.59416490950576872354 0.53766846716537031181 -2.1275367366429898119 -0.087023619453083095321 -0.76370588106064951628;-0.38166907106704728303 0.3294988564450147539 0.17230016759627514444 -0.020117062043969194396 -0.58844807423252920575 0.12111766272031944391 -1.4979640476229589829 -3.3485947893694176791 0.30702717118775363359 0.095303886861927492036 0.60997069182943930432 -0.34274810383613624198 0.014979405095633099854 -0.72772169934824382231 0.43300683627935521169;-0.20861998621943303456 0.026515924170071016042 0.18410299608554472894 -0.013530505418622293043 -0.23766918228785713363 -0.0027718265233095179187 -1.3814907561517839607 -2.799997960961655874 0.26974524058372989499 -0.55550767291290692462 1.5245229472593475606 0.95931961175242719264 -1.490104086298610131 -0.57800866967900765836 0.26365225540857939457;0.009268404414265905486 0.11349465375586061111 -0.79049678502233444721 0.44922596897504574187 -0.22025396149749529306 0.090119829791361308335 0.86031373104540265206 1.2218011258106407091 0.51119805844602073108 -0.30914192690142100473 0.11220719792375563606 0.45363135043413455039 -0.62703037972974506875 -0.30307026208933895983 -0.8119236421327736819;-0.026149518537388158346 -0.60969900103988972084 1.8269458733856458466 -0.47988346879782539656 0.26897743384075534223 -0.069049101495992637467 -1.5738779834281724224 -1.0331123670856199315 -0.57627707796893168357 0.23782916237731341336 -0.25656233125799154937 -0.087559670671825892696 2.4737675805302963283 0.68605266112806173595 1.1313315507668293414;-0.46467526177087742356 -0.630005554984036098 2.992825924807932747 -0.97510994772591541579 -0.04790556681149606838 -0.078766153081187867402 -0.68079631092305015194 -0.58489845443868537789 -1.0480134321459424473 0.21779444466556008297 1.0821242533669142016 0.23012001524264746877 -0.22872154716922687978 0.76779763193858285852 2.3297805291311091125;0.10177392449778401018 -0.51162295839220706117 1.1704105624268739128 -0.30474142173880769402 0.35878315872330274194 -0.094805943925509755799 0.47488310741282913074 2.2684800942561986759 -0.10846130803201080306 0.052301276231357329838 -0.15513465501757214837 0.085506442288314776778 0.77458843612719663341 0.2981374354968282514 0.62729896832892761971;0.010187387516204838428 -0.020538330173916034826 0.52985934123978184473 -0.57909495436551694514 0.17678909363232928054 -0.1477665937568274912 -0.12239329438535641315 -3.0430053423208907049 -0.82311809346573505675 0.67816949056570630106 -0.011380417577171758614 -1.6467906828614999881 -2.6548642707595333512 -0.3277151116186127755 0.80442530535369694];

% Layer 3
b3 = [-1.4212657005051030357;0.040021991390262877386;-0.11796549901993823306;-1.0042109929954703418];
LW3_2 = [0.59269552559507365785 -0.80256802529355741882 -1.0859724794249128177 4.1843306352532820824 2.0555324499474614264 0.57712102353193406312 -0.19560892111434610707 0.79856061902744324144;0.58963238861533073809 -0.47658131181963486744 0.52244410815314412666 3.7222613907620694107 2.4916590731466201625 0.090261057458950633148 -0.57315535853253118947 1.0699820549529914793;0.38816911201615755811 2.4945220010396154109 0.21879215013802477685 -0.59659814923910181594 -0.87878497213953388201 -1.2650018883169200645 3.7344468050706320916 0.3864787863724586936;0.35958597548267812183 2.3453368109951036047 -0.81800963487867084378 0.13651582408456966466 -1.1119530705890134925 -0.9524414570136142677 3.8401439864509137045 0.58487218018906850237];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.1;0.1;0.1;0.1];
y1_step1.xoffset = [-10;-10;-10;-10];

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX
  X = {X};
end

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
    Xp1 = mapminmax_apply(X{1,ts},x1_step1);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = tansig_apply(repmat(b2,1,Q) + LW2_1*a1);
    
    % Layer 3
    a3 = repmat(b3,1,Q) + LW3_2*a2;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a3,y1_step1);
end

% Final Delay States
Xf = cell(1,0);
Af = cell(3,0);

% Format Output Arguments
if ~isCellX
  Y = cell2mat(Y);
end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
  y = bsxfun(@minus,x,settings.xoffset);
  y = bsxfun(@times,y,settings.gain);
  y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
  a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
  x = bsxfun(@minus,y,settings.ymin);
  x = bsxfun(@rdivide,x,settings.gain);
  x = bsxfun(@plus,x,settings.xoffset);
end