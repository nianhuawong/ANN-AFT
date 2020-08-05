function [Y,Xf,Af] = net_naca0012_tri_fine(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 31-Jul-2020 13:11:11.
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
x1_step1.xoffset = [-10;-10;-10;-10;-10;-10;-10;-10];
x1_step1.gain = [0.1;0.1;0.1;0.1;0.1;0.1;0.1;0.1];
x1_step1.ymin = -1;

% Layer 1
b1 = [-1.937224715812566167;-1.1531115726085445772;7.4696349474641170474;-9.9715489560524073198;-5.785523627895945431;3.1142154858000488105;1.2323112423469151366;-0.58908108370231937467;-1.8310254857017398411;-0.70717896754330911158;0.99123975076361237058;-0.20084388720596033084;-0.54055151881398810776;1.5086106329186561581;-0.056699611420452572519;0.55831803624240339268;1.3809303169722058069;0.33988334728302055376;-0.084472548340272110567;-0.18182713870079694751;0.19572140160701892442;-0.44405064763044327369;0.71267753401761391174;1.3186240247670160119;0.081758296621721807118;0.51046972434854909206;1.7939481212687513612;-0.89844731447439007965;1.6356072320305128365;-0.105628103554037997;0.40652135455017968102;-0.66977973604760243642;-3.0766719822844255106;-0.90994001053427397974;-0.044437456294628821518;1.1240377702056507658;1.7933977135305825268;-1.8160135810567912262;4.2871586252871205502;-2.2156890712727705939];
IW1_1 = [-0.027089366942181374726 1.1628714595237210627 -2.9026836301526035555 -0.014766045363822961553 -0.003565812988770305017 -0.34651882235826692025 0.14626516167622458098 0.014001490796943339562;0.022156347471817685463 0.13687149373922566364 1.0126225313788825844 0.017327654549026860059 0.012348980145605686215 0.96246380940767117806 -0.9220782311891511096 0.0011291039865038658002;0.18362562756463318703 3.1531301027843614548 -6.8536953217340927935 -0.15971322936141169047 0.023198062857313680313 3.6208812564796386546 -2.0750591985983013465 -0.080160710976715413012;0.73099343264034510881 11.792513103729085344 3.1077282284246425803 0.27376591811988904013 0.62455636860709484726 -0.34196830595511673589 -10.9608173946267069 -1.4004486088690624168;-0.053071250800391059355 0.75555689006255077889 3.3340196093784011389 0.80617184741820302474 -0.56678959761832647946 -2.8813735455808577868 6.487914477229332455 0.93075920749649565522;-0.36590432456174770692 -2.907079774579762077 -2.1082802843308647844 0.060796905898252193157 0.111439621377158668 -6.6941539575359270131 4.1152639415581120375 0.29416512469047684242;0.061727356090450727355 -0.7799456086828285839 1.0628332487271152651 0.01578062361110608644 -0.0028688574757096655006 1.595882445895214774 -0.17446465837379129815 0.017956218153485636879;0.0070110581598217449478 -1.3932246894672553061 1.3900056085088756674 -0.026216423438942121349 -0.044722765820039984963 2.225649004007485221 1.0474496700075133226 0.060524241559709597571;0.028089974177806450312 0.17911478412966197471 0.62053732243451908968 0.0061589257095978223316 0.0077187349218199221429 1.3382429968869065107 -0.1017669555099849632 0.044919958900722777029;0.039780325731762385122 0.84345623100313860121 0.34080710167264027799 0.018293106603555060047 -0.0051671522869421440335 1.056282093825902324 -2.3215991985253801033 -0.031197698253767690291;-0.086565668860935446327 -1.3558738393338936046 -2.9518612516803219847 0.25436528290921150974 -0.32424493378263169463 -3.4684885950809305477 1.5118302115825663634 0.10661752293695772598;0.027323629269008532783 3.6202236909047549318 -2.6222646260706032884 0.091175476054609280729 0.012815499309724602897 2.6710344221116590901 -3.8305739971857777348 0.0087362784068865505932;0.05235831444808317775 -0.41365039198680070287 1.2969261475807032369 0.0057746225927923578239 -0.028510665017260405918 2.0208833766515694741 0.05278962661755111363 0.044149592834132500574;3.007915249648624556 0.94239442688926711167 -5.1048035813714598419 -6.8834959062852627554 -14.538011299726091963 -16.268981469762934466 -13.503988563848933424 -10.224397295685374587;-0.020776667119322213967 -5.7746841750159561002 5.7839574807103151244 -0.04810142787378431789 0.043391975941112104209 -1.0355695300456007057 0.73613413576935882165 0.0555430253047121264;-0.15164462793073790747 7.8919296165472889726 -9.3437996223527850503 -0.25899704961900255062 -0.0091247748204658675475 -3.265852613975624763 0.55755007047321258895 -0.063419235496278342223;-0.14321062476186632861 -2.2347832099385689375 9.8335457018982843636 1.5390712913293829178 1.4545664734060059775 9.5741341867103617602 1.1151240114483298438 -0.29291153052525464862;0.068774350601522649118 7.690139203195617057 -5.8757883901033425289 -0.089840859040023424154 -0.092163055249331035657 -2.9254390891426829135 1.3884183043092335197 -0.077933374896308610369;-0.046004538889905806365 5.3394930498358306181 -5.2680892595160484504 -0.01763937425253830904 0.010987774432782993969 -3.5500149382429482259 3.3146035205180859329 -0.037801755917662605011;-0.020719396713131933013 1.1128781297178340637 -2.28725704954850384 0.019414004156016757136 -0.0013755563949227117213 0.11985756065770625245 -0.46292158588793791418 -0.0049377123371465263257;-0.16841604322600597921 4.3425882300940514824 -0.86823897744792688513 -0.51827328965265773153 0.55506447545867532156 -1.2444658741298169069 -8.8738994435914815284 -0.71954054251962373812;0.32795275852866506705 -6.1772059267903678403 1.7407582127758973733 0.58975950924882014625 -0.73183634147992171481 1.4440359536135083385 11.260182738476943953 0.73050266970973654068;0.001479055205268644483 -1.61346001535743655 1.6904468235769718465 -0.015645301452376018936 -0.024531575149866636371 -0.29709042696394860616 1.2506613468542322476 -0.0051643384703117132736;0.010625734836705869046 5.2636873206563477012 -5.4661083673835904051 0.076585444483413839256 0.075433221658539398313 1.3307117824239025339 -3.8086880013551502877 0.060233564461280517111;0.079448792075292123949 3.682986955912690874 -3.9703624302787590139 0.14467014492689514449 -0.0016481205433444162146 9.6837235474982623629 -9.6878495699249942419 -0.040006452533475442279;0.051594753277236511668 -5.3655877446779918216 5.7021241756212646123 0.16546087138927020876 -0.041696405172705668096 6.6724137034964714488 -7.1928088027877734589 -0.055939706083556417493;-0.0065436048297202158847 -1.512868706291600196 0.36473972531775933348 -0.041045460063537278494 -0.058959635964359241589 -1.798618932142806992 2.5443804528104809748 -0.013291967898137448112;-0.021922924429664179119 -1.123808551535004252 0.57964472405686529033 -0.034218086245728314421 -0.028695662160597358581 -0.78187577238260919099 1.7916537740603348805 0.018619585065410095004;0.028126971630637463001 -3.4934009521615321248 2.9445076922542043896 0.0017877474752693502547 -0.013472659023226900982 0.71628460780963310039 -0.10148181039833953365 0.021526166715311646077;-0.012462082180639251147 -3.406405794160586975 3.3597703147707975724 -0.035192951260149860082 0.017152584230107060376 -0.72054262858121775892 0.33733434084415553356 0.029577483182404235712;0.031952062606662397226 0.75555860342626701698 -1.0565006616885630475 0.016628689564165223536 0.018907206336432402088 1.8525192308492044457 -1.5369662401075190328 0.0075885910366674663718;-0.055126302123886000706 -0.87151585955937105332 -1.2681645198991766676 -0.073906185873955143606 0.030340189340286878583 -1.718624097655284455 1.9699646066810090339 0.041358428982234851645;0.35460498656534245043 2.517650426514066897 2.4360406909469705106 -0.059707144255006033839 -0.10086472322892109377 6.7610420266128556932 -4.2501932561123103582 -0.28414080343171088661;-0.0025593645127625179458 -3.379119971202891648 3.4484743230257937086 -0.028942066451074808381 -0.046897696508061727239 -0.6140128312561655699 2.1069499565885259074 -0.026489417205210433193;-0.042220859764409229831 4.6861020240753266108 -4.6462472136501205 -0.027291767256514821299 -0.0019438006008091700781 -3.7657262419353396687 3.6792199530371401117 -0.039844847781380775265;-0.043159874940005386879 4.7792037370116071671 -4.5718723147142918961 -0.032303936210765153703 0.00981635312008484473 -2.7229394181690493859 2.2154880763249527043 -0.014024237987267493613;0.021792159116525575829 -3.1657518326409905818 2.2923726422921717472 -0.019890319635073164251 -0.037157615036164604039 -0.65780777973193382824 1.4435987022092855447 0.011566998801470542921;0.031919205518771746888 0.027719322668009662575 0.87907999462426200665 0.010224390496001980674 0.0081501140269031203262 1.3351853313167107995 -0.18923244793335189384 0.047274849416342745734;-0.047171773820098628072 1.2248013198255831568 2.8973595770849223108 0.30077263331094300502 0.04415503761042166575 8.1071610716899282778 -8.134616052826116217 -0.10227607848790216949;-0.25060597041985577249 0.65369959718265047144 -1.6075825734082846985 -0.12728850415661038809 0.2024370904654289316 4.4924490001895733826 -8.1110525083086972842 0.13030438983003644893];

% Layer 2
b2 = [1.7304818503138048591;-1.1913838920932504628;1.2339447753817593956];
LW2_1 = [-0.3513009845323433189 0.24965119715584163651 -1.1319875408743613754 -0.0041684158464085361087 -0.014920591376659530364 0.35317062564717122131 0.24288104789672673722 -0.011052495989422813499 -1.5609741510032286715 0.029057467632383735673 -0.0082840804214759280327 -0.12799731317648305184 -0.00074373953947394987572 0.00016912321443895004971 -0.046692235127314483945 -0.0016983837390181083515 -0.0010032474200668724251 0.029133746454890117189 1.6849342843715100493 -0.48797009988765732702 0.005229163230116838125 0.0033464813431070801822 -0.043316936537235617433 0.14833134756694299483 0.14914425610892256824 -0.050318779701179955355 -0.44921075464927373577 0.024981593999438184844 -2.2435200632227418893 -0.11759083388355905109 -0.74619387397312042509 0.0052888314248200332321 0.37157067677074639978 0.42494343558824054785 -2.0654489524934769307 0.62251451008888558647 1.866027661419102035 1.7520746961276505438 -0.037008379504109768787 0.029318572494534799605;0.17253090382152225235 -0.2768866261811427365 1.3102198815390757591 0.0019508693295641886967 0.010762917696720244315 0.24236414880053996912 -0.068080987387817815115 0.0014842953346479218456 2.7068110932991520379 0.043724524068920779529 0.0076014573669409687615 0.070331253296161647115 0.068035570344698287348 -0.00046831492377320349616 0.98334513670398249197 0.031963648051948886919 -0.0011318778146675843605 0.023078976587533436143 1.028174126503325736 0.2469905824896869162 -0.0080096052054085230265 -0.0055626908465174857918 1.2752094322426994477 0.11886420165386191172 -0.050815500672477066646 -0.040871090194595470491 -0.71792136859539501526 -0.34006511307517517384 -1.6130849545835630465 -1.6319603570742307053 0.25463107661912798285 0.018191501539897476231 0.24232749186496529981 0.73156263722151726459 -1.3280243044544506326 0.42700566813932255839 1.2585835406169645356 -2.5795284840304995022 0.0049793856774225575199 0.014097601485300792143;1.6260903631698027105 -10.452305959824435888 2.5518187380890111626 -0.12135194074223720762 -0.099394771780597038213 -0.1987591413454244671 4.056053956503386182 0.59410084702071863649 2.4407930210093331524 2.3865257388757710189 -0.35271377054716857025 1.1102095224089536529 1.4968209714731675053 -0.031541748903078752064 -0.75658275785482387299 0.013874579056774014041 -0.060064837160798224824 -0.26804807865487173535 2.5227167114685524751 1.9596480963016145171 0.72199977045539398546 0.60662523978510662914 1.3506695036909681651 0.95130676984054829415 0.042082929154862488974 -0.33757781792703972501 -8.4513296403638964449 -6.1999043695679239008 -3.5772097259922817081 1.1842932259918070859 -5.2452989529128277724 1.6591240875112716058 -0.064505483010675407352 3.8432342632026941232 -2.8038734312006052818 0.10207283678697040563 4.9839178661802421288 2.7029384981029385138 -0.33098612832262030992 -0.060266875226771876584];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.1;0.1;1.59778745470188];
y1_step1.xoffset = [-10;-10;0.000930762255008352];

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
