function Sym = Estimate_Symmetry(x,y);

ellipse_t = fit_ellipse(x,y);

ptCloud        = pointCloud([x,y,zeros(length(x),1)]);
ptCloud_Center = pointCloud([ellipse_t.X0_in,ellipse_t.Y0_in,0]);

angle = (ellipse_t.phi);

B = [cos(angle) sin(angle) 0 0; ...
     -sin(angle) cos(angle) 0 0; ...
     0 0 1 0; ...
     0 0 0 1];
 
tform = affine3d(B);

ptCloudOut_2  = pctransform(ptCloud,tform);
rotatedCenter = pctransform(ptCloud_Center,tform);

Sym = length(find(ptCloudOut_2.Location(:,1)>rotatedCenter.Location(:,1)))/...
      length(find(ptCloudOut_2.Location(:,1)<rotatedCenter.Location(:,1)));
end



