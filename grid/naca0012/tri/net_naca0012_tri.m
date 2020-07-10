function [Y,Xf,Af] = net_naca0012_tri(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 10-Jul-2020 17:08:35.
%
% [Y] = myNeuralNetworkFunction(X,~,~) takes these arguments:
%
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = Qx8 matrix, input #1 at timestep ts.
%
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = Qx3 matrix, output #1 at timestep ts.
%
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [-5;-5;-5;-5;-5.49717418910378;-5.49717418910378;-5.49717418910378;-5.49717418910378];
x1_step1.gain = [0.181818181818182;0.181818181818182;0.181818181818182;0.181818181818182;0.181911313432732;0.181911313432732;0.181911313432732;0.181911313432732];
x1_step1.ymin = -1;

% Layer 1
b1 = [2.8389139311513758024;2.4445914480414021597;-4.3722386836681916833;2.510102124795503542;-1.5007929562652149169;0.55076999099972201446;3.0755714558338111964;2.1497135591897094109;0.75229505091534154548;-1.027495832413722443;-0.86352483323240758484;-0.17916809693027238581;1.1910069417744633125;-0.30303876010516767048;-1.9804612115552593377;-0.13975481100748973762;0.68674110137162058809;0.14373499365277292439;-0.20945697392196876985;1.1025377454878666494;-1.1034282254447915772;-1.2045485572680567632;-3.4530354797612119455;0.41710284044237938561;-0.98415399027469507853;-0.53494339792456213623;1.0440262874262886683;-2.7409031107645178693;-0.030062547725855311848;-1.6028812010092861051;1.4254400053669169512;-0.858850806442264747;-0.86092024268191291725;2.4902576728484944191;-3.5703458410386059718;-2.2535427918443362572;-0.55811910976627887582;-0.92846364319800434028;-1.8142010262646177665;1.6032564448049462236];
IW1_1 = [-0.1749813814006170587 0.99361365341861218603 -0.65119531170488553773 -0.65649628666832937629 -0.22700319821501704909 -0.85754737931693103548 0.98700353676347130083 -0.55009546979990631144;-0.021237192071401386761 0.41173491610288526221 -0.46665663791596712073 -0.36886614949259088903 -0.076077343984518264186 0.46913717120992087795 -0.5855275864089087845 -0.29120586191220243499;-1.0498154871529807863 -2.0753523893116918586 -0.12497071866095560422 -0.3525960432205872408 -0.65988020881298403708 -0.42803736649624457566 1.3884397063332429845 0.31463135760392263451;-1.9714526336685100905 -1.3515204958663546986 0.91512728696275558171 2.3183309147377682002 -0.69430042708649597483 0.77420314702318449029 1.1201822388441495804 -1.0709586784018061412;2.8736310530864535018 -1.3453122160498811599 -1.0272880869156806316 -0.53640596318671074361 1.105035208868018648 -3.1125798414155001481 1.6529431090513599933 0.27665606828228400671;0.045972838847622987668 2.7357802887548414716 -2.6560763217493210675 -0.086621567392099460547 0.19165283964973373054 0.21375980821766668583 -0.75747340685105735147 -0.06981874693045471425;-1.0609690349047662394 -2.4020835856060047675 -1.0775418061350485743 -0.45068951126408929309 -0.70166655101133879047 -0.69345930800778210479 1.9207321350329282783 1.349894369795123783;0.080851732157147596092 -1.0157544625607599631 -0.18709840557962623131 -0.61344577896876451018 -0.35955955710811843273 -2.8115371153137802551 0.098758069512430185499 -0.25236233539403846171;-0.34852095116525699803 -0.96205310076761163529 0.34517999662038423292 0.10816817318264944359 -0.48366511244918292123 -2.0614553105329722626 2.1139928230309892321 0.18671295606094620578;0.50840704880956877343 0.22995910720635842628 -0.45165448722736939446 -0.33525463552479123353 0.74699585773796350896 2.6432890055237385774 -3.453588784386187438 -0.1088713029194841031;0.090228645131953014169 3.4536208121479612387 -3.4112165163380208099 -0.18322613106947391315 0.28749590843516714678 0.054868316948618919837 -0.90974329108545204381 -0.12994780523146143292;-0.23008865085031185438 -0.36696823412923940122 -2.3310872632345347455 -0.89776547204110734857 -0.81787072699802421116 -2.3160500112167548004 -0.77081199788802590156 -0.54143735925269698139;0.050512077082392907446 -4.6336043683166892038 4.650188692152596559 0.027205651223944901651 -0.0085111026281049374093 -1.2879019518018473001 1.1273625211801703294 0.057234128961717450901;-0.0041353779301934318058 5.2205427183502903787 -5.1867953928271584019 -0.0076764958359615909425 -0.089190367845099136068 -1.7761486852625205657 1.8665308066040058321 -0.0025498711834106946132;0.33076105379332854106 1.7454623810936218398 5.348324299445406993 2.6053067123602331456 2.0204835393192048798 3.3674424338630055686 -0.4314982320479593958 -0.56617630973076438217;-0.27177928457210337454 -3.0048731040384111246 4.2786806757201265583 0.038764227077271971866 -0.031427069290302304949 -2.9909608487342684846 1.5513864544822242308 0.23980545352585838637;-2.8525102878706101173 -3.198413645231546365 -4.6807924916242562574 -3.5671295096013748704 -3.6178659369914614174 -3.0098998249482962208 -4.1428242464253806077 -2.9406414691131059769;0.11286771158017357142 2.1769450368421412456 -2.1303262101117277361 -0.1415453712279687859 0.15802136885830059265 -5.1491918721554030824 5.009777188678173232 -0.036044903861239908915;-0.12578892776716849022 -2.008979876191936853 2.1970498904217521385 -0.081917001572341219262 0.10332799025149122518 -4.3951040026527161686 4.3230888647782617085 -0.050786364907372427702;-1.5725315000022410672 -4.1200930233805976854 1.8238762266438155457 0.86265901824895796501 0.43896658710837221928 1.6997727591448932305 5.0276857610867775605 1.0528732218628600315;-0.165382954682064931 -0.63241160242907223932 1.2705040972747152495 0.54431009123047791043 0.50224590455331141747 1.4734011667101631904 1.0795271511703727896 0.18254155389079165794;-1.8121639904627750983 -3.1352862329430841726 -1.5329985882162360245 0.27747487647113983078 0.035849572088774053769 1.8236764655246691103 3.6857394690349889466 1.1068408503597830794;-4.5665216768746557108 -6.741668058864474844 -6.5798507651449362754 -4.8077789390442262629 -2.5226008641957591294 -0.56937169571568424509 1.554390616629575339 2.7372580221478273188;0.12203851306114785191 -1.7799572548162068131 1.7512768815857899796 -0.17620202277143157121 0.40393400742878110554 1.4074111770837791635 -1.7583960814863743849 -0.094455611991599394694;-2.5270551452974854278 -1.614084321884871942 1.7784505486708042099 2.9867394099420581099 4.3360371954692551455 6.1248205081561151175 7.681790129198590833 4.9567926374434172487;2.1388490969225260052 2.3776914197869727374 4.2719460160252769043 2.8414879435913031891 2.8646127912251078129 2.9849489578719570204 3.0449720889030578164 2.3208714082752495145;0.74431216075360129292 1.1016039701469313439 0.21638090107656024474 -0.23847697522707533846 0.75153144560654805417 1.7773776564227630193 -1.7980956977961797261 -0.30697130048964382798;-0.92176161997922223534 -2.1691458938370606901 1.0173599629398544231 0.83694699026114438567 0.16354315843699376853 2.6749564369436122924 2.9594395104224551218 0.15939855665080254754;-0.096780479522771314937 -0.908941516078695666 0.8551241405443004151 0.10240301410441682295 -0.1654116613033487504 1.5043796034227920888 -1.3358323375667051636 0.03611520983640366389;-0.35703849312279667405 1.8082119572185688661 -0.34974865251608994177 -0.084365113217726162009 -0.12751059929110886149 -1.7978422266645859295 0.48337703869324100125 0.1678161943261999578;4.2016386124643601008 -1.5768902456470204054 -2.1719834242645168487 -0.36145083210641448801 1.9883661352419024215 -2.5636426414505879556 0.50982574408680170208 0.12144419525874640409;-0.89923914227959211853 -0.013489603212369138951 0.55176525907705831209 0.10666084673789698323 -0.54196410580956377867 -0.52667030955250615509 0.85833959814496540996 -0.0020293481760217235016;1.3683764547801489098 1.6220629095472030023 -3.0667356766378413013 -2.2830287814320886497 -2.5340168091036727738 -5.9405215009696732409 -5.0425784199078886871 -2.3541594968969312696;0.31215529061992852711 0.78514862685829811539 -2.6673749140453906215 -1.3900973289079865403 -1.1290944072130253417 -3.2896218749640140366 -2.1438554178632838187 -0.54366302524576037847;2.9412889132618933452 1.5630528106056218451 -1.059249058581940961 -1.6332828811449215944 -3.9157793012128196963 -3.2511230549136276302 -3.5427895700224505404 -3.6694249591444516589;-0.29720071861155789028 -0.3123868608535644853 1.8727300144266438853 0.5390309922241766083 0.32605319848266678395 2.1233982237357129641 0.85682984165545683641 0.20732375972688443788;0.070457113276925512069 -0.48390430382655058583 -0.12587081902415614421 -0.059352807215391358009 0.076128179735746384638 1.8275134529863528154 -1.3185908222821320912 0.042833079649533929711;0.085145385845978416306 -2.6345194635554141094 2.567885764715645891 -0.0069528275326497575998 -0.0032331003971572385564 -1.8790844730491791381 1.8456926737107657299 0.03634852174256013313;-0.28671724569925088888 3.3434067712420429963 -2.5020137080171807042 -0.24255009457339024581 -0.11544031721678148228 0.0017223873832019167326 -0.35347913122476548597 0.11193748155356612883;1.3638650803025618163 3.3104353031874769187 -1.0737692393940492241 -0.59087379984295895774 1.0782834506970464528 0.46933712724649429004 -0.18227984063421173722 -0.58003443231684603809];

% Layer 2
b2 = [0.52597759031625002102;1.3003754619797029957;2.3154012581246377067];
LW2_1 = [-1.2774390184384472047 0.94650546320307826775 -0.035797864488209638067 -1.757135799950805044 -1.381039368435279524 0.010711071349655654217 -0.00081971553919636306294 -0.044229642117869658047 -0.45542514665458233569 -0.78806514740231803362 0.14340250860741793337 -0.0015368217165695075704 0.66023543216972768732 -0.57554050662640843239 0.0016259112899535649137 0.039183301290042681087 -0.0034822076534197026441 -1.2900861646394463644 -1.490540799556004492 3.2366772530936385548e-05 -0.0050964169301615713445 0.00089431144003710545069 0.00024320639721865590539 -1.4106824237817503498 9.5536885159158848419e-05 -0.0041442409662438752654 0.16285168924264606383 0.00085896779684410760197 -5.9051366775694198452 0.13101257991573161954 -0.6253012707786367308 -1.2800466009611182194 -0.00019990684843736283957 -0.0019455348645195593045 9.1279765293287059419e-06 -0.040252323996314974541 -0.15388523089895461693 3.2361980044806921697 -1.6502988681970716112 -0.041407211933984222618;-0.1591604706484988363 -0.73956587317885991162 -0.0073728113279840469876 0.58494724602092218468 0.37356596802253366763 -2.0429994320364976979 0.00091110167399391069412 0.049669041160145727121 -0.047191310262276464638 -0.062328441597392376938 -0.77235186332628746886 0.00049866518763674763486 -2.2347968760125200838 -1.2604392627439164887 0.00041241024056914922687 -0.056495294475709986748 -0.0024272236844096427288 -0.55132302841085290002 0.49702674688985282181 -0.00074130150469738260999 0.0091553219210023621677 -0.00062706311160549022682 0.00050787907407460097971 -0.84071777499313815607 0.00055394527329793010004 -0.002712538155125773353 0.057196489782178394634 -0.000994459886140967083 -3.4189470172383318314 -0.16578054528251276456 0.13957102602790819046 0.2711108813404720097 0.00037057430091899971284 0.0015083073316349779065 -0.00078616226037740775771 0.043203241086422948525 0.095654132330683497298 -3.859753335620840442 1.2543753654131752917 -0.020450780256505238924;1.6236146207734247771 1.7277598716535005341 0.1846151527761937805 1.8618621541898019434 0.68630923635368457081 -0.94903679555436737392 0.33742673264886408058 0.037374797195015942164 -1.1381497470322314847 1.8798355290120398742 0.11459912999011881429 0.93127934002107204403 -1.593699762096691952 1.8761521043029498745 0.18566977853816837851 0.21912705274136060063 2.1326337098124916736 -2.8043490049058288349 2.2962024224494856917 -0.4339705712558061812 1.9756888637911773632 0.27732236214586813983 0.15162773570332183093 -2.0420016905870115309 0.22377492991905295616 2.6016255632161993105 -0.20105733671515957361 -0.42388860741741207772 -0.41477499323609390292 0.38098066362252958061 -0.87326459581483706351 -1.5103686889859211373 0.32187127245392982422 0.80586479281606482328 -0.11704119487400235777 -0.7282143647423994226 0.29493454396043300436 2.1713375665974461448 -1.287614132351096341 0.11542319061887693077];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.181818181818182;0.181911313432732;4.97666315021588];
y1_step1.xoffset = [-5;-5.49717418910378;0.000119980242480761];

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX
    X = {X};
end

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
    Xp1 = mapminmax_apply(X{1,ts},x1_step1);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = repmat(b2,1,Q) + LW2_1*a1;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1);
    Y{1,ts} = Y{1,ts}';
end

% Final Delay States
Xf = cell(1,0);
Af = cell(2,0);

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
