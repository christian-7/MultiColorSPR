function [MList,data0] = convertInputAlignment(ParticleLocs,pxlsize);

% This function generates the input variable for the 2D particle alignment
% and averaging.

xCol = [];yCol = [];sigma = [];frame = []; particleID = []; photons = []; width = []; data0 = []; MList = {};

for i = 1:length(ParticleLocs);
    
    xCol        = vertcat(xCol,ParticleLocs{i,1}(:,1)-mean(ParticleLocs{i,1}(:,1)));
    yCol        = vertcat(yCol,ParticleLocs{i,1}(:,2)-mean(ParticleLocs{i,1}(:,2)));
    photons     = vertcat(photons,ParticleLocs{i,1}(:,5));
    frame       = vertcat(frame,ParticleLocs{i,1}(:,3));
    particleID  = vertcat(particleID,zeros(length(ParticleLocs{i,1}),1)+i);
    width       = vertcat(width,ParticleLocs{i,1}(:,8)*2);
    
end

MList.C         = zeros(length(xCol),1)+2;
MList.Xc        = xCol/pxlsize;
MList.Yc        = yCol/pxlsize;
MList.Width     = width;
MList.ID        = frame;
MList.I         = photons;
MList.Frame     = particleID;

data0(:,1) = zeros(length(xCol),1)+2;
data0(:,2) = xCol/pxlsize;
data0(:,3) = yCol/pxlsize;
data0(:,4) = width;
data0(:,5) = frame;
data0(:,6) = photons;
data0(:,7) = particleID;

end

