% MultiColorSPR/channel_registration/Calculate_AffineT_from_Beads.m

%% Channel registration using Crocker & Grier particle detection
% 
% Ref: http://site.physics.georgetown.edu/matlab/tutorial.html
% 
% Steps:
%         1. Load both bead images
%         2. apply bandpass filter
%         3. find peaks positions
%         4. calculate LWM transformation
%         5. save LWM transformation
%         6. generate quiver plot

%% Load Data

close all, clear, clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load image Channel 1, 642 nm

% cd('/test_data_for_MultiColorSPR/Channel_registration/Ch642_1');
imCh1 = imread('Ch1.tif');

% Load image Channel 2, 750 nm

% cd('/test_data_for_MultiColorSPR/Channel_registration/Ch750_1');
imCh2 = imread('Ch2.tif');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Position',[100 300 1200 500])
subplot(1,2,1)
imshow(imadjust(imCh1));title('Beads Ch1, 642 nm');
subplot(1,2,2)
imshow(imadjust(imCh2));title('Beads Ch2, 750 nm');

%% Apply Bandpass filter

% smooths the image and subtracts the background off

imBpassCh1 = bpass(imCh1,1,4);  % fist number = 1; second = diameter
imBpassCh2 = bpass(imCh2,1,5);

figure('Position',[100 300 900 300])
subplot(1,2,1)
imshow(imadjust(imBpassCh1));title('Beads Ch1, 642 nm');
subplot(1,2,2)
imshow(imadjust(imBpassCh2));title('Beads Ch2, 750 nm');

%% Localize the beads

close all;

%  Estimate peak position

pkCh1 = pkfnd(imBpassCh1,1e2,3);   % brigthness threshold, diameter
pkCh2 = pkfnd(imBpassCh2,0.1e3,3); % brigthness threshold, diameter

figure('Position',[100 500 600 500])
scatter(pkCh1(:,1),pkCh1(:,2),10,'ro');box on; axis square; axis([0 size(imCh1,1) 0 size(imCh1,2)]);hold on;
scatter(pkCh2(:,1),pkCh2(:,2),10,'g*');box on; axis square; axis([0 size(imCh1,1) 0 size(imCh1,2)]);hold on;
legend('Ch1','Ch2');
title('Peak position estimate')

cntCh1 = cntrd(imBpassCh1,pkCh1,5); % image, position estimate, diameter of the window
cntCh2 = cntrd(imBpassCh2,pkCh2,5);

figure('Position',[800 500 600 500])
scatter(cntCh1(:,1),cntCh1(:,2),10,'ro');box on; axis square; axis([0 size(imCh1,1) 0 size(imCh1,2)]);hold on;
scatter(cntCh2(:,1),cntCh2(:,2),10,'g*');box on; axis square; axis([0 size(imCh1,1) 0 size(imCh1,2)]);
legend('Ch1','Ch2');
title('Subpixel centroid')

% Filter the beads

filterBrightness        = 3.5e5;
filterRg_min            = 3.0;
filterRg_max            = 3.8;

filter_Ch1 = find(cntCh1(:,3) <  filterBrightness & cntCh1(:,4) <  filterRg_max & cntCh1(:,4) >  filterRg_min);

filterBrightness        = 1.5e5;
filterRg_min            = 3.5;
filterRg_max            = 3.9;

filter_Ch2 = find(cntCh2(:,3) <  filterBrightness & cntCh2(:,4) <  filterRg_max & cntCh2(:,4) >  filterRg_min);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Include a manual coarse shift on channel 2

% cntCh2(:,1) = cntCh2(:,1) + 20;
% cntCh2(:,2) = cntCh2(:,2) - 25;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
imshow(imadjust(imCh1));hold on;
scatter(cntCh1(filter_Ch1,1),cntCh1(filter_Ch1,2),10,'r*');
title('Overlay Channel 1, 642 nm')

figure
imshow(imadjust(imCh2));hold on;
scatter(cntCh2(filter_Ch2,1),cntCh2(filter_Ch2,2),10,'r*');
title('Overlay Channel 2, 750 nm')

figure('Position',[100 300 600 500])
scatter(cntCh1(filter_Ch1,1),cntCh1(filter_Ch1,2),10,'ro');box on; axis square; hold on;
scatter(cntCh2(filter_Ch2,1),cntCh2(filter_Ch2,2),10,'g*');box on; axis square; hold on;
legend('Ch1','Ch2');
title('Peak position estimate')

% Output:
%           out(:,1) is the x-coordinates
%           out(:,2) is the y-coordinates
%           out(:,3) is the brightnesses
%           out(:,4) is the sqare of the radius of gyration

%% Calculate LWM transformation

close all;

pxlsize      = 106;
searchRadius = 2; % pxl

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find the bead pairs  %%%%%%%%%%%%%%%%%%%

fixed  = cntCh1(filter_Ch1,1:2); % 106 nm / pxl
moving = cntCh2(filter_Ch2,1:2); % 106 nm / pxl

moving_1 = []; fixed_1 = [];

[IDX] = rangesearch(moving,fixed,searchRadius); % find the point in moving that is closest to the point in fixed

for i = 1:length(IDX);
    
    if isempty(IDX{i,1}) == 1;
       
       fixed_1(i,1) = 0;
       fixed_1(i,2) = 0;
    
    elseif length(IDX{i,1}) > 1;
            
       fixed_1(i,1) = 0;
       fixed_1(i,2) = 0;
       
    else

    moving_1(i,1) = moving(IDX{i,1}(:,1),1);
    moving_1(i,2) = moving(IDX{i,1}(:,1),2);
    
    fixed_1(i,1) = fixed(i,1);
    fixed_1(i,2) = fixed(i,2);
    end
    
end

moving = [];
moving(:,1) = nonzeros(moving_1(:,1));
moving(:,2) = nonzeros(moving_1(:,2));

fixed = [];
fixed(:,1) = nonzeros(fixed_1(:,1));
fixed(:,2) = nonzeros(fixed_1(:,2));

%%%%

moving_1 = []; fixed_1 = [];

[IDX] = rangesearch(fixed,moving,searchRadius); % find the point in moving that is closest to the point in fixed

for i = 1:length(IDX);
    
    if isempty(IDX{i,1}) == 1;
       
       moving_1(i,1) = 0;
       moving_1(i,2) = 0;
    
    elseif length(IDX{i,1}) > 1;
            
       moving_1(i,1) = 0;
       moving_1(i,2) = 0;
       
    else

    fixed_1(i,1) = fixed(IDX{i,1}(:,1),1);
    fixed_1(i,2) = fixed(IDX{i,1}(:,1),2);
    
    moving_1(i,1) = moving(i,1);
    moving_1(i,2) = moving(i,2);
    end
    
end

moving = [];
moving(:,1) = nonzeros(moving_1(:,1))*pxlsize;
moving(:,2) = nonzeros(moving_1(:,2))*pxlsize;

fixed = [];
fixed(:,1) = nonzeros(fixed_1(:,1))*pxlsize;
fixed(:,2) = nonzeros(fixed_1(:,2))*pxlsize;

MBD = [];
for i = 1:length(fixed);
    
    MBD(:,i) = sqrt((fixed(i,1)-moving(i,1))^2 + (fixed(i,2)-moving(i,2))^2);

end

figure('Position',[200 100 500 500])
scatter(moving(:,1),moving(:,2),'ro');hold on;
scatter(fixed(:,1),fixed(:,2),'g*');hold on;
box on;axis equal;
legend('Ch1','Ch2')
title(['Mean Bead distance = ' num2str(mean(MBD)) ' nm']);
xlabel('nm');
ylabel('nm');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculate the transformation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T_lwm = fitgeotrans(fixed,moving,'lwm',10);

% T_lwm_old = cp2tform(fixed,moving,'lwm',10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Tranform the Points and calculate TRE  %%%%%%%%%%%%%%%%%%%

corrected_moving = transformPointsInverse(T_lwm,moving); % correct the 750 channel

% corrected_moving = tforminv(T_lwm_old,moving(:,1),moving(:,2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


TRE = [];
for i = 1:length(fixed);
    
    TRE(:,i) = sqrt((fixed(i,1)-corrected_moving(i,1))^2 + (fixed(i,2)-corrected_moving(i,2))^2);

end

figure('Position',[200 300 500 500])
scatter(fixed(:,1),fixed(:,2),'gx');hold on;
scatter(moving(:,1),moving(:,2),'ro');hold on;
scatter(corrected_moving(:,1),corrected_moving(:,2),'rx');hold on;
legend('Ch1','Ch2','Ch2 corr')
title(['TRE = ' num2str(mean(TRE)) ' nm']);
box on; axis equal;
xlabel('nm');
ylabel('nm');

figure('Position',[700 300 700 500])
scatter(fixed(:,1),fixed(:,2),30,transpose(TRE),'filled');hold on;
box on; axis equal;
colorbar
title('Color --> TRE');
xlabel('nm');
ylabel('nm');

%% Save the transformation

cd(''); % Enter save path
save('Global_LWMtrans','T_lwm'); % Enter save name
