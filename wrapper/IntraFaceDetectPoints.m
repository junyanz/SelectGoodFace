function [points, poses, confs] = IntraFaceDetectPoints(ims)
%% load IntraFace model (replace your face detection code here)
disp('cd IntraFace');
cd('IntraFace');
[DM,TM,option] = xx_initialize;
disp('cd ..');
cd('..');

%% detect points
nImgs = numel(ims);
points = cell(nImgs, 1);
poses = cell(nImgs, 1);
confs = zeros(nImgs, 1);

for n = 1 : nImgs
    faces = DM{1}.fd_h.detect(ims{n}, 'MinNeighbors', option.min_neighbors,...
        'ScaleFactor', 1.2, 'MinSize', option.min_face_size);
    % select the largest face
    if isempty(faces) 
        output= [];
    else
        tmp = cat(1, faces{:});
        [~, face_id] = max(tmp(:,3) .* tmp(:,4));
        face = faces{face_id};
        output = xx_track_detect(DM, TM, ims{n}, face, option);
    end
    
    if ~isempty(output) && ~isempty(output.pose);
        pose = output.pose.angle;
        pose(3) = 180 - pose(3);
        poses{n} = pose; 
    end
    
    if ~isempty(output) && ~isempty(output.pred)
        points{n} = IntraFaceGetNinePoints(double(output.pred));
    end
    
    if ~isempty(output) && ~isempty(output.conf)
        confs(n) = output.conf;
    end
end
end

function [pnts9] = IntraFaceGetNinePoints(pnts)
% pnts9 = zeros(9, 2);
map = [20,23, 26, 29, 15, 17, 19, 32, 38];
pnts9 = pnts(map, :); 
% for k = 1 : numel(map);
%     pnts9(k, :) = pnts(map(k), :);
% end
end
