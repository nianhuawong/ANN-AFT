function [Y,Xf,Af] = net_cylinder_quad2(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 16-Jul-2020 16:25:36.
%
% [Y] = myNeuralNetworkFunction(X,~,~) takes these arguments:
%
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = Qx8 matrix, input #1 at timestep ts.
%
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = Qx5 matrix, output #1 at timestep ts.
%
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [-10;-10;-10;-10;-10;-10;-10;-10];
x1_step1.gain = [0.1;0.1;0.1;0.1;0.1;0.1;0.1;0.1];
x1_step1.ymin = -1;

% Layer 1
b1 = [3.6361102175052666396;-2.7277996091315377392;1.7492161502340703993;0.70629589140865789432;-0.77494206850453339896;-2.9916541420260016615;0.4361413046975287644;-0.040067187822591519841;-2.3817074417936501263;-0.51387855149495209606;-1.2616880386213114029;-0.0091343341962645714649;-0.39517775393750131929;-0.9892129751001810245;-1.1180836592241303329;-0.0060546524364548546734;0.71564582681961175226;0.47718244808909254795;1.0257926354193938057;0.55362957470111595626;-0.16104227990641961643;-0.042139170791463474719;1.7334245717150693622;-0.15837684642930405232;0.8634251913884715135;0.0061237613183975896786;-0.40158295713211022981;-1.0234738333347741523;1.1084705560554559689;-0.61600866522601405162;1.708774979058846899;1.2165500439930123644;-1.1747495593426411364;1.1972029891922919553;1.0785022450817065565;1.3476936175430660469;4.8254853773361370273;3.0564372069007075261;3.8117308803143590268;-3.8756211711486621141];
IW1_1 = [0.43705913783935917971 1.3247690712752990816 -1.5229618886118243548 -0.20005778479821426097 -0.24742448895892199534 -3.1964150461203599818 -0.14388444224464674859 0.25273659821028288119;-0.27003833375955582641 -0.90608674309176240325 0.85421641111730195473 0.094396486576286783854 0.26694780142484075824 2.4984338140392106098 -1.398468800599840911 -0.098165185735387711086;-0.45787028203133167681 -0.46577429658252417211 0.64022880208463817109 0.24493676523313620552 -0.21393260496730695519 -0.83301795914224519013 2.2919604280967234011 0.16134100340066875878;0.34407955540593349042 5.3696854969623712961 -5.3815596984367566336 -0.42738725705217239792 -0.47762957995462496097 -4.8437079568148124764 5.0064725257242317369 0.27491088202083990844;-0.038500050511636060846 0.13056656143636355405 -1.0794653420112945152 -0.023340848171730561172 -0.29570842043514394826 -2.167222314923892057 2.1108325350364021133 0.24632403428850244143;0.1417097173769295837 1.243719357940731074 0.52111910860724730554 0.57504360923574382447 -0.045132260307492830242 -0.78648060438419109541 -1.4106670535611465223 -1.0636895403253132653;0.33283154207330684082 4.7925074423554274716 -4.8831538155803970724 -0.21127073463005016651 0.25646881435770674251 5.5702597345277764518 -5.4105178016105615058 -0.41012026292493558577;-0.1229233815064063734 -0.6115718270480031693 0.47576021240785443256 0.068502563308955780053 -0.065591107518870789272 -0.58140238525355447674 0.57836497256846086668 0.081382976919835758878;0.35563442597128386291 1.0757680537345521987 2.2090635228722463879 -0.056685818706525926969 0.77737398779113431324 0.90946427811600172308 -1.3057326498389130176 -0.56128364631209670677;0.58252906898832701454 0.93432389534393833763 1.6313349273003487916 0.53256447569357301397 1.2056847270606789735 2.478060661264040121 0.57910093528791040107 0.27841211056078413177;0.384216014599354172 1.327484614849586908 1.0802509501692301175 -0.16385018514552668334 0.91752877358723561318 2.9582745689879579309 -1.3165775399114179045 -0.47556614504341532257;-1.5524101748959593383 0.87081496033412864044 0.39545393703985820544 0.26812014940545125796 4.3068622842500001724 -6.2480657657636786695 1.744201426873979166 0.20146579447473891844;0.18556255252716263859 -0.10700856008440132183 0.03780306187680404495 -0.058544599768641444881 -0.061423490373882047577 -0.90373440415556804961 0.055932643503401061058 0.075294966477730276844;0.088590671535803508507 0.87577737393280963296 -1.9435701726301737313 0.0039673527208121490625 -0.1246683818750079914 -1.1236660435801597568 0.31077261034311065568 -0.0090115569247025024968;-0.026170220834966735624 1.0615637762933707311 0.69793432776732888811 -0.10069380988780064767 -0.059202331689775247736 -1.7417263240043157069 1.5568407261974059885 -0.11631148688841322358;0.011691887875182488746 2.2271284065313863287 -2.0866813022501347064 -0.14384833193526566641 1.0280096410809833607 0.34009237592556684771 -1.2330514500267057976 -0.1427815918881261692;-0.083079599774231280285 -0.18524155651168025538 -0.82905271233600752456 0.0079726903553965638993 -0.23526164839632199288 -0.98873473577663550937 1.1041438191386530043 0.19778214194401683157;0.25442034107524358344 0.13087629429166577899 -0.11300507491599116883 -0.11488841490834927894 0.15615710623520789868 0.38472823848010828662 -0.98509032911777472119 -0.095355437721377167559;-0.19015693585922227582 -1.0543737476736447789 -1.0087086227047830089 0.027287134189124671868 -0.45845011502438315354 -0.62688403139593007474 -0.7591163174281159165 0.15188138607551018855;-0.21580936117511403949 -1.1394939007170963308 -1.1080269225450929405 0.029559479688921856677 -0.51402303314808039936 -1.0523575969556853149 1.3347047944517356211 0.35850124900535884631;0.26143530771248146838 4.3796469860898872284 -4.4784797862218352904 -0.19267654878299803056 0.28077916344475950527 3.3163669855496924477 -3.359876260002166326 -0.24316928808879273438;-0.080704394452235275748 -0.87556970205733652968 0.1455618918582352872 0.016785777064359675564 -0.18982754848784688662 -0.48113654537933020494 0.62595779581099886268 0.11352507355988632198;0.31300888416393707336 3.0757286687542704229 0.24834529979986980086 -0.03791247463195549644 0.78076068211687899012 -0.25567361516340841865 -0.09517684762773837015 -0.51056646940753913633;0.85645484023387130623 -0.9906105449676413377 0.28404077981225522853 -0.30789946384545152647 0.2084225484444798826 2.0941086252821143887 -4.1833464586294786258 -0.35470125079765685294;0.39431302323400219123 3.3165642045462240262 1.529831416863489002 -0.034479178202432639311 1.0960135082674329343 2.5511067411841148456 -2.9657001720316800153 -0.89675796180498124066;0.10364868537918811575 5.1807237565420143355 -4.9619010656891946454 -0.28862553158712178636 -0.018950417916938647189 -1.3421464171399817289 1.453674459176157896 -0.086678221357096810196;-0.03991008608783924716 -1.6635692982082088687 0.10345680521004146923 -0.09886395511442803985 -0.49467853647674192574 0.40108136567937746619 -1.6748914659638802771 -0.20161900274167920966;-1.1194935651266400001 -0.91987869514035147667 -0.97914583865159954268 -0.40912516078095129135 -0.41845920223224419843 -0.39786410030977276131 2.2728522615718262934 2.3062849251923918104;0.56226945390170657291 1.6894184792295405817 -0.64070904496934077965 -0.011275179392428020392 -0.022064741431133353539 -0.71014460602802542688 2.9039949607570147982 1.13399589240046339;-2.077657147360899792 -1.7996557779115462949 2.0568986556054782433 1.7076009712145416852 -1.016457133350810782 0.80909616431163944306 -0.67056838418907060984 -0.054658307967588366794;0.022442816194772823718 -0.11885856675411696215 -0.82029669503311264389 -0.003056541435874417581 -0.042072910343502994968 0.81135121591025149979 -1.0361178578895269276 0.007910803237224990625;0.48655564732332379219 0.62438569335328775178 0.36505987597104022635 0.056156283015661202784 -0.32961766187047458754 0.19969495258547317884 2.6574238957912634795 1.3899006616416982318;0.023127225836089001371 -1.171648319442259556 1.3215033142667504951 0.14780561018090218606 0.41958096962867585944 4.7869417256018165219 -4.7423022555783420628 -0.37670624514225192758;-0.46694717781662586908 -1.7056883243690195151 1.5201128944034643098 0.9651181757201392486 -0.84454018559066268423 -1.9553524472110823673 -0.72877872119993369893 0.30771652209342104101;0.42505140801872626222 1.2889010594048779801 -1.9560643812698230715 -0.24792910090980435633 -0.14618439835649896241 -1.9627434320303291937 0.61075020868034757271 -0.042343132831415254691;0.036841741294923152639 -1.2272385400083791751 0.72821649785327269289 0.10689171595307268847 0.32929914874656079915 4.7206366000548474204 -4.8372152228529490259 -0.30815673892062028782;0.2547317429394045929 1.4745586752830972532 -1.3161840706367646803 -0.37560710778015155009 0.21251707665192770547 -1.2125266568077062157 -2.7412766897439508895 0.26492545256356409;-0.44937421979294533969 -1.33951475626990546 1.4185252708622730911 0.35697573042472963145 -0.21833514052276378758 -0.40752998506032678261 2.3961642099558684293 0.063903527208010194038;0.39785097531833585327 1.4300680542868748901 -1.643809955446933202 -0.18737254215219342757 -0.21344046144535233633 -3.1842032662673287469 0.28202032770078050428 0.22021577763317040644;0.27977180717414384947 2.0848086580618030439 0.72708392940855315345 -0.14637295390276147677 0.38329270901115558567 -1.9219770858648452805 1.6077468243361900946 -0.23998189387210031032];

% Layer 2
b2 = [0.67400173482153868942;-1.1305791998119518738;-0.6145620977904837634;-0.47074181252282359944;1.4172585975929530289];
LW2_1 = [0.61810595395847134359 -0.75340877665643579686 0.58718088893572328857 0.020610529449672867347 -0.1786654222849189122 0.0015980082853739774242 0.086103075354268185371 -0.75585192166365122723 -0.20988686415672988539 0.00052766119397754584694 0.06586849989280206541 0.05467468139820509665 0.41511423679211845172 -0.054191022514439392277 -0.19959114751656362174 -0.35487620340934750152 -1.8614915145427113341 -0.20408014634796245446 0.085713748776117135164 0.47133555345127570169 0.26564178459342330241 -0.85088655185004646864 -0.093233586395709028283 -0.054066520559927909451 -0.050288497503791121379 -0.20850467061067387564 -0.018351411440125805358 0.0055196529375313267696 -0.023551136635454803653 0.009446247298511555382 0.37020361434505338893 0.02018367745154035775 -0.55871765013898522234 0.024022217362129050927 -0.16336388771387982954 -0.78850011542779518958 0.12822550147062383719 -0.96010486372429637569 -1.6766361317252085339 -0.56947871736485977667;0.058872922786690186359 -1.5199977570406877359 0.50403263474847981307 -0.016899800608275349773 -0.42710172841232429963 0.00020105754989678303922 0.055722866436754808772 3.1284287799118617457 -0.24635810458914159105 0.0014591436158488248296 0.081063017753283200806 -0.14203591282598110324 0.31395643544699397554 -0.074735311750083896487 -0.22856472596577170897 0.47519285400473160186 -2.3553317984455897083 0.18517138476995759211 0.10563484582495979991 0.5993810450721127614 0.21003062408830691643 -1.4899334367662155909 -0.13016689446681883879 -0.064004903785527728077 -0.068636893494414041861 -0.17809472056058908707 -0.028824004899915735972 0.004421093176649097331 -0.043124777373261390101 -0.023702892385860006852 0.37987394576289706949 0.035559793810424650262 -0.59304729970604752598 -0.0080598431869492309643 -0.1966022210047899399 -0.78767624400000590956 0.85323145812737444249 -0.83055033447401360736 -0.88147286787159095933 -0.58942487733276049955;-0.39661649767430640079 -0.83925056971677869377 0.78605768119239916025 -0.022123019747938052482 -0.053292728036351419418 0.0012355914706590189964 -0.13757756380756905323 2.8049447018747963867 -0.12668316541527060992 -0.007879188285235341066 -0.028677163305688493922 -0.5215607720031539829 -0.088178375764345312549 -0.16441562867804318526 -0.084666493204110196413 2.5401003936698005603 -0.77143462109585247966 -1.0857901077274638713 -0.058150202470581634218 0.26800409427679716678 -0.45390204786554005922 -0.66375919070250377629 -0.058592822941961053562 -0.064471532584276181055 -0.030457984019629562311 -0.40900485023248295269 -0.05858321862030545224 -0.00021791319758964706262 -0.083838463742448396387 -0.0062628780625387930892 -0.59461170637922555748 0.055746744793904484672 -0.2276519406886643726 -0.020495494810297231608 -0.14765937795920053288 -0.21061678310754730625 0.93428114365109837802 -0.95990456888060704532 0.28818823149818229012 -0.46973692453505394573;-0.49574943039585572802 -0.55685209606070196209 0.74213811751777469805 -0.02701061038457987229 0.33892858886542909236 0.0056033582176432360222 -0.091247318449013792296 -1.0375403857123126627 -0.041890599387848441448 -0.0029764182865912093036 -0.020988156263755809727 -0.22678210862961908911 -0.17081084038750918297 -0.16512279722569800366 -0.010614756080486929118 1.2013306697697707648 0.082159403948992557054 -1.1323588685993335456 -0.042340560906303989497 0.094373252377787333889 -0.35787721763909596806 -0.28150667379228411225 -0.017389005192200965993 -0.063723104114476278315 -0.010988892876792062669 -0.420237096625809603 -0.041247796961807504934 -0.0040844256765452547492 -0.05781357884878846054 -0.0064251379064432997956 -0.47665242710080935051 0.031734238193787116245 -0.22967742448778796782 -0.024145306767874286785 -0.11765130762872273718 -0.17771286462250862614 0.50844039334711987888 -0.92604350949151437167 0.74853076253953176877 -0.27379353324551214399;-0.32022652371642507108 -1.1453086491763302401 -1.7193684578735599633 -3.0129431039906306999 2.0519543692719799388 -0.34209232761742552897 -3.3475386114547269756 -0.43087910714130306378 -0.4333921317848565824 0.35009309129881238665 -0.25252006374377788944 -0.37094525464624739097 -0.55170094804816371958 -1.6948433524101702563 0.58839459113274206192 0.93187076353920628158 1.3828077932201112699 1.7444743157205282458 -0.4029722193211338066 -0.26594730369947522375 2.5215048762272767036 -1.4755655897866570836 0.015632741814981667566 0.23005638887235391188 -0.32372946104177435789 2.0494370268662227552 0.77065653576539894232 0.12984444888968305065 1.3629525233707266985 0.27188862303578703594 -0.80174178211181057474 -1.0990698104108904687 -0.60933327612679477614 -0.10169888715731863205 -0.35161896055170621667 -0.42843723851662340874 1.1290985833573083941 1.2858528566725915265 0.13768385400266752727 0.57917541792837512471];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.1;0.1;0.1;0.1;1.98301535242027];
y1_step1.xoffset = [-10;-10;-10;-10;0.0942940629850542];

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
