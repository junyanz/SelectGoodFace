function [error] = AlignError(inputpts,Ref )
Ref.alignpoints(10:13,:) = [];
refpts = Ref.alignpoints(:,1:2); % ref points in 2D
Input.alignpoints = inputpts;    % input 2D points
numfp = length(inputpts);        % number of points - 13
Input.numfp = numfp;
Input.TFORM = cp2tform(inputpts,refpts,'affine');  % estimate a global affine transformation

refalignpoints = Ref.alignpoints;  % 3D pnts
p2 = tformfwd(Input.TFORM, Input.alignpoints); % apply transformation to 2D points
p2 = p2(:,[2 1])';  % exchange x,y for 3D points
p3 = refalignpoints(:,[2 1 3])'; % exchagne x, y for 3D points

% remove translation
p22 = mean(p2,2);
p33 = mean(p3,2);
p2c = p2-p22*ones(1,numfp);
p3c = p3-p33*ones(1,numfp);

% find 2D to 3D affine
AR = p2c*p3c'*inv(p3c*p3c'); % solve AR * p3c = p2c
error = (AR*p3c-p2c).^2;
error = mean(sqrt(error(1,:)+error(2,:)));

end

