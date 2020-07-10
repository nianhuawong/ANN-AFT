function [Y,Xf,Af] = myNeuralNetworkFunction_all2(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 07-Jul-2020 08:13:06.
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
x1_step1.xoffset = [-10;-10;-10;-10;-10;-10;-10;-10];
x1_step1.gain = [0.1;0.1;0.1;0.1;0.1;0.1;0.1;0.1];
x1_step1.ymin = -1;

% Layer 1
b1 = [-0.90407435239534983396;1.1658199642124920103;-1.6670309626036690087;-0.78733407487944151448;-0.92667847426803640065;-0.03028450384354997027;1.0685780608419910287;-0.62486291889942358058;-0.0044418659086356022253;1.6135988483630616663;-1.3010010680924983806;0.93357035627483209161;0.80278721223791493777;0.47364857968532991794;0.010158972297565606324;0.27618611668863424224;-0.019657654817257435437;0.26423127423710257577;-0.030827124165528262123;0.94570509700681615328;-0.034187722420470773033;0.016055949979510836939;0.28103090333362795716;0.0095871555195409796646;0.28818493577387993554;-0.62106365647668781982;0.47972502207957018472;-0.78761181889584852556;-1.0417235809009541825;1.5466038500366201536;-1.4028500428061216887;-2.7429996264978746545;-1.7731143713957950858;-4.7868634136905603427;-4.7871487631738665058;1.8677467221998225178;-1.5383880292175584614;1.5588104841171128712;-1.0761214307828008696;-0.58299616900898065808];
IW1_1 = [-0.10277797940374966412 -0.51538176128162049849 2.8234080044124425513 0.16291505062438679796 0.025104806305832640806 1.1418276289001267898 1.2154032649443053948 -0.0040035775487523642124;-0.60980509918431480276 -3.6214195109996643041 3.4885121276236175092 0.21674748551971320665 0.0036141286965750249634 -0.63122345375700550374 0.72158744735138702353 -0.17415982044805145001;0.64364756408074252914 2.5295591331905056265 -3.8601623071369326468 0.076661346858627632539 0.26447617515656063336 1.7386536443673989982 -2.4828727410675628384 0.044406435245785379207;-0.097036649198769336921 1.6245628522061359433 0.76598121447133360462 0.070345557702989849891 0.52624396612961488184 4.2807517958688050541 -1.8544898223170982465 -0.14203716472517746716;0.055228604666281759517 -0.44661787650151274498 2.6567469752415910911 0.14021744262042806772 -0.16735454234929725281 -0.49503078959925400637 2.8721697679069926323 0.14372151042293038192;0.43833404525570351939 0.56015691642639209302 -0.84506546490189970999 -0.14775563868420363289 0.10067277020767723128 -2.0691002839808514402 1.5725627613437416219 0.39687782314259956173;0.010283780780425841317 0.9707067855558814129 -1.2860439392339699793 0.036331181495182142405 -0.38818880456472820706 1.2884422884285622324 -1.5357679629156335555 -0.19169361529907213981;-0.3143209239154683976 1.5801046703978922636 0.74155722975277527098 0.083599404045064620861 0.33023026872793964648 0.56735533035920771017 2.7771772987357414841 -0.013893115701887514407;-6.2621170400288468372 6.8394906558582437839 -1.0334326484642277766 0.45897930579444795596 9.1845913364989364425 0.6424330003830319713 -9.3273431366637158391 -0.55723414065829357522;0.60341239483143127575 5.3560633873157508233 -4.3307925654923504766 -1.3116244445781952699 -0.076817082397027558471 3.4397789960693363476 -3.6100562293615583442 0.61249063567049755186;1.0165925002375346686 3.8679118540992241115 -4.451021978470070195 -0.19799859039661849014 0.06429651272305247911 -0.3504855476830478489 0.17106141345228742523 0.31092580513860856861;-0.1701747641714003445 0.46179158254237545611 -2.600289538655711219 -0.12115636614841800156 0.27877720101725050883 1.5811512635547704253 -3.9986942607349904577 -0.2403144289176966375;0.20249501189787091904 -0.6782396356283110217 -1.73219453221542663 -0.11067401965620529691 -0.39392738727102410978 -3.7541615313026275302 1.3526421447119187924 0.14052886562984315266;-0.0093266226245036550763 0.30456147040756109678 0.13259357974322280582 0.0094300361794142414235 -0.0030643764068048282706 0.78512311328830508561 -0.84719948933732469598 -0.1190185215869580676;-10.617855545532837169 0.91133675016593307383 8.5269735439965543833 1.1106747695129861597 -2.5655026078449116866 10.303160820324890778 -6.6048653914641706208 -1.1482285703170433955;-0.25330620720933716417 -2.5781225389262085734 0.11499693330802029934 0.29723357935628058613 -0.3328042139320459003 -3.6951260636150728978 6.0753959086946487389 0.1525896930351534897;6.442599470291797914 12.66763976274205028 -18.422332732000224809 -0.60936004288058132072 -0.67308639288196736583 -13.755351357952484648 7.6098233097392675717 6.8430551160403316757;-0.29152181957631878584 -3.1309837375938935899 0.76560697268088584444 0.28848623824370095425 -0.35658344474051201223 -3.5828673707568925444 5.9306426009170802871 0.17447596072543772316;6.5356762389530009827 -5.1744144381300527513 -0.78015063222822567113 -0.57506651284316501194 -6.2577985798909958604 10.340688168098221666 -2.9078810641217520683 -1.1839842919219172312;2.2219818873138961202 13.816891869553344918 -8.692999686891385025 -2.0417932809727079579 -0.0051394009849628245409 2.7882524798507470898 -1.3401630826350716674 -0.55775576897129142129;1.7793938731429641553 13.268374368882490444 -15.656524746972667828 0.66781912676578059074 -1.2508962679248103456 -8.8436336930969314807 -4.5204259100725705522 14.632520226427988774;0.61165924106330082921 -0.093580404108920267614 -0.59859590115242367059 0.031756717611763213283 -1.5328862518639783108 -8.5578516349830806575 10.144402775926103288 0.012503163743076644784;-0.67253120029024526794 -2.3876975234189776742 1.331419104576996526 -0.024250505318214467254 0.75001912926301750328 1.4960381804368674263 -1.0191667820804966027 0.010057613463698114598;-5.3572604799896312855 2.0170168219415800515 2.2197648294810963243 1.0996383539560903309 11.863166865741364475 -3.8171381731520548364 -8.5131818419021865196 0.42382678365855031011;-0.22194073696248828309 -2.0334116699187494426 -0.50937222010980631737 0.29802810229609177917 -0.30189177282035067895 -3.7368568573246405684 6.1371658854280939366 0.12821756593383962231;-0.33198690543420489307 1.4749872898628733076 0.84534272909196817025 0.094738314478852669875 0.30919370186946709689 0.44092727434138218046 2.9145520322585038997 -0.0087837496125176030282;0.095024301597725013835 -0.27346204101512777696 0.34076141277109939232 -0.020465699399419955834 0.23809296590702089258 -0.75548865100206508139 0.86584324523234090787 0.11758893281225721306;0.014311509834987440337 2.266938356992896253 0.088523226455913137101 0.043666533056473284813 0.61609193314200838554 4.5533407150629168214 -2.1008939856939949919 -0.14275717576095039996;0.2042549533629642311 1.5407927742393994208 -0.90595903123020993242 -0.062797389013452886708 0.0050881504650871836604 1.1649331863072431847 -1.3242041042112544513 -0.10503506184370445253;-0.73230043405130218481 -4.1473616145011824585 4.8815509689555902639 0.36183962330768604243 -0.42707998620984771732 -3.5285605329409124309 3.3165881173798106296 0.20962862839659773817;-1.8554658265199654998 -4.8165919491705064814 6.2623865265771572197 0.29367955945190049594 -0.76146562328536515629 -0.13998149953351923802 1.1219664541289824378 -0.16616986583971729563;-0.7657149638605911246 -6.8682980424060104951 4.7592745436231824741 0.7423980399377746453 -0.091850203098198440754 2.7220498249531148716 -3.2440155755727539955 0.15512501154093991107;0.78287146061247614437 3.6756476840597658295 -5.020306616124858401 -0.017453311130223667785 0.37110892798097444567 2.1297637957664807828 -3.0800337463737057497 0.076169948367719189641;0.34912005439774795867 -1.4743180644972400106 -7.3810164733341130372 -0.31149473628384555246 -0.48503373719913039919 -8.6528059939415076229 6.9980362576027426158 0.19235250927417821276;0.33478315353666299181 -1.6413592562509953243 -7.2081240099644166008 -0.29492571955472945966 -0.49104812227271410485 -8.689136107014295618 7.034494126422361937 0.20202566635593180444;-3.9551249472490082049 -3.1009459989200558461 6.0884738103502309414 0.92558910629898649702 -7.3370743569484204727 4.933767269449270465 1.5592481246656073601 0.94259891466036083152;-3.9711191972080532864 -2.4844738309496334772 5.8934311441989821745 0.52055765725067193461 -4.1376214794291144017 3.0167765218555326889 0.8980284141726019298 0.24042270047740224581;0.58161738388798112087 5.2268187261612535366 -4.3387522349776643793 -1.1780125428759298245 -0.06944012646830893809 3.2375968091959230755 -3.3576737768165161313 0.53447949874878852849;-8.8575502061134976373 8.1686085978086282466 0.70932654337832157232 0.0035749588397416794464 -5.4460745979108287074 2.9936086468495219926 2.2680563559942057417 0.23886972794675756515;-6.3850924359179428436 6.1707575625093271654 0.27953153035944883209 -0.037988683917385343558 -3.7595401322088513041 1.6167315586288546481 2.0076636585748435238 0.15609329910303604283];

% Layer 2
b2 = [-0.26999299060884579538;-0.28870843132391649233];
LW2_1 = [-0.33197318393576874529 0.68261676219443545577 0.37168557542673696936 -1.3778874770612927758 0.48809699606038720043 0.050675537096713317575 -0.2951570077761097588 -0.56713304407440301436 -0.023798112987857639178 2.1458967351313757987 0.53840922158772563932 0.25326686800822872936 -0.71138346562455778699 1.868493240981327963 -0.042024148158317349566 3.0695728061432476785 -0.024080901191762607572 -1.5228606575866066031 -0.019471913183696384908 0.005553256948176592267 0.0087585018726378041642 -0.072406104684364466784 0.0071892066414615610204 -0.0049187747298713229913 -1.5610642717781966216 0.56926685994381509559 0.84173329202878655053 0.76294354302413724955 0.91984966601410633746 0.096588625232959413047 -0.25307160723911292788 -0.030740289097923152728 -0.27367887920561823067 0.55560589893297163133 -0.55707171246422981792 0.014346185968894252169 0.092868727059124162038 -2.4514099982338168893 -0.1079030540471935945 0.16571552719119353458;1.1988520879279445097 -0.16617864818626124079 -0.7423743922078119839 3.1774772999861244926 -1.5283069107926952057 -1.0135002555664223145 -0.61290969684751794855 -0.5206784983555013957 0.072892408882840251105 -0.48339168432094942185 0.12107528633477909752 -0.70708036487264802616 1.9918378679978119283 -0.60829571295816442511 -0.028077734604823434417 1.2987004982337337911 -0.034870584014778771564 -0.68329937206753632584 0.033427546483611472738 -0.0037770285658842903641 0.032745224028324408649 0.048835794556677442069 0.02188253147891054684 -0.057951483476533109662 -0.62784212027570607262 0.52145872587341557391 1.7111797898151637209 -1.5599539551306575991 -0.27961782080785430038 -0.077245086897695866557 -0.26899780100356329715 0.038547617014062306173 0.59175226048911178101 -0.58951681757066964895 0.59106210930744895737 0.05266995303619844554 0.12786861947780417403 0.56638304381116133523 -0.016179939338768128954 0.01346807443750735675];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.1;0.1];
y1_step1.xoffset = [-10;-10];

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
