clear;clc;close all;format long;
addpath('./AdFront');
addpath('./DataStructure');
addpath(genpath('./MeshSize'));
addpath('./Optimize');
addpath('./PostProcess');
addpath('./Utilities');
addpath('./NNs');
addpath('./Timer');

%% ������������
paraObj = ParameterData();

%% ������ʱ���������
timeManagerObj = TimerManager();
timeManagerObj.totalTimer.ReStart();

%% ������ͼ�������
plotObj = PlotClass(paraObj.label_points);

%% �����߽����������
boundaryDataObj = BoundaryDataClass(paraObj.boundaryFile);
% plotObj.PlotBoundary(boundaryDataObj);

%% ��������߶ȿ��ƶ���
timeManagerObj.spTimer.ReStart();
meshSizeObj = MESHSIZE(paraObj, boundaryDataObj);
timeManagerObj.spTimer.Span(0);
timeManagerObj.spTimer.AccumulateTime();

%% ���������ƽ������ƽ���������
adfrontObj = AdFront2(paraObj, boundaryDataObj, meshSizeObj, timeManagerObj, plotObj);
adfrontObj.AdvancingFront();

%% �����������������ս��
posprocessObj = PostProcessClass(paraObj, adfrontObj, timeManagerObj);
posprocessObj.DisplayFinalResults();

%% �����Ż����󣬽��жԽ��߽����͵����Ż�
optimizeObj = OptimizeClass(boundaryDataObj,adfrontObj);
optimizeObj.EdgeSwap();
optimizeObj.SpringOptimize(3);
    