function [locs_Ch1, Fid_Ch1,locs_Ch2, Fid_Ch2] = splineFit_Fiducials(Avg_Ch1_new,Avg_Ch2_new,NbrBins,radius,smoothingFactor,startFrame,handles);

%%%%%

% NbrBins             = 100;
% radius              = 200; % Radius around the fiducial center
% smoothingFactor     = 100;
% startFrame          = 1000;

%%%%%

% Channel 1

[splineResX,AvgCurveX,pX] = splineFit(Avg_Ch1_new(:,1),Avg_Ch1_new(:,2),NbrBins,radius,smoothingFactor); % (xData,yData,NbrBins,radius,smoothingFactor);
[splineResY,AvgCurveY,pY] = splineFit(Avg_Ch1_new(:,1),Avg_Ch1_new(:,3),NbrBins,radius,smoothingFactor);

figure('Position', [200 200 700 500],'NumberTitle', 'off', 'Name', 'Drift correction Ch1')
subplot(2,3,1)
scatter(Avg_Ch1_new(:,1),Avg_Ch1_new(:,2),2,'b'), hold on;
plot(splineResX(:,1),splineResX(:,2),'r.'), hold on;
axis([0 max(Avg_Ch1_new(:,1)) -radius radius])
axis square; box on

subplot(2,3,2)
plot(AvgCurveX(:,1),AvgCurveX(:,2),'o'); hold on;
fnplt(csaps(AvgCurveX(:,1),AvgCurveX(:,2),pX/smoothingFactor),'r--')
legend('noisy data','smoothing spline'), hold off
axis([0 max(Avg_Ch1_new(:,1)) -radius radius])
axis square; box on

subplot(2,3,4)
scatter(Avg_Ch1_new(:,1),Avg_Ch1_new(:,3),2,'b'), hold on;
plot(splineResY(:,1),splineResY(:,2),'r.'), hold on;
axis([0 max(Avg_Ch1_new(:,1)) -radius radius])
axis square; box on

subplot(2,3,5)
plot(AvgCurveY(:,1),AvgCurveY(:,2),'o'); hold on;
fnplt(csaps(AvgCurveY(:,1),AvgCurveY(:,2),pY/smoothingFactor),'r--')
legend('noisy data','smoothing spline'), hold off
axis([0 max(Avg_Ch1_new(:,1)) -radius radius])
axis square; box on

% Correct Channel 1 Averages Tracks

Avg_Ch1_new(:,4) = csaps(AvgCurveX(:,1),AvgCurveX(:,2),pX/smoothingFactor, Avg_Ch1_new(:,1)); % spline fit of the X Ch1
Avg_Ch1_new(:,5) = csaps(AvgCurveY(:,1),AvgCurveY(:,2),pY/smoothingFactor, Avg_Ch1_new(:,1)); % spline fit of the Y Ch1

Avg_Ch1_new(1:startFrame,4) = 0;
Avg_Ch1_new(1:startFrame,5) = 0;

Avg_Ch1_new(:,4) = Avg_Ch1_new(:,4)-Avg_Ch1_new(startFrame,4); % deltaX
Avg_Ch1_new(:,5) = Avg_Ch1_new(:,5)-Avg_Ch1_new(startFrame,5); % deltaY

% Correct Channel 1 Fiducial Tracks

handles.Fid_Ch1(:,handles.deltaXCol+1) = csaps(AvgCurveX(:,1),AvgCurveX(:,2),pX/smoothingFactor, handles.Fid_Ch1(:,handles.frameCol));
handles.Fid_Ch1(:,handles.deltaYCol+1) = csaps(AvgCurveY(:,1),AvgCurveY(:,2),pY/smoothingFactor, handles.Fid_Ch1(:,handles.frameCol));

handles.Fid_Ch1(1:startFrame,handles.deltaXCol+1) = 0;
handles.Fid_Ch1(1:startFrame,handles.deltaYCol+1) = 0;

handles.Fid_Ch1(:,handles.deltaXCol+1) = handles.Fid_Ch1(:,handles.deltaXCol+1)-handles.Fid_Ch1(startFrame,handles.deltaXCol+1); % deltaX
handles.Fid_Ch1(:,handles.deltaYCol+1) = handles.Fid_Ch1(:,handles.deltaYCol+1)-handles.Fid_Ch1(startFrame,handles.deltaYCol+1); % deltaY

% Test it
% scatter(handles.Fid_Ch1(:,handles.frameCol),handles.Fid_Ch1(:,handles.xCol)-handles.Fid_Ch1(:,handles.deltaXCol),1,'k');hold on;
% scatter(handles.Fid_Ch1(:,handles.frameCol),handles.Fid_Ch1(:,handles.yCol)-handles.Fid_Ch1(:,handles.deltaYCol),1,'r');

% Correct Channel 1 locs

handles.locs_Ch1(:,handles.deltaXCol) = csaps(AvgCurveX(:,1),AvgCurveX(:,2),pX/smoothingFactor, handles.locs_Ch1(:,handles.frameCol));
handles.locs_Ch1(:,handles.deltaYCol) = csaps(AvgCurveY(:,1),AvgCurveY(:,2),pY/smoothingFactor, handles.locs_Ch1(:,handles.frameCol));

handles.locs_Ch1(1:startFrame,handles.deltaXCol) = 0;
handles.locs_Ch1(1:startFrame,handles.deltaYCol) = 0;

handles.locs_Ch1(:,handles.deltaXCol) = handles.locs_Ch1(:,handles.deltaXCol)-handles.locs_Ch1(startFrame,handles.deltaXCol); % deltaX
handles.locs_Ch1(:,handles.deltaYCol) = handles.locs_Ch1(:,handles.deltaYCol)-handles.locs_Ch1(startFrame,handles.deltaYCol); % deltaY

handles.locs_Ch1(:,handles.xCol) = handles.locs_Ch1(:,handles.xCol)-handles.locs_Ch1(:,handles.deltaXCol); % substract deltaX from X Col
handles.locs_Ch1(:,handles.yCol) = handles.locs_Ch1(:,handles.yCol)-handles.locs_Ch1(:,handles.deltaYCol); % substract deltaY from Y Col


subplot(2,3,3)
scatter(Avg_Ch1_new(:,1),Avg_Ch1_new(:,2)-Avg_Ch1_new(:,4),1,'b'), hold on;
axis([0 max(Avg_Ch1_new(:,1)) -radius radius])
axis square; box on
title('X trajectory after correction');

subplot(2,3,6)
scatter(Avg_Ch1_new(:,1),Avg_Ch1_new(:,3)-Avg_Ch1_new(:,5),1,'b'), hold on;
axis([0 max(Avg_Ch1_new(:,1)) -radius radius])
axis square; box on
title('Y trajectory after correction'); 

% Channel 2

[splineResX,AvgCurveX,pX] = splineFit(Avg_Ch2_new(:,1),Avg_Ch2_new(:,2),NbrBins,radius,smoothingFactor);
[splineResY,AvgCurveY,pY] = splineFit(Avg_Ch2_new(:,1),Avg_Ch2_new(:,3),NbrBins,radius,smoothingFactor);

figure('Position', [200 200 700 500],'NumberTitle', 'off', 'Name', 'Drift correction Ch2')
subplot(2,3,1)
scatter(Avg_Ch2_new(:,1),Avg_Ch2_new(:,2),2,'b'), hold on;
plot(splineResX(:,1),splineResX(:,2),'r.'), hold on;
axis([0 max(Avg_Ch2_new(:,1)) -radius radius])
axis square; box on
title('X trajectory before correction');

subplot(2,3,2)
plot(AvgCurveX(:,1),AvgCurveX(:,2),'o'); hold on;
fnplt(csaps(AvgCurveX(:,1),AvgCurveX(:,2),pX/smoothingFactor),'--')
legend('noisy data','smoothing spline'), hold off
axis([0 max(Avg_Ch2_new(:,1)) -radius radius])
axis square; box on

subplot(2,3,4)
scatter(Avg_Ch2_new(:,1),Avg_Ch2_new(:,3),2,'b'), hold on;
plot(splineResY(:,1),splineResY(:,2),'r.'), hold on;
axis([0 max(Avg_Ch2_new(:,1)) -radius radius])
axis square; box on
title('Y trajectory before correction');

subplot(2,3,5)
plot(AvgCurveY(:,1),AvgCurveY(:,2),'o'); hold on;
fnplt(csaps(AvgCurveY(:,1),AvgCurveY(:,2),pY/smoothingFactor),'--')
legend('noisy data','smoothing spline'), hold off
axis([0 max(Avg_Ch2_new(:,1)) -radius radius])
axis square; box on

% Correct Channel 2 X Averages

Avg_Ch2_new(:,4) = csaps(AvgCurveX(:,1),AvgCurveX(:,2),pX/smoothingFactor, Avg_Ch2_new(:,1)); % spline fit of the X Ch1
Avg_Ch2_new(:,5) = csaps(AvgCurveY(:,1),AvgCurveY(:,2),pY/smoothingFactor, Avg_Ch2_new(:,1)); % spline fit of the Y Ch1

Avg_Ch2_new(1:startFrame,4) = 0;
Avg_Ch2_new(1:startFrame,5) = 0;

Avg_Ch2_new(:,4) = Avg_Ch2_new(:,4)-Avg_Ch2_new(startFrame,4); % deltaX
Avg_Ch2_new(:,5) = Avg_Ch2_new(:,5)-Avg_Ch2_new(startFrame,5); % deltaY

% Correct Channel 2 Fiducial Tracks

handles.Fid_Ch2(:,handles.deltaXCol+1) = csaps(AvgCurveX(:,1),AvgCurveX(:,2),pX/smoothingFactor, handles.Fid_Ch2(:,handles.frameCol));
handles.Fid_Ch2(:,handles.deltaYCol+1) = csaps(AvgCurveY(:,1),AvgCurveY(:,2),pY/smoothingFactor, handles.Fid_Ch2(:,handles.frameCol));

handles.Fid_Ch2(1:startFrame,handles.deltaXCol+1) = 0;
handles.Fid_Ch2(1:startFrame,handles.deltaYCol+1) = 0;

handles.Fid_Ch2(:,handles.deltaXCol+1) = handles.Fid_Ch2(:,handles.deltaXCol+1)-handles.Fid_Ch2(startFrame,handles.deltaXCol+1); % deltaX
handles.Fid_Ch2(:,handles.deltaYCol+1) = handles.Fid_Ch2(:,handles.deltaYCol+1)-handles.Fid_Ch2(startFrame,handles.deltaYCol+1); % deltaY

% Test it
% scatter(handles.Fid_Ch2(:,handles.frameCol),handles.Fid_Ch2(:,handles.xCol)-handles.Fid_Ch2(:,handles.deltaXCol+1),1,'k');hold on;
% scatter(handles.Fid_Ch2(:,handles.frameCol),handles.Fid_Ch2(:,handles.yCol)-handles.Fid_Ch2(:,handles.deltaYCol+1),1,'r');

% Correct Channel 2 locs

handles.locs_Ch2(:,handles.deltaXCol) = csaps(AvgCurveX(:,1),AvgCurveX(:,2),pX/smoothingFactor, handles.locs_Ch2(:,handles.frameCol));
handles.locs_Ch2(:,handles.deltaYCol) = csaps(AvgCurveY(:,1),AvgCurveY(:,2),pY/smoothingFactor, handles.locs_Ch2(:,handles.frameCol));

handles.locs_Ch2(1:startFrame,handles.deltaXCol) = 0;
handles.locs_Ch2(1:startFrame,handles.deltaYCol) = 0;

handles.locs_Ch2(:,handles.deltaXCol) = handles.locs_Ch2(:,handles.deltaXCol)-handles.locs_Ch2(startFrame,handles.deltaXCol); % deltaX
handles.locs_Ch2(:,handles.deltaYCol) = handles.locs_Ch2(:,handles.deltaYCol)-handles.locs_Ch2(startFrame,handles.deltaYCol); % deltaY

handles.locs_Ch2(:,handles.xCol) = handles.locs_Ch2(:,handles.xCol)-handles.locs_Ch2(:,handles.deltaXCol); % substract deltaX from X Col
handles.locs_Ch2(:,handles.yCol) = handles.locs_Ch2(:,handles.yCol)-handles.locs_Ch2(:,handles.deltaYCol); % substract deltaY from Y Col


subplot(2,3,3)
scatter(Avg_Ch2_new(:,1),Avg_Ch2_new(:,2)-Avg_Ch2_new(:,4),1,'b'), hold on;
axis([0 max(Avg_Ch2_new(:,1)) -radius radius])
axis square; box on
title('X trajectory after correction');

subplot(2,3,6)
scatter(Avg_Ch2_new(:,1),Avg_Ch2_new(:,3)-Avg_Ch2_new(:,5),1,'b'), hold on;
axis([0 max(Avg_Ch2_new(:,1)) -radius radius])
axis square; box on
title('Y trajectory after correction');

locs_Ch1    = handles.locs_Ch1;
Fid_Ch1     = handles.Fid_Ch1;
locs_Ch2    = handles.locs_Ch2;
Fid_Ch2     = handles.Fid_Ch2;

end