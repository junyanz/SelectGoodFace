%% Jun-Yan Zhu (junyanz at eecs dot berkeley dot edu)
% University of California, Berkeley
% select attractive/serious portraits from a personal photo collection

%% set parameters
SetPaths;
CONF = SetConfig;
imgFold = CONF.imgFold;

small_face_size = CONF.smallFace;   % ignore small face
pose_thres = CONF.poseThres;        % ignore non-frontal face
conf_thres = CONF.trackConfThres;   % ignore tracking failure
error_thres = CONF.alignErrorThres; % ignore poor alignment
Load3DFace;

%% download dataset for 'girl'
if strcmp(imgFold, 'data/girl/imgs') && ~exist(imgFold, 'dir')
    DownloadFaceData;
end

%% load images
imgList = LoadImageList(imgFold);
nImgs = numel(imgList);
fprintf('load (%d) images\n', nImgs);
ims = cell(nImgs, 1);
for n = 1 : nImgs
    ims{n} = imread(fullfile(imgFold, imgList{n}));
end

%% detect facial points
detectPath = fullfile(CONF.cacheFold, 'detection.mat');

if ~exist(detectPath, 'file')
    disp('(run) facial point tracking');
    points = cell(nImgs, 1);
    poses = cell(nImgs, 1);
    confs = zeros(nImgs, 1);
    
    % detect facial points (replace your face detection code here)
    if strcmp(CONF.tracker, 'IntraFace')
        [points, poses, confs] = IntraFaceDetectPoints(ims); % IntraFace wrapper
    elseif strcmp(CONF.tracker, 'CLMWILD')
        [points, poses, confs] = CLMWILDDetectPoints(ims);   % CLM-WILD wrapper
    end
    
    save(detectPath, 'points', 'poses', 'confs');
else
    disp('(load) facial point detection');
    load(detectPath);
end

%% ignore "bad" faces
filterPath = fullfile(CONF.cacheFold, 'filter.mat');
if ~exist(filterPath, 'file')
    disp('(run) bad face filtering');
    filterIdx = ones(nImgs,1);
    for n = 1 : nImgs
        % ignore small face
        if size(ims{n}, 1) * size(ims{n}, 2) < small_face_size^2
            filterIdx(n) = 0;
            continue;
        end
        
        pts = points{n};
        pose = poses{n};
        conf = confs(n);
        
        % ignore tracking failure
        if isempty(pts) ||  conf < conf_thres
            filterIdx(n) = 0;
            continue;
        end
        
        % ignore non-frontal face
        if ~isempty(pose)
            if abs(pose(1)) > pose_thres ...
                    || abs(pose(2)) > pose_thres...
                    || abs(pose(3)) > pose_thres
                filterIdx(n) = 0;
                continue;
            end
        end
        
        % ignore poor alignment
        error = AlignError(pts, Ref);% large alignment error
        if error > error_thres
            filterIdx(n) = 0;
            continue;
        end
    end
    
    save(filterPath, 'filterIdx');
else
    disp('(load) bad face filtering');
    load(filterPath, 'filterIdx');
end

remain_ids = find(filterIdx == 1);
imgList = imgList(remain_ids);
nImgs = numel(imgList);
fprintf('(%d) remaining images\n', nImgs);
points = points(remain_ids);
ims = ims(remain_ids);

%% compute features
featPath = fullfile(CONF.cacheFold, 'features.mat');

if ~exist(featPath, 'file')
    disp('(run) feature extraction');
    features = cell(nImgs, 1);
    
    for n = 1: nImgs
        pts = points{n};
        warp_im = WarpFace(ims{n}, Ref, pts);  % warp face to the canonical pose
        features{n} = ExtractFeature(warp_im);  % compute features
    end
    save(featPath, 'features');
else
    disp('(load) feature extraction');
    load(featPath);
end

scorePath = fullfile(CONF.rstFold, 'scores.mat');

%% predict scores
if ~exist(scorePath, 'file')
    disp('(run) score prediction');
    features = cat(2, features{:});
    features = double(features');
    
    % load models
    load(CONF.modelAttractive);
    attractive_model = model;
    load(CONF.modelSerious);
    serious_model = model;
    
    attractive_scores = TestModel(features, attractive_model);
    serious_scores = TestModel(features, serious_model);
    save(scorePath, 'imgList', 'attractive_scores', 'serious_scores');
else
    disp('(load) score prediction');
    load(scorePath);
end

%% save results
disp('save ranked results');

rstFold = CONF.rstFold;
fold = fullfile(rstFold, 'attractive');
mkdirs(fold);
[vs, ids] = sort(attractive_scores, 'descend');

for k = 1 : numel(ids)
    outPath = fullfile(fold, ...
        sprintf('top%3.3d_s%3.3f.jpg', k, vs(k)));
    if ~exist(outPath, 'file')
        imwrite(ims{ids(k)}, outPath);
    end
end

fold = fullfile(rstFold, 'serious');
mkdirs(fold);
[vs, ids] = sort(serious_scores, 'descend');

for k = 1 : numel(ids)
    outPath = fullfile(fold, ...
        sprintf('top%3.3d_s%3.3f.jpg', k, vs(k)));
    if ~exist(outPath, 'file')
        imwrite(ims{ids(k)}, outPath);
    end
end