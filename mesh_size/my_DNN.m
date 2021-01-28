 clc;clear;
load('./data/mesh_size_sample.mat');
net_name = '../codes_AFT/nets/nn_mesh_size_naca_31'; 
input = input';output = output';
num_of_samples = size(input,2)
%%
num_of_traning_samples = round(1.0*num_of_samples);
Train = input(:,1:num_of_traning_samples);
Label = output(:,1:num_of_traning_samples);

Test  = input(:,num_of_traning_samples + 1:end);
Tag   = output(:,num_of_traning_samples + 1:end);
%% 网络建立及训练方法
% mapminmax %trainscg;traingda；trainlm；trainbr；trainrp
net = feedforwardnet([10],'trainlm'); 
% net = newrb(Train,Label,SPREAD)
%% 激活函数 %radbas;radbasn;poslin;purelin;tansig;logsig;softmax
net.layers{1}.transferFcn = 'tansig'; 
% net.layers{2}.transferFcn = 'poslin';
% net.layers{3}.transferFcn = 'poslin';
% net.layers{4}.transferFcn = 'poslin';

% net.trainParam.lr = 0.01;
% net.trainParam.lr_inc = 1.05;
net.trainParam.epochs = 50000;
% net.trainParam.max_fail = 6;
%% 样本分成训练集，测试集，验证集 %dividerand;divideblock;divideint;divideind
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 0.7;
net.divideParam.valRatio   = 0.15;
net.divideParam.testRatio  = 0.15;
%% LOSS函数定义，默认为MSE；还有MAE; SAE; SSE
% net.performFcn = 'crossentropy';
% net.performParam.regularization = 0.1;
% net.performParam.normalization = 'none';
%% 训练样本
% miniBatchSize = 100;
% options = trainingOptions('sgdm', 'MiniBatchSize',miniBatchSize, 'ValidationData',{Test,Tag},'ValidationFrequency',10);
%% 
net = train(net,Train,Label,'useParallel','no');
% view(net)
%% 训练效果评估
% res1 = net(Train);
% perf1 = perform(net,res1,Label);

% res2 = net(Test);
% perf = perform(net,res2,Tag);
% perf = crossentropy(net,Tag,res2,{1},'regularization',0.1);
% perf = mse(net, Tag, res2, 'regularization', 0.01);
%% 输出保存ANN
genFunction(net, net_name);