function DisplayResults(adfrontObj, nNewFronts, flag)
nCells = adfrontObj.nCells;
nFronts = adfrontObj.nFronts;
nNodes = adfrontObj.nNodes;
crossCount = 0;
countMode = adfrontObj.countMode;
spTime = adfrontObj.timeManagerObj.spTimer.totalTime;
generateTime = adfrontObj.timeManagerObj.generateTimer.totalTime;
updateTime = adfrontObj.timeManagerObj.updateTimer.totalTime;
plotTime = adfrontObj.timeManagerObj.plotTimer.totalTime;
totalTime = adfrontObj.timeManagerObj.totalTimer.totalTime;

if strcmp(flag,'midRes') == 1
    disp('=================================');
    disp('==========�ƽ�������...==========');
    disp(['nCells      = ',   num2str(nCells)]);
    disp(['����ʵʱ���� ��',   num2str(nFronts)]);
    disp(['����������   ��',   num2str(nNewFronts)]);
    
elseif strcmp(flag,'finalRes') == 1
    disp('=================================');
    disp('==========�ƽ�������ɣ�=========');
    disp(['�����ƽ���ɣ���Ԫ�� ��', num2str(nCells)]);
    disp(['�����ƽ���ɣ��ڵ��� ��', num2str(nNodes)]);
    disp(['�����ƽ���ɣ������ ��', num2str(nFronts)]);
    disp(['crossCount          = ', num2str(crossCount)]);    
end

disp(['countMode    = ', num2str(countMode)]);
disp(['spTime       = ', num2str(spTime)]);
disp(['generateTime = ', num2str(generateTime)]);
disp(['updateTime   = ', num2str(updateTime)]);
disp(['plotTime     = ', num2str(plotTime)]);
disp('=================================');
disp(['totalTime      = ', num2str(totalTime)]);
disp(' ');
end
