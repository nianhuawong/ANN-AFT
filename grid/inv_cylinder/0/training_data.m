clc;clear;
samples = 1;
filePath = './cy50/cy50-';
savePath = './cy50-all.mat';
input = [];
target = [];
for i = 1:samples 
    varName = strcat('S', num2str(i));
    outfile = strcat(filePath, num2str(i),'.mat');
    varName = load(outfile, 'input','target');
    input = [input; varName.input];
    target = [target;varName.target];
end

save(savePath,'input','target')

% 
% S1 = load('cy10.mat','input','target');
% S2 = load('cy10-2.mat','input','target');
% S3 = load('cy10-3.mat','input','target');
% S4 = load('cy10-4.mat','input','target');
% S5 = load('cy10-5.mat','input','target');
% S6 = load('cy10-6.mat','input','target');
% S7 = load('cy10-7.mat','input','target');
% S8 = load('cy10-8.mat','input','target');
% S9 = load('cy10-9.mat','input','target');
% S10 = load('cy10-10.mat','input','target');
% S11 = load('cy10-11.mat','input','target');
% S12 = load('cy10-12.mat','input','target');
% S13 = load('cy10-13.mat','input','target');
% S14 = load('cy10-14.mat','input','target');
% S15 = load('cy10-15.mat','input','target');
% S16 = load('cy10-16.mat','input','target');
% S17 = load('cy10-17.mat','input','target');
% S18 = load('cy10-18.mat','input','target');
% S19 = load('cy10-19.mat','input','target');
% S20 = load('cy10-20.mat','input','target');
% input = [S1.input;S2.input;S3.input;S4.input;S5.input;...
%          S6.input;S7.input;S8.input;S9.input;S10.input;...
%          S11.input;S12.input;S13.input;S14.input;S15.input;...
%          S16.input;S17.input;S18.input;S19.input;S20.input];
% target = [S1.target;S2.target;S3.target;S4.target;S5.target;...
%           S6.target;S7.target;S8.target;S9.target;S10.target;...
%           S11.target;S12.target;S13.target;S14.target;S15.target;...
%           S16.target;S17.target;S18.target;S19.target;S20.target];
