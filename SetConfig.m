% author: Jun-Yan Zhu (UC Berkeley)
% function: set paramters
function CONF = SetConfig()
% set the data folder 
CONF.tracker = 'IntraFace'; 
% IntraFace: please download intraface from http://www.humansensing.cs.cmu.edu/intraface/
% CLMWILD: please download CLM-WILD from https://sites.google.com/site/akshayasthana/clm-wild-code
CONF.dataFold = 'data/demo/'; % data folder 
CONF.imgFold = fullfile(CONF.dataFold, 'imgs');  % image folder 
CONF.cacheFold = fullfile(CONF.dataFold, [CONF.tracker '_cache']);  % cache folder
CONF.rstFold = fullfile(CONF.dataFold, [CONF.tracker '_result']); % result folder
CONF.modelAttractive = fullfile('models', [CONF.tracker '_attractive_model.mat']); % path to attractiveness model
CONF.modelSerious = fullfile('models', [CONF.tracker '_serious_model.mat']);       % path to seriousness model

mkdirs({CONF.imgFold, CONF.cacheFold, CONF.rstFold}); 

% ignore bad images
CONF.smallFace = 250; % ignore small face
CONF.poseThres = 15;  % ignore non-frontal face (e.g. 15 degree)
CONF.trackConfThres = 0.5;  % ignore tracking failure (e.g. confidence <0.5)
CONF.alignErrorThres = 8; % ignore poor alignment (e.g. mean pixel error > 8)
end