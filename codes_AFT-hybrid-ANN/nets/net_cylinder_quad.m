function [Y,Xf,Af] = net_cyliner_quad(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 07-Jul-2020 10:31:09.
%
% [Y] = myNeuralNetworkFunction(X,~,~) takes these arguments:
%
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = Qx8 matrix, input #1 at timestep ts.
%
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = Qx4 matrix, output #1 at timestep ts.
%
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [-10;-10;-10;-10;-10;-10;-10;-10];
x1_step1.gain = [0.1;0.1;0.1;0.1;0.1;0.1;0.1;0.1];
x1_step1.ymin = -1;

% Layer 1
b1 = [-1.523816396321590938;-1.0664139161694365932;-3.4507677315817608665;3.3258240739151201382;1.9847055343146156048;3.0181705128219773471;-0.836389230534388739;-1.7967936135063513614;0.26831302277289736935;3.4612097905833336675;1.5158171387865382318;-0.11528716069680508549;2.0238415026433806965;3.4545441530807705632;-0.10274630901872755517;0.85439823495680544685;0.045412391233001260515;1.3546665015725183334;3.4516427750465727975;-2.0497737549373389321;0.06317079502179644146;0.022829184028823709673;-0.24095177286442184816;-0.013588670326029807928;0.14843753308045828931;0.28675825766434021036;-4.3005946059447479612;0.024659075239879525016;2.6496639773095633785;-1.4744218500730201793;-1.5389501265418459308;-2.0354039067570974808;-2.9890328315550545035;1.6060349674895677552;-2.7795372816985302045;7.3272264539344007517;-3.6862520733680330665;1.2515850030041850705;4.718218836469631583;1.7658877140148148133];
IW1_1 = [0.20660396400108763104 1.4229652909286667484 -0.95673549050076001077 -0.057921244474530932111 0.028416559861050186969 0.92483894759123463913 -1.6128793266069145762 -0.099561814750579458178;0.076756427285378195369 -0.9063777793680742878 1.9035662253720981862 0.2520539735335952658 0.082893350143226976479 2.3390065822660894845 -0.45154604183913460425 0.057701864444836110934;-0.062328163245147102933 1.0727332688471793443 -1.4066668317814547962 -0.08946092491058273144 -0.23493766740447954988 0.64106703472814552391 -4.4613240710863024674 -0.48714392832019781654;0.37902668750937423825 1.0123976278953117358 -4.7839367437981401565 0.22730121364664596095 -0.15872739400271046462 -1.9686000306263513604 3.7696400947648016633 0.029281985558932431546;-0.27589002884654861836 -5.6011583966404705492 2.5415962225441468547 -0.28563806900623112117 0.00020234692399519844594 -0.40731738461385635919 -2.9111851462237816612 -0.84968849005217450543;-0.49079088972894852061 -0.053862803250961932555 -2.9109930095634317659 -0.32967142671770072182 -0.45398140698951960914 -4.0243532072712095982 2.4927347660804892726 0.020050195696289230957;0.13336031135713857787 1.2537554489598934371 0.20020013838613948121 0.27861733463766352736 -0.010748591881541945392 0.059695519506172405044 1.3990817625757692166 0.30747457880185152801;-0.088811580964241493286 0.15703942006267612719 -1.7014869894178119569 -0.11638366416034257034 -0.15729838607962548513 -2.8612763014847808485 2.6421366443134135515 0.23375676634715977786;-0.036056114590993414148 1.2033893171525267274 -2.3495444966245719876 -0.1026524659782756671 -0.089484020729372892866 -2.1110777889826266573 2.1027309873600943391 0.18567030028386263818;2.864240302584187603 4.5366767773343568138 3.4998934635374054913 0.85326807383485814285 -3.9409494509010118968 -3.5876039117534301859 -2.5635915310173826853 -0.39362382403639678552;-0.7822406779308238578 -6.2910534056377311884 5.943186674373368561 0.090069231362196841562 -0.27306235083247026862 -5.1485679121376479728 5.7211152589391547352 0.33989766307310365079;0.040047752349480394973 1.2032366503152445159 -1.1821086458194243196 -0.086474937723753905749 -0.065002425379830128249 -0.3127699106871351109 0.0076412566478946068044 -0.041356878344813358117;0.023516352835397734411 -2.530485831904921934 -1.724654656816122289 -0.58204290682294501647 0.67222611255242625816 3.2405163754845145441 -6.197468456318051544 -0.8251741122146842855;0.12646703663397571016 0.50775227090872920854 -0.1873455173800006035 0.052450134776978872553 0.1960358210777449206 -0.95453072351579992816 4.8608059089088238025 0.44832733137597818862;0.31687301789937472041 -0.55818747547832980871 7.0154936257538897948 2.1101897489804404273 0.0574524889632418434 3.5547773911491380439 3.3706951436534882127 0.030221846340683741761;-0.052029287898322035266 0.68896455308780624183 -1.563600916594561463 -0.18966032993591308564 -0.052604909438018224166 -1.3602711136652740898 0.10375734428058031034 -0.082996902592586421776;0.083325638815386057767 1.6187430894318415309 -1.5004598562263999906 -0.066678415619895264888 -0.01427120569546885126 1.0328920243785173483 -0.90628982450375139557 -0.094032493498911587371;0.36952299712620945149 2.9586370644544004449 -6.9263738192326131937 -2.4062832197926198319 1.1040908283958510427 -2.5928975011758597091 -5.0333992218810514885 -1.9667738098369962341;2.7332009960498830914 4.0771897787062583163 3.9911415223988844225 0.83373115576782419467 -4.0177275830579075588 -5.1646281369383082449 -1.0013518853891267835 -0.12529519059431304395;-0.14643517596128768909 0.24728845205786539885 0.022120724511627103126 -0.11821545302900070273 -0.27747454093775064665 -5.7086773842680234026 5.6429259009959666926 0.33454772917869379789;0.010112174656158118974 0.19057416508109087383 -0.23732704256298753354 -0.046145040105019990984 -0.03434445235943232172 -0.18815278038180616171 -0.22898360933068254153 -0.028114045759882733827;0.20360973658989764412 4.3836971176519590188 -4.4074101129119735987 -0.12615791637594539476 -0.0084446192382569822826 2.5787286650218979034 -2.3712183692516659583 -0.18168093644657953845;0.035216437425111962733 -0.53507432517810371575 1.3272432865401138091 0.059656375112912857217 0.066960337277517489873 1.4668132359269985265 -1.442674291487794358 -0.12502024899073044262;0.21586757577025186827 7.9336689132961151216 -7.7657344218907509159 -0.40417255105542027049 -0.4400060129201124326 -5.2641540803310116203 5.7500275498870294655 -0.047733138670029616468;0.057293014081630476431 0.9711848988406494021 -1.0064568216916371934 -0.11001721006480685849 -0.081709948290844908181 -0.73712458286152338083 -0.21448978937823334756 -0.073572916736747054345;-0.026256431825266785679 1.9797468033868288462 -3.4247687280849210545 -0.13742942213016753894 -0.11276768614589491313 -2.6554421064914714989 2.655598465148670595 0.22966722561490554577;1.5111286866460089673 2.961931417133499167 3.5593835569686822495 -0.10264672071241710827 0.94978529905137032419 6.5741838533924878973 -6.8139811035599313627 -1.3631025921475135032;0.015675375459493285507 1.2563521024134529647 -1.3685878933997404072 -0.070287482829967370956 -0.077598217800677785072 -1.468996520006980111 1.2827592616204874787 0.042579304555066026239;0.043269756383043284087 -0.093510387932342939332 1.5275541464841952966 0.3029085250866478396 0.27782049491971932964 3.4848196911459234926 2.5319231784907874072 0.20763148773800063629;-0.54273579188750253888 -3.0121474764284594805 0.40713105379051089949 0.1837486105838583017 -0.13569384314289237303 -6.5774295327049117077 4.6316277713721705211 0.8104893359800652286;0.17466119316496941938 1.2844933149074395651 -0.9450138068713056505 -0.068388141336813701443 -0.0034720152551914879036 0.61340407124373985681 -1.4480339720101333967 -0.089125313903672759297;0.14639823056914802457 -0.11907946888590961732 -0.1293017672025199849 0.11156788701398184793 0.26150815431837770575 5.4092803981687289649 -5.3490965325435038125 -0.33482815589038916748;-0.27840616132858569953 -6.8946300456167897153 6.5162764130884598401 0.53483533687127848832 0.49588889230911076256 2.5809077090584149339 0.57659633639925345072 0.21811247478372292052;0.28007251369765912008 0.97344079354404977611 0.50447017482492451101 0.16711324131994548248 0.15910254358187447821 0.96051410012607529865 1.5947500994679051356 -0.32338965231717331505;-0.26555066479758893117 -6.4748314856586901556 6.1457327877600116395 0.48754665493569293577 0.4485349566347899275 2.3393272529859778786 0.50752634330940771257 0.22401450154227342537;-1.3341670562691856361 -4.4003614169734541761 0.49366794898982452322 0.093168764456463437629 -0.48984094314678938709 -2.1024684209594961537 2.2125451513219549504 -0.14641914140094930419;-0.29254863081867027441 -3.4386906312412728326 3.1414173442587189911 0.0024934131715555400526 -0.13188969757692350915 1.1339938240445321949 -5.4746208879536490954 -0.42527691388840510589;-0.086521091097237157186 1.2987909588402912764 -2.3902131044094554468 -0.32015812408738275607 -0.096557946469672029099 -3.0549455133898910653 0.77222822213651731715 -0.028407048095883617733;0.037341920047845797437 2.1898016666896764626 -5.5581963314637006235 -1.1080643866933697073 0.64115930734224724219 1.6820177910231302043 -2.7589874047283466929 -1.2097972020907854507;0.29062970338159388461 -0.41831701242563607002 2.0367937826272659585 0.28801467535888236604 0.11386473616854056456 1.1519726052046022069 1.714379466238918015 -0.4743962088987357939];

% Layer 2
b2 = [0.84120482123052509049;-1.3967449701185448152;-1.0399573781780688808;0.47983760236326966631];
LW2_1 = [-1.7415481361055011877 0.50517321909120627144 0.84602809610989238021 0.011905706374834363476 0.046094152736932646197 -0.030018747328965953575 0.22711621979848556352 -0.10511644141876889946 3.2018589950722793347 0.034391654646129490858 -0.043476239162622720702 3.0443394479217609216 0.020021171133535482084 1.2188891758904434326 -0.010900797260642920705 0.55989165202764790141 -2.1924718666157696489 0.0078119362453430629331 -0.035391816617658160282 2.9963202782053053319 -4.155068740062607624 0.7649841363463092403 3.5837698117400127451 -0.14603194749646650208 0.92840935423818127248 -1.1210081240534708336 0.0066103394204470172779 -1.629362481095587567 -0.0220420050220138386 0.0067507690691530524221 1.8788227967858164291 -3.3108211480972595808 0.52570028940887203461 0.12477280456567739486 -0.69162823655868577166 -0.38173310194883264268 0.37474140607488642951 0.21614886827512197476 -0.0074920990481376981487 -0.083648262982523619025;0.96491029082594192978 -0.7411588616627969861 -0.851049651826250253 -0.013758286846574020734 -0.033266584558144983441 0.034885067827011034813 -0.14216327534438330527 -0.36647508601378586679 1.1986341749219504571 0.069214836304905894004 -0.060525066903548259412 -3.3283215677758444251 0.00038452371230145480311 -1.2023786680089363355 0.0053652482258918438376 -0.59999731072880446714 0.33567182414625462705 -0.0061544045075986554202 -0.070254855169045837826 2.9492509185291013729 4.2158204425941807614 0.68221795686915553958 3.0272539563448557232 -0.12091057312777718502 -0.90016981067590007282 -0.14336253891964190199 -0.01424198186562454331 1.981530473467004505 0.020462274865392596906 -0.026098320882899057188 -1.3607162185985255398 -3.2253615388904819383 -0.51423891502930729747 -0.13184506367061682441 0.68212812427323721298 0.54484315696786378425 -0.35066285572362332346 -0.3719535077826788827 -0.0064874882703851652344 0.084869299436358375255;0.94604957957667323853 -1.3235142921893625623 -0.18219981024727655017 -0.012653603522361132894 -0.018987128826486180527 0.024193332603159950489 -0.07137605912235804595 0.059933975668177673357 -1.8295938713911517048 -0.046509569376374883254 -0.0036796847118880987235 -2.1477367927242996259 0.0058558694887436910093 -0.30220402107564614536 0.00017138696169092669692 -0.62802006793622400238 4.7180761218829498915 -0.010562721793206370988 0.045599819707437191929 0.24160203129065316308 -0.38199562321421626221 -1.3487255451788322524 -1.9649170774527759953 -0.15953598076532676808 -0.15818189112321440204 0.66563956621605779862 -0.0030029843582786647574 1.1359085894103417846 -0.0024214437613637837705 0.00074354211345520706579 -1.1202442041117157689 -0.32482557706683945487 -0.5489610586131012937 -0.16981663939113766926 0.66359453347578256643 0.43751477163534818748 -0.10360202885063359013 -0.7747647028496216226 0.013430614154249731484 0.12872390473342459893;0.80865227951599805145 -0.6657742440121532379 0.20339809157221777625 0.028222084758989969544 -0.021723166733079096041 0.013391694363821260438 -0.10287299587788335808 0.13045914108491213357 -1.3323768378036771054 0.013013596665055662122 0.054884800759971735795 1.4780097121045692177 -0.0040870172922440693025 0.3268302298628614766 0.0014656756718015155096 -0.43754092260823745919 3.1857180258107948845 -0.0070116890865618130418 -0.010662396100586744863 -0.22181931064377075069 -4.1381746293272021475 -1.3114777677854356774 -1.9234859511160327106 -0.20937879007262030773 0.32599033593853338209 0.43415591261329233852 0.0010206986416311024206 -0.16614992250894239367 -0.0012686262948991473311 0.011447916024140433397 -0.46477861280769022789 0.46718549652644575376 0.39534396035733032626 -0.12458904916502656912 -0.46759310727443953448 0.097077174717934019976 0.099314397265069867538 -0.33640694375054991383 0.01283907305190941546 0.094817099601407162091];

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