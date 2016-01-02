modelName = 'Ref_face_mesh'; 
load(modelName);

Ref.alignpoints(10,:) = mean(Ref.alignpoints(1:2,:),1);
Ref.alignpoints(11,:) = mean(Ref.alignpoints(3:4,:),1);
Ref.alignpoints(12,:) = mean(Ref.alignpoints(2:3,:),1);
Ref.alignpoints(13,:) = mean(Ref.alignpoints(8:9,:),1);
numfp = 13;

for i = 1:numfp;       
    Ref.alignpoints(i,3) = Ref.Z(round(Ref.alignpoints(i,2)),round(Ref.alignpoints(i,1)));
end
