function [Y,Xf,Af] = net_naca0012_tri_41(X,~,~)
%NET_NACA0012_TRI_41 neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 07-Aug-2020 12:15:32.
% 
% [Y] = net_naca0012_tri_41(X,~,~) takes these arguments:
% 
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = 8xQ matrix, input #1 at timestep ts.
% 
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = 3xQ matrix, output #1 at timestep ts.
% 
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.keep = [1 4 5 8];
x1_step2.xoffset = [-2.12536489745503;-0.544114911973483;-2.27223783018806;-2.01913439235065];
x1_step2.gain = [0.547198330660698;0.508916130469259;0.449921353851259;0.480678119723576];
x1_step2.ymin = -1;

% Layer 1
b1 = [-1.9685698554468029631;1.766962878854837049;4.5881041233063051266;-3.6738392861290041225;-4.0578295337432637169;-5.2863852392927839219;1.7778871241769242939;-0.75198604194703910775;-2.292100522970819565;-2.8951254388524017003;0.81609223059109070597;0.91124447915117923191;-0.28915388761020982544;1.7267261865439813562;0.76135693013640504123;-0.077290250412894570542;1.3001490157590842589;-1.3303794322702839903;-1.663608602132219616;-0.22601464529866260866;1.622888727532487696;-1.5807511188382874501;5.9667279039633385196;-1.5600666422303099967;-1.4053777762333854451;4.0268931060722046311;-3.518174765366138157;1.8760353040392567792;1.9105185606503525264;-1.0018426340399604335];
IW1_1 = [-0.18568394576457283862 -0.54971352715956878221 1.5201069292461202309 -1.3265528043515213419;0.37946009451797202416 3.5903140268706992266 0.19599054119861589185 -0.6197636604905777391;-3.3474030494226378885 1.5651230620146865391 -4.0174803814718176298 -4.6604998595132984818;3.9788088807787369561 -1.5421224502054691197 0.95719238416395724389 2.9474746356652388179;3.6322373558565992369 -1.6111550223462618447 0.50993376326495853945 4.0836824444504813414;7.4734120658427318773 -0.38487475204624893577 0.43021475613019938278 -4.7894100292210195491;-2.5504888798867071387 -2.1328746284216424378 -0.38147401659540153274 0.99840855684907114931;-0.11714106548869883395 0.29242810591620876925 -0.96673541532725082437 -1.0260338083299314071;2.7857057619351284217 -2.6996258956092296089 1.2779588567171369373 -0.084101228925802046232;3.9358028254177805927 0.97153788822092213007 -0.31148822385435837035 2.4414542178598410693;-0.84811414496106585226 -0.27393262875524804212 -5.2480224458747573024 0.48297409915940248126;-2.0304188291206126671 -0.3758224887769767153 1.8421099664670084195 -1.9926851074007101428;-0.72569700791582203436 -1.2883877567723773794 0.85808658033384377362 1.0334611565092466368;-2.1845008368903480189 1.8398889525928019406 -0.052671316705556574245 -0.29848861511554036774;-4.8525563594062894879 -0.8894023068296639245 -12.949699032303410462 0.38383298472462479278;0.91228657749798236498 0.6057278274744601898 -0.99375340703374293039 -0.71460729754729834795;-0.13282000715557124026 4.1124887248938541973 0.66944743128872086224 3.1580811123574208388;-0.9356215729013037663 -4.2559921871036685559 2.1109647209715300953 -0.61471443535575409634;0.026118422544487662068 -4.7987582926784844162 -1.4544826454055774789 0.38472570080559487238;1.0051045339781758958 0.90497366535572643098 -0.92600104895175405773 -0.28941208048504651895;0.68868538832615766587 1.2162515225013146303 3.2907076322276478386 -2.2311053458742331479;-2.3291992271444170726 -2.1958718026744130647 0.027605070245777095506 -0.49743799427445140049;1.2019637960913365227 7.2692949732330838231 -7.3962486490078500623 0.40254334781262407494;0.57271552215614274228 -0.9617768698819821882 -0.062256222515253187288 -1.3373027982432184047;0.023769172581692598473 -0.918196459614899263 -2.7180701345605200459 0.27274512961844693537;4.2001429074274589937 7.7056723835928551125 0.98822433791645880596 0.32549463320055682658;3.383579967454299009 -1.9978796909299707529 3.4271498872867778296 0.16917230446045333769;0.2415068398522433879 2.8286131265561884618 0.57966226134301157558 -2.3994289414766303281;1.7218444170561328921 -1.1584187476238243519 -0.11464040441935216541 -0.9468158650506696139;0.48620356011322474199 -0.26847078648248584587 1.0883631262983439747 1.7831094156788074301];

% Layer 2
b2 = [-22.999099498103188211;-13.936255815638077138;15.643806581319120497;-12.614296536556100392;-16.170402157907325602;-1.0710858879058424709;15.768705385345807457;2.9399597200828373467;19.388084588062515223;1.1858097308161219541;-0.77962870151495566873;1.9728789250793723475;-5.863055471692107723;13.91214102068958347;-10.82189124473668862;-4.3458964125939285594;-0.16176177260101579081;-0.40190784663820228184];
LW2_1 = [-23.401577670922524277 3.0047983791595531677 -0.61504483005484222868 -4.4963146651853369562 1.8912449311265222551 -1.5762629942570505204 -0.28596364489774600548 1.061729787334884989 -2.5088712414310050391 -0.21841726448231407742 0.74000183891543991344 0.532228287769423547 -4.0640860621161456478 -4.3815875355204996211 -0.16790802734552473519 -5.4542860293760249135 3.9890266071539137727 1.7631723833376116151 2.0093582234541340625 -2.435743659211833112 -2.2280885474023817139 1.1196922105340973985 4.0152894029584524915 15.304101199294022351 -1.2836484313919416245 3.2347221873241696066 1.3593335464793105949 1.0252275944432414079 2.0524596953010836309 1.8854788401775668394;1.552181553485103116 0.59232647636112290002 -0.24270963485442739738 -2.7511978773498602102 3.9025050268815526522 -1.0879182932372533088 -2.1557994957649557755 -0.63250785660315089753 -1.1367148740792076822 -2.6685656984962702332 0.98958745488228305742 -1.2176593770771466652 -4.9914535596426565789 -1.2833240906872689369 -1.3963924324495813334 10.813091915448012514 -0.56863370220393916199 2.0006426789262596877 2.0455837573736501689 -4.7415903851094807209 -1.2315523463000173088 3.6875251889080491452 0.78035249833439435108 -2.7587010727528884502 -2.9732696882953817408 8.5306251527384997502 -0.069468646226826247236 3.8853287758279342334 6.2879204187281878546 10.378902558279024859;0.1150492586914397819 -11.167844336708522945 0.78034558137287779456 2.2176950354722464454 -0.57002634855988787432 2.3750799485056957039 -0.37752485334026003594 3.9838122245741001137 -7.9569772102519040757 -2.622670796898271206 -4.8983244331333795074 -1.9709093245227582436 -0.42573818404433233509 -8.6609245496593967317 -0.55127514617880102321 -4.3839898536405259577 -2.3540745257849673422 -1.732680859472835122 -3.2942184337264825977 7.680980880660322363 9.8727799123263721981 3.7837125556916220148 0.28471024835983066437 1.2549105302832974651 6.0322335782520966063 3.151055333268542924 1.6395103514924240784 1.961277356199605304 -9.6827220951466426158 0.086396477680422814616;0.45896824184560758297 -0.03475376870962051945 0.2879286160502692038 5.6367992360906091776 -7.1795059128732594544 -0.267776678536764845 1.3306331485520903612 -0.55363471241989758997 1.0288720461559908159 -5.7957684819483699101 0.32917345122061042462 0.050235204024222476771 0.76089331774118407203 2.1009778260879499179 -0.28556261574545477311 2.6433856245692850528 0.23890136391841285124 0.073187911002686512063 0.33474157986419489363 -0.93827583394567137809 -0.10510014323989655405 0.37814342858061067432 -0.10749921641169477016 -1.7996975506128358724 -0.54052039010463981406 0.14828518790687958417 -0.34578425880243895962 0.59537957326662416246 0.51963677222105175701 0.15647605370439549022;1.7430692055180794231 1.1051026473698166708 -0.68512550039979347449 4.8275417856138584938 -4.6097077040163574324 -1.9678164874868748768 1.6976244952010794975 -2.362759366089562274 -0.35135868375381107409 -8.4367108520053424314 -0.12781286669360655828 -0.33371958277722296726 0.79778834282303412451 2.5377032249071032055 0.0002408809679552537217 9.027070090014353454 0.11002247166898175557 0.58154321544649367759 0.71931532095987882336 -5.7337745148577665688 0.2838179812584291084 0.66377626999389893747 1.1088323624132740974 -5.3176656908523449729 -0.5242895230636079873 0.24049970988333210786 1.698806518711738045 -0.078304862366057617629 -1.1835425048741765597 0.74262974797672909322;2.7747290105234081459 1.2475951183204878614 1.4996055012108890914 -1.2950659424023382993 -0.44873684513833811405 -0.016345653300627677185 -0.22969414429022561031 -2.2122326475778542054 0.51608455854950374686 4.0769301842793890245 -0.7070107095156423771 1.9655193768970311563 4.8939576240847610933 0.11531217356911983851 0.55023746392716499365 13.7893893575031381 -0.46394368337053343287 0.13420642751205280607 1.0117717583501846246 -7.0015470756974611533 -1.5380081746987239733 0.43329145334179919313 0.18194313048391738685 -10.86671650874291295 -0.89080126379081270294 -0.067659125436812433962 -1.0843984249909410789 0.40540288901183291204 -6.2895755597823077565 2.9176307031060555452;-0.47208186036394100826 -0.40721530596091243259 0.25087974518417111014 -3.2973037643019758036 2.6386705774410210701 2.126107143712442582 -2.6004744258039664828 1.1161006964022917032 1.4319417156056450935 8.819313102192182896 0.24007645267348759477 0.096005711816223679445 0.10849565713066117167 -1.1263625592186123914 0.12782522978203639252 -4.060264807191328984 -0.10602554164165103878 -0.26244040598680107301 -0.50765779502211971774 2.2472519868032114765 0.15364085377599634441 -0.54640463794527349695 -0.93685141438865326968 3.2755157908523853116 1.1401924032924550811 -0.37276082840328988999 -2.5985261006170321529 -0.20602453908933696103 0.5274896354263673981 -0.2221555872556774669;0.07925705182952653971 0.035853566160253848294 0.43300079880363240292 0.97732856907422738235 -0.50581592817215415003 0.34666780911268191279 -0.14267557260049898438 1.1183599238358874484 -0.78695496057300307058 -0.73267876952165478244 -0.094092188125831685563 -0.30190572013469252344 0.065713734289167269331 -0.041777743574519056458 -0.043807679810279866184 -3.2261151955551166104 -0.20857666434817220824 0.012381057000872079318 0.17112034334914238976 3.9572015561667721606 -0.13073608863691818516 0.16098018590620388757 0.2867000682294881253 1.1386230704008406533 -0.47481449510954865101 -0.00029419938740158431585 0.1835670404041266357 0.20507664262773428465 -0.064977835812699655249 0.6007190654595919721;-0.46021621393428352453 10.482239646587368398 -0.30519279195883025624 2.0340868038529573703 -2.3752643150367278579 -0.23078936623346257839 -0.27886040828059216468 -0.61438147880945959134 -1.0983104935673475566 0.32228218040832484759 0.23751770272666777872 0.36522722069792401545 0.28826509535785627136 -1.2521200381141472935 0.01963880621970190421 3.090354419836788491 -0.44874698040356231221 1.2097356491833903824 8.0675141763905955372 -2.8097367172340748098 -0.41515451006122439104 0.2376666726415815889 -16.140773644198652903 2.1379559568311838902 0.058206055889274424531 -0.5490641776724948242 -0.30768007108815681461 -1.0501298030805958916 0.75796754201750538016 0.60635367914217452867;-3.2177167074260504265 2.6067660054427825855 1.4600391374554997359 2.8280627402918918634 -3.271113325369301883 0.073950369338080967907 -0.042408123778934575521 0.16876113878038637162 0.21976374823944094805 0.68114535167302958651 1.1751556194707866165 -0.32104840241190268912 0.58630743265570917089 1.2109090495976306823 -0.85842302546849780231 -1.0144787750871884224 0.4206284244786859805 0.11587753995521327122 -0.36564342088140283638 0.85520633390900846482 -2.1670964144497784076 0.036091779672340340568 -0.3878397409341336477 3.4444302094559064997 -1.9129506464386079045 -0.37742049025497392822 0.065447149737614951359 -3.6358717782146001696 0.16004141089309589785 0.59470074810235118434;-0.51705712921891733291 0.21627165911509879659 -0.06951911635264257372 -0.36024928543193318609 0.21934839140248268974 -0.16583605545375332269 0.087907765748117580595 0.52860575288126776528 0.2614675571684923483 0.045043493073986182185 0.02782763891880998125 -0.50995254617088925375 -0.10635929959154487301 0.35667144215154722442 -0.10609615667845674614 0.5472661828082465707 -0.13337708802003434005 0.022279785148388433352 0.31446961363340469875 -0.75761365586105489101 0.024200316852175607352 0.11199730734820644018 -0.088659866061296929707 -0.72624500149550141881 -0.29284828971853221757 -0.067948723247000172853 -0.10285604285185043216 0.26234700601692534372 -0.28949614795837069758 -0.41888136772453660184;-0.5260270991632933768 -0.51869799302106300853 0.32088106909044833426 0.19055011935384072452 0.87842197627721363418 0.7226596108136040808 0.15422767947249924059 1.5249990329922480381 -2.1561612050730354362 -1.2805023146539529222 -0.30252041629917325594 -1.2402692055052810804 1.8775718055365548942 -1.1840202734544233998 -0.39521787127038032761 -5.1242064986716657771 -0.28651345385670601296 -0.29071921614119050625 0.64492093161364993925 7.0416723939079535199 0.14441119307703154107 0.81683979825529351437 0.88242897816390264421 3.134610204604840078 -1.123085581487993867 0.56208028069257021109 1.0746917893516647613 1.5538143222498419505 -0.34303780153251017815 -1.5703507493844381937;0.35545648623471581828 -0.38488054362881590764 2.2465809869230390916 -0.94681597148841911693 -0.37694110394069790804 -0.02844287020570031993 0.11715160361616418216 0.92126302099340340312 -0.33865460233301025728 0.028505273698634946145 0.75717323771220035322 -0.083253947107213094325 0.12393811798502819832 -0.17852747678819744226 -0.3392018798608851804 0.36686953941517547184 0.22263971008303923282 0.088752044731977661196 -0.10639260972815250961 -0.60127943582874299189 -0.08229941562470644012 0.039744143321090531773 0.032155392827579218351 -0.1790979685680504363 -0.22864173562656686656 0.26017694785604544849 -0.25692569338116405531 0.66990492810669577395 0.88810736477561802449 -0.37806065270317479321;-0.029842241455711196463 0.26979585360006241856 -0.41108926878952928297 -5.6232288748006977741 6.5599690485896502423 0.27574383985762168647 -1.8051890212840455696 0.42511102459544908294 -0.87904055278975201659 6.906509638700324416 -0.27216703175976175721 0.067419844427575967294 -0.6640657883949170337 -2.2340356151208995428 0.39433124624745757858 -2.4173447916187011941 -0.24531930272862137454 -0.035494444532569266459 -0.30290072181149679809 0.80501018992509698613 0.36111663116486203418 -0.3969176301771826787 0.17325130504225522143 1.7375861479072935989 1.0468786662450424441 -0.21901106843437215255 0.05933947736834047082 -0.78098432422067320946 -0.49774356095161231828 0.018704348080384659847;1.0078088935437721219 2.5544287780004051314 -1.3090505261434450812 -0.79825038535678694007 -0.087497072456973273846 -2.6628244458022019003 3.2809357889408157227 -0.25990880711307062789 2.6129169447853173303 -4.9294034210076853597 -0.2744168399479989251 -0.23527192255493337147 3.2652978971305688383 3.2059060722665284615 0.063734957129760586025 5.4619952311926356359 0.00026144610642672651193 0.50566314703429515731 1.2422494725725841125 1.2366008534483086123 -0.26278358951221869599 1.2548491709573679209 -0.068184193853681157593 -3.351624936623204043 -1.083397106587008496 -0.60919494473955237979 -0.78763194696630767222 -0.36201486559756018702 -1.6912189516014715096 -0.015447311818993090388;-0.033188912167732349812 -0.16068066528962335338 -0.77500297073116031221 -1.9058672241722229845 1.0188334304383315221 -0.1995860985911022123 0.73996607596432772969 -2.3538184081329851516 1.3898415918875788311 0.92943474800600633934 0.29774607341659414805 0.53096924593057615027 -0.84215504351423453588 0.10128673397182076654 0.14236689770104493657 3.1556958609060972165 0.31107113403057978784 -0.22588733592231469149 -0.23753569800643001275 -4.8683551994455056544 0.39837677093622431146 -0.059427838971411912905 -0.28104726598780938041 -1.1884114306722108889 1.0605063324623198451 -0.071880007826636865831 -0.26957089308237947023 -0.43560096967802441892 0.47194904201014442613 -0.52413931009006298201;-0.45912117383002198912 -1.3002022947659681584 2.0670073044060321976 5.560570089581129416 -3.1463170527071282478 0.066529455111045326943 -0.4704499252928164843 0.82149649085214571098 -0.94196251383840579052 -0.29494331153678010615 0.42852204388488684961 0.43133199474830413722 -1.3472743223057068729 -0.57978467896811425319 -0.12215670348746995866 1.2609047121611516307 0.58921893515685075382 0.61857478917596442347 -0.17737897385794459959 -2.5323401338526529969 0.24132294581750804441 -0.25671084701931407013 0.10803137959596588458 0.66888894870099990797 0.63142058578269744107 0.85930899310422859116 0.4527179386967208341 -1.0181761790689252134 -0.009852490588203080199 -0.60643878700023690076;-0.85126991417687003505 -0.75237228107170839309 2.5354047785767308554 5.6005095981632155855 -3.0216406028619120505 0.11694637714780763138 -0.61051252489339113971 0.26983679687260231361 -0.52143512730078334094 -0.28171307514385873771 0.51419304650021069314 0.37806008042274269476 -0.99057295961405722462 -0.36784885224631397316 -0.12267088911532862683 1.1467529484029839182 0.75056552174474688854 0.49237276922498163234 0.083118969969504172268 -2.7678744235539944896 0.75116601780689440382 -0.2238021189245213427 0.063831900103546751479 0.74778713813009722866 1.4390444151433139375 0.76304489843565748153 0.43612561384213560656 -1.1298826822941197001 -0.46455427270145555063 -0.62789036276993559493];

% Layer 3
b3 = [0.17817160168362061734;0.33287985421297805466;-0.89679404296039000322];
LW3_2 = [-0.34723061356511580877 0.1457621629378326733 0.095160741344611526893 0.84411350916146854484 -1.0485562391737108801 0.15282281999890878765 -1.3431035288169466124 -3.1926084430104308964 1.1114756539072203623 0.045209024443609600874 -0.6582373922211766093 0.28174499522897089587 0.62986315818925797672 1.3810564699883356443 0.3918534628251504337 -2.3109282692827655126 -1.1892616870081169633 1.1827527661286139082;-0.29894714431650992736 -0.035637243250780721582 -0.073064055433062893852 -4.566184401602695786 0.72347198795601852517 0.19673650725566477204 1.0021124310750606501 1.3456269987028401935 -0.92016750799257007731 -0.48067590302393081725 -1.2376151693817150079 -0.34129958290456863246 1.5603397228265831753 -3.6479779308113786662 0.23276151406086872941 0.55798438037282238611 -0.79979820084422126314 0.87574239137786957787;-0.027630071908442913747 -0.0026129926860305120913 -0.007857265283024928576 -0.094973938904567525854 0.024185089125283019962 -0.00011496567528552963729 0.033936646036969442264 0.13145865416584168184 0.010638113048281426856 -0.0228723645349688115 -0.057860600119842807432 -0.016019774270291300272 0.064378748688702205905 -0.093357679489451131372 -0.012746478698034647767 0.085081617846758439416 -0.076029061213883877834 0.072445685426401271179];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.994189532150814;1.12173777583708;1.59778745470188];
y1_step1.xoffset = [-0.526262919467617;0.274479210544353;0.000930762255008352];

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
    temp = removeconstantrows_apply(X{1,ts},x1_step1);
    Xp1 = mapminmax_apply(temp,x1_step2);
    
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

% Remove Constants Input Processing Function
function y = removeconstantrows_apply(x,settings)
  y = x(settings.keep,:);
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
