function feat = ExtractFeatures(im)
rects{1} = [25, 20, 120, 170]; sizes{1} = [80, 64]; % faces: 8*6
rects{2} = [28, 143, 114, 44]; sizes{2} = [32, 64]; % mouth: 2*6
rects{3} = [28, 60, 44, 45]; sizes{3} = [48, 64]; %left eye: 4*6
rects{4} = [98, 60, 44, 45]; sizes{4} = [48, 64]; %right eye: 4*6
rects{5} = [50, 45, 75, 30]; sizes{5} = [32, 64]; % wrinkle: 2*6
nParts = numel(rects);
hogs = cell(nParts, 1);
% disp = im; 

for n = 1 : nParts
    rect = rects{n};
    rect(3:4) = rect(3:4)-1;
    patch = imcrop(im, rect);
    patch = imresize(patch, sizes{n});
    hog = single(features31(im2double(patch), 8));
    hogs{n} = hog(:);
end
% figure(1), imshow(disp);
feat = cat(1, hogs{:});
end