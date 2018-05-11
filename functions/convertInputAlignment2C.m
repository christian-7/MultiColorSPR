function [MList_C1,data0_C1,MList_C2,data0_C2] = convertInputAlignment2C(refLocs,poILocs,pxlsize);


% This function generates the input variable for the 2D particle alignment
% and averaging.

xCol = [];yCol = [];sigma = [];frame = []; particleID = []; photons = []; width = []; data0 = []; MList = {};

for i = 1:length(refLocs);
    
    xCol        = vertcat(xCol,refLocs{i,1}(:,1)-mean(refLocs{i,1}(:,1)));
    yCol        = vertcat(yCol,refLocs{i,1}(:,2)-mean(refLocs{i,1}(:,2)));
    photons     = vertcat(photons,refLocs{i,1}(:,5));
    frame       = vertcat(frame,refLocs{i,1}(:,3));
    particleID  = vertcat(particleID,zeros(length(refLocs{i,1}),1)+i);
    width       = vertcat(width,refLocs{i,1}(:,8)*2);
    
end

MList_C1.C         = zeros(length(xCol),1)+2;
MList_C1.Xc        = xCol/pxlsize;
MList_C1.Yc        = yCol/pxlsize;
MList_C1.Width     = width;
MList_C1.ID        = frame;
MList_C1.I         = photons;
MList_C1.Frame     = particleID;

data0_C1(:,1) = zeros(length(xCol),1)+2;
data0_C1(:,2) = xCol/pxlsize;
data0_C1(:,3) = yCol/pxlsize;
data0_C1(:,4) = width;
data0_C1(:,5) = frame;
data0_C1(:,6) = photons;
data0_C1(:,7) = particleID;


xCol = [];yCol = [];sigma = [];frame = []; particleID = []; photons = []; width = []; data0_C2 = []; MList_C2 = {};

for i = 1:length(poILocs);
    
    xCol        = vertcat(xCol,poILocs{i,1}(:,1)-mean(refLocs{i,1}(:,1)));
    yCol        = vertcat(yCol,poILocs{i,1}(:,2)-mean(refLocs{i,1}(:,2)));
    photons     = vertcat(photons,poILocs{i,1}(:,5));
    frame       = vertcat(frame,poILocs{i,1}(:,3));
    particleID  = vertcat(particleID,zeros(length(poILocs{i,1}),1)+i);
    width       = vertcat(width,poILocs{i,1}(:,8)*2);
    
end

MList_C2.C         = zeros(length(xCol),1)+2;
MList_C2.Xc        = xCol/pxlsize;
MList_C2.Yc        = yCol/pxlsize;
MList_C2.Width     = width;
MList_C2.ID        = frame;
MList_C2.I         = photons;
MList_C2.Frame     = particleID;

data0_C2(:,1) = zeros(length(xCol),1)+2;
data0_C2(:,2) = xCol/pxlsize;
data0_C2(:,3) = yCol/pxlsize;
data0_C2(:,4) = width;
data0_C2(:,5) = frame;
data0_C2(:,6) = photons;
data0_C2(:,7) = particleID;

end

