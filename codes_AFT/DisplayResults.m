function DisplayResults(nCells,nFronts,nNodes,nNewFronts,spTime, generateTime,updateTime,plotTime,tstart,flag)
global crossCount countMode
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
totalTime = toc(tstart);
disp(['totalTime      = ', num2str(totalTime)]);
disp(' ');
end
