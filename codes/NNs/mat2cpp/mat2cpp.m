clc;clear;

load('../net_naca0012_20201104.mat','agent')
generatePolicyFunction(agent)

% search coder.EmbeddedCodeConfig for configuration help
cfg = coder.config('lib');
cfg.TargetLang = 'C++';
cfg.TargetLangStandard = 'C++11 (ISO)';
cfg.DeepLearningConfig = coder.DeepLearningConfig('mkldnn');  
codegen evaluatePolicy -config cfg -args {ones(8,2,1,'double')} -report;