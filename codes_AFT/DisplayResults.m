function DisplayResults(nCells,nFronts,nNodes,nNewFronts,countMode,generateTime,updateTime,plotTime, flag)
if strcmp(flag,'midRes') == 1
    disp('================================');
    disp('==========�ƽ�������...==========');
    disp(['nCells = ',       num2str(nCells)]);
    disp(['����ʵʱ���ȣ�',   num2str(nFronts)]);
    disp(['������������',     num2str(nNewFronts)]);
    
elseif strcmp(flag,'finalRes') == 1
    disp('================================');
    disp('==========�ƽ�������ɣ�=========');
    disp(['�����ƽ���ɣ���Ԫ����', num2str(nCells)]);
    disp(['�����ƽ���ɣ��ڵ�����', num2str(nNodes)]);
    disp(['�����ƽ���ɣ��������', num2str(nFronts)]);
end

disp(['countMode    = ', num2str(countMode)]);
disp(['generateTime = ', num2str(generateTime)]);
disp(['updateTime   = ', num2str(updateTime)]);
disp(['plotTime     = ', num2str(plotTime)]);

end
