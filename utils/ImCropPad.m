function [crop] = ImCropPad(im, rect) 
% rect: [xmin, ymin, width, height]
%% pad pixels
xmin = rect(1);
ymin = rect(2);
xmax = rect(3)+rect(1)-1;
ymax = rect(4)+rect(2)-1;
xpad= max(xmax-size(im,2)+1, -xmin);
ypad = max(ymax-size(im,1)+1, -ymin);
pad = ceil(max(xpad, ypad));

if pad <= 0
    crop = imcrop(im, rect);
else
    im_pad = padarray(im, [pad, pad], 0);
    %% imcrop
    rect(1:2) = rect(1:2) + pad;
    crop = imcrop(im_pad, rect);
end

end

