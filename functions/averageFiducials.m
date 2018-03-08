function [Avg_Ch1_new, Avg_Ch2_new] = averageFiducials(selectedFid, handles);

% Select the fiducials and Normalize them to their center of mass

% selectedFid = [1,2,4];

Avg_Ch1x = []; Avg_Ch1y = []; Avg_Ch1 = []; Avg_Ch1frame = [];Avg_Ch1ID = [];

for i = selectedFid;
    
    target  = find(handles.Fid_Ch1(:,handles.RegionID)==i & handles.Fid_Ch1(:,handles.frameCol)<1000);
    offsetX = median(handles.Fid_Ch1(target,handles.xCol)); offsetY = median(handles.Fid_Ch1(target,handles.yCol)); % median of the first 1000 frames 
    
    Avg_Ch1x        = vertcat(Avg_Ch1x,handles.Fid_Ch1(handles.Fid_Ch1(:,handles.RegionID)==i,handles.xCol)-offsetX);
    Avg_Ch1y        = vertcat(Avg_Ch1y,handles.Fid_Ch1(handles.Fid_Ch1(:,handles.RegionID)==i,handles.yCol)-offsetY);
    Avg_Ch1frame    = vertcat(Avg_Ch1frame,handles.Fid_Ch1(handles.Fid_Ch1(:,handles.RegionID)==i,handles.frameCol));
    Avg_Ch1ID       = vertcat(Avg_Ch1ID,handles.Fid_Ch1(handles.Fid_Ch1(:,handles.RegionID)==i,handles.RegionID)); % Region ID
    
end

Avg_Ch1      = Avg_Ch1x;
Avg_Ch1(:,2) = Avg_Ch1y;
Avg_Ch1(:,3) = Avg_Ch1frame;
Avg_Ch1(:,4) = Avg_Ch1ID; % Region ID

clear Avg_Ch1x Avg_Ch1y Avg_Ch1frame Avg_Ch1ID


Avg_Ch2x = []; Avg_Ch2y = []; Avg_Ch2 = []; Avg_Ch2frame = [];Avg_Ch2ID = [];

for i = selectedFid;
    
    target = find(handles.Fid_Ch2(:,handles.RegionID)==i & handles.Fid_Ch2(:,handles.frameCol)<1000);
    offsetX = median(handles.Fid_Ch2(target,handles.xCol)); offsetY = median(handles.Fid_Ch2(target,handles.yCol));
    
    Avg_Ch2x        = vertcat(Avg_Ch2x,handles.Fid_Ch2(handles.Fid_Ch2(:,handles.RegionID)==i,handles.xCol)-offsetX);
    Avg_Ch2y        = vertcat(Avg_Ch2y,handles.Fid_Ch2(handles.Fid_Ch2(:,handles.RegionID)==i,handles.yCol)-offsetY);
    Avg_Ch2frame    = vertcat(Avg_Ch2frame,handles.Fid_Ch2(handles.Fid_Ch2(:,handles.RegionID)==i,handles.frameCol));
    Avg_Ch2ID       = vertcat(Avg_Ch2ID,handles.Fid_Ch2(handles.Fid_Ch2(:,handles.RegionID)==i,handles.RegionID)); % Region ID
    
end

Avg_Ch2      = Avg_Ch2x;
Avg_Ch2(:,2) = Avg_Ch2y;
Avg_Ch2(:,3) = Avg_Ch2frame;
Avg_Ch2(:,4) = Avg_Ch2ID; % Region ID

clear Avg_Ch2x Avg_Ch2y Avg_Ch2frame Avg_Ch2ID

%% Average the fiducial tracks 

% Channel 1

Avg_Ch1_new = []; count = 1;

for i = min(Avg_Ch1(:,handles.frameCol)):max(Avg_Ch1(:,handles.frameCol));      % For all frames

   target = find(Avg_Ch1(:,handles.frameCol) == i);                     % find all fiducials in frame i
   
   if isempty(target);
   else    
   
   Avg_Ch1_new(i,1) = i; % frame
   Avg_Ch1_new(i,2) = mean(Avg_Ch1(target,handles.xCol));               % mean x of all fiducials in frame i
   Avg_Ch1_new(i,3) = mean(Avg_Ch1(target,handles.yCol));               % mean x of all fiducials in frame i
   
   cont = count +1;
   end
   
end

Avg_Ch1_new(1:min(Avg_Ch1(:,handles.frameCol))-1,:) = [];

% Channel 2

Avg_Ch2_new = []; count = 1;

for i = min(Avg_Ch2(:,handles.frameCol)):max(Avg_Ch2(:,handles.frameCol));      % For all frames

   target = find(Avg_Ch2(:,handles.frameCol) == i);                     % find all fiducials in frame i
   
   if isempty(target);
   else    
   
   Avg_Ch2_new(i,1) = i; % frame
   Avg_Ch2_new(i,2) = mean(Avg_Ch2(target,handles.xCol));               % mean x of all fiducials in frame i
   Avg_Ch2_new(i,3) = mean(Avg_Ch2(target,handles.yCol));               % mean x of all fiducials in frame i
   
   cont = count +1;
   end
   
end

Avg_Ch2_new(1:min(Avg_Ch2(:,handles.frameCol))-1,:) = [];

% Plotting

figure('Position', [200 200 400 500])

subplot(2,1,1)
% axes(handles.axesCh1_1); cla reset;
scatter(Avg_Ch1(:,3),Avg_Ch1(:,1),1,'g'); hold on;
scatter(Avg_Ch1(:,3),Avg_Ch1(:,2),1,'r'); hold on;
box on;legend('Normalized X drift', 'Normalized Y Drift');
xlabel('frames'); ylabel('nm');

subplot(2,1,1)
% axes(handles.axesCh1_2); cla reset;
scatter(Avg_Ch1_new(:,1),Avg_Ch1_new(:,2),1,'g'); hold on;
scatter(Avg_Ch1_new(:,1),Avg_Ch1_new(:,3),1,'r'); hold on;
box on;legend('Averaged X drift', 'Averaged Y Drift');
xlabel('frames'); ylabel('nm');

figure('Position', [200 200 400 500])
subplot(2,1,1)
% axes(handles.axesCh2_1); cla reset;
scatter(Avg_Ch2(:,3),Avg_Ch2(:,1),1,'g'); hold on;
scatter(Avg_Ch2(:,3),Avg_Ch2(:,2),1,'r'); hold on;
box on;legend('Normalized X drift', 'Normalized Y Drift');
xlabel('frames'); ylabel('nm');

subplot(2,1,1)
% axes(handles.axesCh2_2); cla reset;
scatter(Avg_Ch2_new(:,1),Avg_Ch2_new(:,2),1,'g'); hold on;
scatter(Avg_Ch2_new(:,1),Avg_Ch2_new(:,3),1,'r'); hold on;
box on;legend('AveragedX drift', 'AveragedY Drift');
xlabel('frames'); ylabel('nm');
