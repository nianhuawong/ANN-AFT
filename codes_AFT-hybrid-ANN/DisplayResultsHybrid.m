function DisplayResultsHybrid(nCells,nFronts,nNodes,nNewFronts,nCells_quad,nCells_tri,generateTime,updateTime,plotTime, flag)
global crossCount countMode_quad countMode_tri;
if strcmp(flag,'midRes') == 1
    disp('================================');
    disp('==========�ƽ�������...==========');
    disp(['nCells      = ',       num2str(nCells)]);
    disp(['nCells_quad = ', num2str(nCells_quad)]);
    disp(['nCells_tri  = ', num2str(nCells_tri)]);
    disp(['����ʵʱ����  ��',   num2str(nFronts)]);
    disp(['����������    ��',     num2str(nNewFronts)]);
    
elseif strcmp(flag,'finalRes') == 1
    disp('================================');
    disp('==========�ƽ�������ɣ�=========');
    disp(['�����ƽ���ɣ���Ԫ��    ��', num2str(nCells)]);
    disp(['�����ƽ���ɣ�quad��Ԫ����', num2str(nCells_quad)]);
    disp(['�����ƽ���ɣ�tri��Ԫ�� ��', num2str(nCells_tri)]);    
    disp(['�����ƽ���ɣ��ڵ���    ��', num2str(nNodes)]);
    disp(['�����ƽ���ɣ������    ��', num2str(nFronts)]);
    disp(['crossCount             = ', num2str(crossCount)]);
end

disp(['countMode_quad = ', num2str(countMode_quad)]);
disp(['countMode_tri  = ', num2str(countMode_tri)]);
disp(['countMode_tot  = ', num2str(countMode_quad + countMode_tri)]);
disp(['generateTime   = ', num2str(generateTime)]);
disp(['updateTime     = ', num2str(updateTime)]);
disp(['plotTime       = ', num2str(plotTime)]);

end
