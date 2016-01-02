function newimg = WarpToFrontalFace(im, P3m, P3o, mask)
% im  -- aligned image;
% P3m -- P3 (ref model points after 3d alignment transformation)
% P3o -- the points before the transformation -- Ref.Points

[h, w, c]=size(im);
P3m(:,~mask)=[];
P3o(:,~mask)=[];

newimg=zeros(h, w, c);

for i = 1 : length(P3m)
    x = round(P3m(2,i));
    y = round(P3m(1,i));

    xnew = round(P3o(2,i));
    ynew = round(P3o(1,i));

    if xnew > 0 && ynew > 0 && xnew < w && ynew < h ...
            && x < w && y < h && x > 0 && y > 0
        newimg(ynew, xnew, :) = im(y, x, :);
    end
end

newimg = uint8(newimg);

