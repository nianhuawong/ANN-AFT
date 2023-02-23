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
    disp('==========推进生成中...==========');
    disp(['nCells      = ',   num2str(nCells)]);
    disp(['阵面实时长度 ：',   num2str(nFronts)]);
    disp(['新增阵面数   ：',   num2str(nNewFronts)]);
    
elseif strcmp(flag,'finalRes') == 1
    disp('=================================');
    disp('==========推进生成完成！=========');
    disp(['阵面推进完成，单元数 ：', num2str(nCells)]);
    disp(['阵面推进完成，节点数 ：', num2str(nNodes)]);
    disp(['阵面推进完成，面个数 ：', num2str(nFronts)]);
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
