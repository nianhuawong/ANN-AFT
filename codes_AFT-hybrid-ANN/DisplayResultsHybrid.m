function DisplayResultsHybrid(nCells,nFronts,nNodes,nNewFronts,nCells_quad,nCells_tri,generateTime,updateTime,plotTime, flag)
global crossCount countMode_quad countMode_tri;
if strcmp(flag,'midRes') == 1
    disp('================================');
    disp('==========推进生成中...==========');
    disp(['nCells      = ',       num2str(nCells)]);
    disp(['nCells_quad = ', num2str(nCells_quad)]);
    disp(['nCells_tri  = ', num2str(nCells_tri)]);
    disp(['阵面实时长度  ：',   num2str(nFronts)]);
    disp(['新增阵面数    ：',     num2str(nNewFronts)]);
    
elseif strcmp(flag,'finalRes') == 1
    disp('================================');
    disp('==========推进生成完成！=========');
    disp(['阵面推进完成，单元数    ：', num2str(nCells)]);
    disp(['阵面推进完成，quad单元数：', num2str(nCells_quad)]);
    disp(['阵面推进完成，tri单元数 ：', num2str(nCells_tri)]);    
    disp(['阵面推进完成，节点数    ：', num2str(nNodes)]);
    disp(['阵面推进完成，面个数    ：', num2str(nFronts)]);
    disp(['crossCount             = ', num2str(crossCount)]);
end

disp(['countMode_quad = ', num2str(countMode_quad)]);
disp(['countMode_tri  = ', num2str(countMode_tri)]);
disp(['countMode_tot  = ', num2str(countMode_quad + countMode_tri)]);
disp(['generateTime   = ', num2str(generateTime)]);
disp(['updateTime     = ', num2str(updateTime)]);
disp(['plotTime       = ', num2str(plotTime)]);

end
