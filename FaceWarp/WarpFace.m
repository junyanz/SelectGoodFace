function img_aligned = WarpFace(img, Ref, pts)
Input = Recover3DPose(img, pts, Ref);
P3  = Input.A* Ref.P' + repmat(Input.t, 1, numel(Ref.Z));
img_aligned = WarpToFrontalFace(Input.alignImg,P3,Ref.P',Ref.M);
end

