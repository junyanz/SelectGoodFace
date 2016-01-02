function Input = Recover3DPose(Img,inputpts,Ref)
Ref.alignpoints(10:13,:) = [];
szeModel = size(Ref.RGB);        % 3D model image size 
refpts = Ref.alignpoints(:,1:2); % ref points in 2D
Input.alignpoints = inputpts;    % input 2D points
Input.Img = Img;                 % original image 
numfp = length(inputpts);        % number of points - 13
Input.numfp = numfp;
% align 2D xy with 3D xy
Input.TFORM = cp2tform(inputpts,refpts,'affine');  % estimate a global affine transformation
Input.alignImg = imtransform(Img,  Input.TFORM,'XData',...
[1 szeModel(2)],'YData',[1 szeModel(1)],'Size',szeModel(1:2)); % apply global transformation
% align 
Input.TFORM2 = cp2tform(inputpts,refpts,'nonreflective similarity');   
yadd=150; xadd=150; %.7*yadd;
Input.alignImg2 = imtransform(Img,Input.TFORM2,'XData',... 
    [-xadd szeModel(2)+xadd],'YData',[-yadd szeModel(1)+yadd*.2],'Size',szeModel(1:2)+[yadd*1.2 xadd*2]);


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
A = [AR ; cross(AR(1,:),AR(2,:))];
t = p22 - A(1:2,:)*p33;   % remove tranlation  
t(3) = 0;


% set data
Input.A = A;
Input.t = t;
Input.p3 = p3;
