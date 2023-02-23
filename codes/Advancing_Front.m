clear;clc;close all;format long;
addpath('./AdFront');
addpath('./DataStructure');
addpath(genpath('./MeshSize'));
addpath('./Optimize');
addpath('./PostProcess');
addpath('./Utilities');
addpath('./NNs');
addpath('./Timer');

%% 建立参数对象
paraObj = ParameterData();

%% 建立计时器管理对象
timeManagerObj = TimerManager();
timeManagerObj.totalTimer.ReStart();

%% 建立作图管理对象
plotObj = PlotClass(paraObj.label_points);

%% 建立边界线网格对象
boundaryDataObj = BoundaryDataClass(paraObj.boundaryFile);
% plotObj.PlotBoundary(boundaryDataObj);

%% 建立网格尺度控制对象
timeManagerObj.spTimer.ReStart();
meshSizeObj = MESHSIZE(paraObj, boundaryDataObj);
timeManagerObj.spTimer.Span(0);
timeManagerObj.spTimer.AccumulateTime();

%% 建立阵面推进对象，推进生成网格
adfrontObj = AdFront2(paraObj, boundaryDataObj, meshSizeObj, timeManagerObj, plotObj);
adfrontObj.AdvancingFront();

%% 建立后处理对象，输出最终结果
posprocessObj = PostProcessClass(paraObj, adfrontObj, timeManagerObj);
posprocessObj.DisplayFinalResults();

%% 建立优化对象，进行对角线交换和弹簧优化
optimizeObj = OptimizeClass(boundaryDataObj,adfrontObj);
optimizeObj.EdgeSwap();
optimizeObj.SpringOptimize(3);
    