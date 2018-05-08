function [aligniter,iterIm,s,n_frame,allIm,data,images0,ParticlesAligned] = runAlignmentXS_2C(MList,data0,data0_C2,imsize,zoomfactor, pixelsize, photonpercount,usfac,angrange,angstep,n_iteration);

% The 2D alignment and averaging code was developed by Xiaoyu Shi@Bo Huang Lab at UCSF
% The procedure is described in: Shi, Xiaoyu et al., Nature Cell Biology 19.10 (2017): 1178.
% The full code package is available at: 

fprintf('Generating image array ...\n');

HRdimension = 3; % 3D array
[imagesRaw] = NormalizedGaussianHR(MList,imsize,zoomfactor, pixelsize, photonpercount, HRdimension);
nframe      = size(imagesRaw,3);
images0     = imagesRaw;

for i=1:1:nframe
    [images0(:,:,i)]= LowerImages(imagesRaw(:,:,i),10);   % desity weight, lower contrast
end

%% align & save aligned molec list

[aligniter,iterIm,s,n_frame,allIm,data,ParticlesAligned] = rotregistrationALL_2C(images0,data0,data0_C2,usfac,angrange,angstep,n_iteration,zoomfactor);

