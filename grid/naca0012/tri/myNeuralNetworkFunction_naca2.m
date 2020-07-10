function [Y,Xf,Af] = myNeuralNetworkFunction_naca2(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 06-Jul-2020 11:21:33.
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
b1 = [0.010529091875236479617;0.04335535520520848729;0.61128891180797984006;-0.00098237605734299718666;0.0012458713991503650616;-0.0012804857185013886374;-0.0032697459743797003054;0.00074198712752270858887;0.186172050663044375;-0.25891133858452597405;-0.10262930446187097655;-0.0017834567041100932508;0.00026428221472551320995;-0.10603517672808925043;-0.001120774852100524634;-0.00072966688489029820578;0.00092668870042634219914;0.24717246871737699743;-0.49157575876493703193;-0.14798515845505974542;-0.0012330950353526197276;0.28765706392534967639;1.0376513951654720014;0.18144170071686335777;0.017879876979195748199;0.0012973227772535632189;0.17553906831670321176;-0.4623888125962279938;-0.036392585642035756022;-0.51100547900238557641;0.057062624637371058001;0.0038662774211230448509;0.015306345958033854351;0.0010528805881741731734;-0.15614643235013861422;-0.017803968613153003941;0.074211524892341090842;0.10276266181551972634;0.00054571434358334871585;-0.77836605249375589999];
IW1_1 = [-0.10929039412783800311 -0.18562701441506862521 -0.015754323501458153411 -0.17281683697276473133 0.24589487045284472155 0.33234397028664497409 0.42668419746305102924 0.087116208513489182264;-0.058283069616164140392 -0.26310180248612097254 0.83832207676365222415 0.14898562916349281093 0.11517792102496694773 1.0696722979790624919 -0.60492978071939251805 -0.029107357899672253732;0.048411679967563917004 0.19258567167149467925 -0.1278625311267931608 0.034019722205312651064 0.022283656069687216711 -1.0938406063682133418 1.0453942298099103692 0.023314281512727769163;-0.70866357433056836879 -2.647680216903881778 2.6689784481922207426 0.69028399243286719944 -0.024419560524563926895 1.9473639166465315231 -3.2809655496056269186 1.3526376149788721381;0.50935632354076454398 2.6537141158175958644 -5.7724257941003704886 2.6059664196221410393 0.035496487787412281389 -1.4403143604300423508 1.0805183110803142643 0.32781417773199239551;-0.484409062145324254 2.1661501734240653505 -1.496311427485105261 -0.18374187463287416922 2.2385004450378205298 -0.67221084460723079523 -1.5652577041552726556 0.0014126647835981994555;0.1034142179323956634 -5.3632285737361939937 5.3419618832580955115 -0.079299992624275991715 -0.10828048229208955822 0.75934409698751859086 -0.58190799605502874225 -0.069247485113980378202;1.3645697583125504515 0.48928045062517672159 -1.7036443109606707047 -0.15361081975176307801 2.0718961564879609938 -3.258651688835152882 0.89938924580221102367 0.28810920537933421004;0.22359550361012825448 0.33804496297167579977 -0.025245260268329995645 -0.1337700273845472132 -0.61668143890545779051 -0.012339964800493423425 -1.1121448891851613006 -0.094683108374309515876;-0.14754880091486660687 0.30238479319600303219 -0.30953717019164223023 0.060454404779436775319 0.21961952740087822833 0.97586465882192341414 -0.28485582473478382459 0.042499291731469303335;0.56508206595252497006 0.31356085482986539859 0.74821166806494621149 0.15160726328697349263 0.16242403634176982852 -0.52406075774784477428 0.10791426895255007423 -0.24592939319604728565;0.40376297797110144439 0.68860921976017663848 -1.066171790557596033 -0.032986030729555922136 -0.58528671831333922704 -4.2948601346664707634 4.8302880746839846893 0.050332033625565701651;2.2973760702578784887 0.80911925788221328304 -3.0022121443708424948 -0.10824797248145651141 -0.82557181763483622472 -0.06583553267486255689 0.62739077335386916889 0.26636631670655785964;0.58614100267036417513 0.74452763284351441975 0.4121835862494719338 0.16126305957460149165 0.16842533615288990401 0.2496372716005121617 -0.67603022469207618705 -0.29394628622124124862;-0.27959698975156366263 0.54432757646194562806 -1.2008243576445125633 0.94103469057992361613 0.78813649280495823302 2.0328140014590134754 -0.79792746032275929657 -2.0182357426176023019;0.036853114501982926765 1.0644155625690012723 -1.0225655761573306801 -0.070576271086494113405 0.41549430215163540847 4.9994968324478179511 -5.3040692610792694595 -0.10987622357840069742;0.18190994759528306135 -0.82019404433835862989 -1.5444094013912104124 2.1817424885400109602 -0.76203806590544542754 -1.6938134759722591749 2.2976447811596920623 0.15677976824432288128;-0.06775209518621791438 -0.49297629646694512973 0.44474482908970125461 -0.024447916754536256484 -0.033188921265258415627 0.79158745251374518226 -0.96630365420572683632 -0.05968522184620708021;0.071481208826465636452 0.71560367299831029175 -0.93954975249927863423 -0.099031773857398822103 0.069792377658687537734 0.27628021972658800554 -0.058931173923902388512 0.06124903706862045577;0.20279212049570041754 0.64414590476907107597 -0.40850326050206603457 0.12081544714001704599 -0.57608437943572454731 -0.85585537262537025871 -0.58961927964143889813 -0.13026743650604530322;-1.7103688474139493447 3.4013666491839362749 -1.6346498030175156124 -0.055159804254608882368 -1.1031414230531575438 2.0038637982586280373 -1.0087995113937155978 0.11022992079897143969;0.20287706686076772966 0.17347301712670501472 -0.054350260429162876308 -0.12895426080425576032 -0.40990011103799306458 -0.36337210790272117533 -0.44656876878788803742 -0.069853271739558700504;-0.020248622083040148517 0.032364550868048611032 -0.13650876193325239827 -0.046997252833353521384 -0.01747868837945337761 1.248511296248739022 -1.0259845742557103243 -0.0043382736228623590413;0.024627133194666341043 -0.97982755774347185529 0.76561693189125201719 -0.10727310864192150797 -0.045033329376576572423 0.27304929241422604136 -0.55327021294307587862 -0.0056744491669808907325;0.025979177395542861484 0.38421228004150642654 0.34181047569368572248 0.21758228403643201099 0.12045345717688273057 0.4217474097270952349 0.066624841176662480402 -0.033797355808411901068;-1.9580944731851859242 1.1158058917487760908 0.58536159969029444294 0.25584150715317760527 0.020542318903320394563 -1.792899161305148148 1.701547903976349474 0.06919676326067930594;0.29579818911538213744 0.50160192697821659458 -0.044498176215526451249 -0.052213785574879469087 -0.88358475187422946817 -1.6371385921116570206 -0.26445499115348286567 -0.17206273527224469344;0.23721501593498478533 -0.27717823674522690247 0.52327562949217754085 0.19974636887164495813 -0.74677275899388684266 -1.2769179813343929375 -0.57433828225993355243 -0.19219236653449306429;-0.053608055549850840149 0.54455296958528132123 -0.84129280789564908627 0.037383374282652211129 -0.10539988792560868458 0.45542882067308276817 -0.54105158784983076181 -0.026793085386719695667;-0.074756474865788624662 -0.86154066248986416188 1.0317490485270055522 0.089867423165845852773 -0.081194096393349152185 0.074022192460810570802 -0.19457459988463027267 -0.05715962494201978078;0.11298218390452283155 -0.026767981945584988501 -0.37061939397602011725 -0.18041470029898121208 -0.015306892024153979925 -0.3685879588397505402 -0.0067247439979880498789 0.07311164955794879905;0.050654599571364596067 0.089680556077224402034 0.54102985180290885658 0.18454133244888751286 0.11659811527269872689 -0.58683236796244775402 0.94008726074172888065 -0.025939136124129048844;-0.57376880218064474359 -1.1960896810827568171 -0.89955787437185674715 -0.63311539980015785201 -0.4075661643014587554 -1.0431818108279837798 -0.082188324488691497094 -0.40825565293340371209;0.80902345789822815991 2.3423483145542518535 -2.2112801055528330529 -0.94300025197630665819 0.054731841260334139487 -1.7050319839733529825 -0.44839379721433508807 2.1003189030346391952;-0.26860758154272673659 -0.46480542881420600088 0.052032937260959949421 0.094340750487170915717 0.79454420740019482405 0.76550002134252759234 0.83680251543882699927 0.13470927504180785217;0.59466604949123780255 0.90109761376856090109 1.247258809781772948 0.63853898569080724812 0.44479710150075052466 0.29726168908341604746 0.77518837420363184698 0.46023235643631316139;0.074444939138062007911 -0.63456722690067413062 0.79782938148100424058 0.082121820427336178483 -0.17220746156717325892 -0.67052392228566137788 0.099867610416521118699 -0.07355416156991002874;-0.57492821074874989051 -0.43038869226714054905 -0.69023579078427088618 -0.14744017950749035983 -0.1663609438903480009 0.096292639369762303425 0.3238845113883317417 0.27034666164943538247;0.35872775299740022881 -0.87491956341907417549 1.493381867207041136 -0.97978423397917113746 -0.73014642290483289244 -1.9408636507699077445 4.4278650115832194345 -1.7590705145526022157;0.10728519100294720001 0.64228484863799328863 -0.61171757520314484768 -0.16218234220733984685 -0.15701697487548849086 -1.2315687789615834546 0.29341482410067465381 -0.057101586041635107871];

% Layer 2
b2 = [0.51007730031497677814;-0.33184398162088635242];
LW2_1 = [-0.044184320137013871621 -0.41894102952510087201 1.9748625104511108308 2.7866004444149976571 -1.821072787913748714 1.6264974268813068292 -1.1024033745907797499 2.6540296539796801589 0.79496072562597452915 -0.68315868585355088438 0.44167099677994581253 -0.018064528137514350437 2.411431902418467832 0.092002160551079084638 -2.0327059564218954435 2.3606932282744654827 2.5378455638197405797 -1.3616542817211765293 -0.97103810639390397697 0.027672730544563046984 2.5833387837146628563 -0.74060212792455792918 -1.8645895076908225452 0.26850028549359622465 0.73688968615338956702 0.4807365014189436403 0.36221102316908793117 0.0052120169686502059239 -1.2580257857039347513 0.73978106075751803861 -0.6977106262573913309 -0.96003907302999347273 0.22290947538324415444 -2.4730791097596500627 0.79233755270948358351 0.21167446426992436725 -0.47547023533917764926 0.49712889384610070564 2.3205053673018496418 -0.074721084428422415713;0.5611096389472598478 -0.60726113317896635024 -0.40380884134828765042 -1.6402158927101333497 1.3256711040553788017 3.1579539595325898382 2.8606071288258889673 -0.93533089605563324298 0.043354257055031958368 0.79517920004169639903 0.35311196721738402626 -3.1139238641941600072 -0.8821992621465065687 0.43988446862322666542 -1.4618107869696956858 -1.5739217102721558827 1.8745106092174552703 -0.9363099919691031392 1.1494102792982607841 0.3537496334799190012 2.5588336546596388565 0.21122145707464057285 0.62877955060267498588 0.96464442586837284566 0.39262263753611853501 -2.7915824841840533033 -0.015013698301822536382 -0.11714386693760389657 -1.7801595559929865864 -1.3263379175591529791 -0.78158581888100453483 -0.40675653581168008666 -0.050428213548561723334 1.4360599417261743493 0.12720737373803436832 -0.048871948776532066205 1.0933819688560146854 0.79507343632653348919 2.2793168265028400654 -0.14458406505469142966];

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