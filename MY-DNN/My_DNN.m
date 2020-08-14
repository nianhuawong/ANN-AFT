clc;clear;
% load('F:/ANN_Grid/grid/inv_cylinder/tri/inv_cylinder-40.mat');
% load('../grid/airfoil-training/tri-fine/naca0012-t.mat');
load('../grid/naca0012/quad/naca0012-quad-quadBC.mat');
% load('F:\ANN_Grid\grid/naca0012/tri/naca0012-tri-quadBC.mat');
% load('F:\ANN_Grid\grid\airfoil-training\tri\airfoil.mat');
% load('F:\ANN_Grid\grid/naca0012/tri/naca.mat');
net_name = 'net_naca0012_quad_fine_ns'; %net_naca0012_tri;net_cylinder_tri
input = input';
target = target';
num_of_samples = size(input,2);
num_of_traning_samples = round(1.0*num_of_samples);

Train = input(:,1:num_of_traning_samples);
Label = target(:,1:num_of_traning_samples);

Test  = input(:,num_of_traning_samples + 1:end);
Tag   = target(:,num_of_traning_samples + 1:end);

% mapminmax

net = feedforwardnet([15 8],'trainlm'); %trainscg;traingda£»trainlm
% net = newrb(Train,Label,SPREAD)
net.layers{1}.transferFcn = 'tansig'; %radbas;radbasn;poslin;tansig;logsig;purelin;softmax
% net.layers{2}.transferFcn = 'radbas';
% net.layers{3}.transferFcn = 'poslin';

% net.trainParam.lr = 0.01;
% net.trainParam.lr_inc = 1.05;
% net.trainParam.epochs = 1000;
% net.trainParam.max_fail = 6;
net.divideFcn = 'dividerand'; %dividerand;divideblock
% net.performFcn = 'crossentropy';
% net.performParam.regularization = 0.1;
% net.performParam.normalization = 'none';
% miniBatchSize = 100;
% options = trainingOptions('sgdm', 'MiniBatchSize',miniBatchSize, 'ValidationData',{Test,Tag},'ValidationFrequency',10);

net = train(net,Train,Label,'useParallel','yes');
view(net)

% res1 = net(Train);
% perf1 = perform(net,res1,Label);

res2 = net(Test);
% perf = perform(net,res2,Tag);
perf = crossentropy(net,Tag,res2,{1},'regularization',0.1);
% perf = mse(net, Tag, res2, 'regularization', 0.01);
genFunction(net, net_name);