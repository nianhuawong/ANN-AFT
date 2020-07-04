clc;clear;
S1 = load('cy10-wdist.mat','input','target');
S2 = load('cy20-wdist.mat','input','target');
S3 = load('cy30-wdist.mat','input','target');
S4 = load('cy40-wdist.mat','input','target');
S5 = load('cy50-wdist.mat','input','target');
input = [S1.input;S2.input;S3.input;S4.input;S5.input];
target = [S1.target;S2.target;S3.target;S4.target;S5.target];

save('cy-all-wdist.mat','input','target')