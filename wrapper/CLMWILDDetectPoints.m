function [points, poses, confs] = CLMWILDDetectPoints(ims)
clm_model = 'CLMWILD/model/DRMF_Model.mat';
fprintf('load clm model (%s)\n', clm_model);
load(clm_model);
nImgs = numel(ims);
bbox_method = 0;
visualize = 0;
points = cell(nImgs, 1);
poses = cell(nImgs, 1);
confs = zeros(nImgs, 1);

parfor n = 1 : nImgs
    facedata = [];
    facedata(1).name = sprintf('image_%4.4d', n); 
    facedata(1).img = im2double(ims{n});
    facedata(1).bbox = [];
    facedata(1).points = [];
    facedata(1).pose = [];
    facedata = DRMF(clm_model, facedata, bbox_method, visualize);
    if ~isempty(facedata(1).points)
        points{n} = GetPoints(facedata(1).points);
    end
    if ~isempty(facedata(1).pose)
        poses{n} = facedata(1).pose;
    end
    confs(n) = 1;
end
end

function [pnts9] = GetPoints(pnts)
% pnts9 = zeros(9, 2);
map = [37, 40, 43, 46, 32, 34, 36, 49, 55];
pnts9 = pnts(map, :); 
% for k = 1 : numel(map);
%     pnts9(k, :) = pnts(map(k), :);
% end
end

