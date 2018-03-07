%% Load the Fiducial tracks, their averaged curves and the affine transformation

clear, clc, close all

% Load the generated Affine Transformation

cd('/test_data_for_MultiColorSPR/Dual_color_STORM_dataset');
T1 = load(''); %filename

% Insert the path and file name information to load the Fiducial
% Trajectories

FOV = 2;

% Channel 1, A647

cd(['/test_data_for_MultiColorSPR/Dual_color_STORM_dataset/Sas6_A647_' num2str(FOV) '_1']);

fileID              = fopen(['Sas6_A647_' num2str(FOV) '_1_MMStack_1_Localizations_Fid.csv']);
line                = fgetl(fileID);
header1             = regexp( line, ',', 'split' );
Ch1                 = textscan(fileID,'%f %f %f %f %f %f %f %f %f %f %s','Delimiter',',','HeaderLines',1);
fclose('all');
locname_Ch1_Avg     = ['Sas6_A647_' num2str(FOV) '_1_MMStack_1_Localizations_Avg'];
Ch1_Avg             = dlmread([locname_Ch1_Avg '.csv'],',',1,0);


Fid_Ch1 = [];

for i = 1:length(Ch1)-1;

    Fid_Ch1(:,i) = Ch1{1,i};
end

% Channel 2, DL755

cd(['/test_data_for_MultiColorSPR/Dual_color_STORM_dataset/Cep152_DL755_' num2str(FOV) '_1']);

fileID              = fopen(['Cep152_DL755_' num2str(FOV) '_1_MMStack_1_Localizations_affineApplied_Fid.csv']);
line                = fgetl(fileID);
header              = regexp( line, ',', 'split' );
Ch2                 = textscan(fileID,'%f %f %f %f %f %f %f %f %f %f %s','Delimiter',',','HeaderLines',1);
fclose('all');
locname_Ch2_Avg     = ['Cep152_DL755_' num2str(FOV) '_1_MMStack_1_Localizations_affineApplied_Avg'];
Ch2_Avg             = dlmread([locname_Ch2_Avg '.csv'],',',1,0);

Fid_Ch2 = [];

for i = 1:length(Ch2)-1;

    Fid_Ch2(:,i) = Ch2{1,i};
    
end

xCol            = strmatch('x [nm]',header1);
yCol            = strmatch('y [nm]',header1);
framesCol       = strmatch('frame',header1);
LLCol           = strmatch('loglikelihood',header1);
photonsCol      = strmatch('intensity [photon]',header1);
sigmaCol        = strmatch('sigma [nm]',header1);
uncertaintyCol  = strmatch('uncertainty [nm]',header1);
RegionID        = strmatch('region_id',header1);

savepath = ('/Users/christian/Downloads/AllSupplement/17-12-22/submitted/');                            % Insert save path
savename = ['Sample_FOV_' num2str(FOV)];    % Insert save name

fprintf('\n -- Data Loaded --\n')

cd(savepath);

%% Correct the two fiducial tracks using the average curves

Fid_Ch1_corr = Fid_Ch1;

for i = 1:length(Fid_Ch1(:,framesCol));
   
    Fid_Ch1_corr(i,xCol) = Fid_Ch1(i,xCol) - Ch1_Avg(Ch1_Avg(:,1)==Fid_Ch1(i,framesCol),2);
    Fid_Ch1_corr(i,yCol) = Fid_Ch1(i,yCol) - Ch1_Avg(Ch1_Avg(:,1)==Fid_Ch1(i,framesCol),3);
    
end

Fid_Ch2_corr = Fid_Ch2;

for i = 1:length(Fid_Ch2(:,framesCol));
   
    Fid_Ch2_corr(i,xCol) = Fid_Ch2(i,xCol) - Ch2_Avg(Ch2_Avg(:,1)==Fid_Ch2(i,framesCol),2);
    Fid_Ch2_corr(i,yCol) = Fid_Ch2(i,yCol) - Ch2_Avg(Ch2_Avg(:,1)==Fid_Ch2(i,framesCol),3);
    
end

figure('Position',[100 100 700 700])
subplot(2,2,1)
scatter(Fid_Ch1(:,xCol),Fid_Ch1(:,yCol),10,'g','filled');hold on;
scatter(Fid_Ch1_corr(:,xCol),Fid_Ch1_corr(:,yCol),10,'r','filled');hold on;
box on;
title('Fiducials Ch1');

subplot(2,2,3)
scatter(Fid_Ch1(Fid_Ch1(:,RegionID)==min(Fid_Ch1_corr(:,RegionID)),framesCol),Fid_Ch1(Fid_Ch1(:,RegionID)==min(Fid_Ch1_corr(:,RegionID)),xCol)-mean(Fid_Ch1(Fid_Ch1(:,RegionID)==min(Fid_Ch1_corr(:,RegionID)),xCol)),5,'g','filled');hold on;
scatter(Fid_Ch1(Fid_Ch1(:,RegionID)==min(Fid_Ch1_corr(:,RegionID)),framesCol),Fid_Ch1(Fid_Ch1(:,RegionID)==min(Fid_Ch1_corr(:,RegionID)),yCol)-mean(Fid_Ch1(Fid_Ch1(:,RegionID)==min(Fid_Ch1_corr(:,RegionID)),yCol)),5,'r','filled');hold on;
box on;
legend('X','Y')
title('Trajectories before Corr');
axis([0 max(Fid_Ch1(:,framesCol)) -500 500 ])


subplot(2,2,2)
scatter(Fid_Ch2(:,xCol),Fid_Ch2(:,yCol),10,'g','filled');hold on;
scatter(Fid_Ch2_corr(:,xCol),Fid_Ch2_corr(:,yCol),10,'r','filled');hold on;
box on;
legend('Raw','Drift Corrected')
title('Fiducials Ch2');

subplot(2,2,4)
scatter(Fid_Ch1_corr(Fid_Ch1_corr(:,RegionID)==min(Fid_Ch1_corr(:,RegionID)),framesCol),Fid_Ch1_corr(Fid_Ch1_corr(:,RegionID)==min(Fid_Ch1_corr(:,RegionID)),xCol)-mean(Fid_Ch1_corr(Fid_Ch1_corr(:,RegionID)==min(Fid_Ch1_corr(:,RegionID)),xCol)),5,'g','filled');hold on;
scatter(Fid_Ch1_corr(Fid_Ch1_corr(:,RegionID)==min(Fid_Ch1_corr(:,RegionID)),framesCol),Fid_Ch1_corr(Fid_Ch1_corr(:,RegionID)==min(Fid_Ch1_corr(:,RegionID)),yCol)-mean(Fid_Ch1_corr(Fid_Ch1_corr(:,RegionID)==min(Fid_Ch1_corr(:,RegionID)),yCol)),5,'r','filled');hold on;
box on;
legend('X','Y')
title('Trajectories after Corr');
axis([0 max(Fid_Ch1(:,framesCol)) -200 200 ])

fprintf('\n -- Data Corrected --\n')

%% Plot the corrected fiducials

figure('Position',[400 400 900 300])
subplot(1,3,1);
scatter(Fid_Ch1_corr(:,xCol),Fid_Ch1_corr(:,yCol),10,'g','filled');hold on;
box on; axis equal;
title('Fiducials Ch1');

subplot(1,3,2);
scatter(Fid_Ch2_corr(:,xCol),Fid_Ch2_corr(:,yCol),10,'r','filled');
box on; axis equal;
title('Fiducials Ch2');

subplot(1,3,3);
scatter(Fid_Ch1_corr(:,xCol),Fid_Ch1_corr(:,yCol),10,'g','filled');hold on;
scatter(Fid_Ch2_corr(:,xCol),Fid_Ch2_corr(:,yCol),10,'r','filled');hold on;

for i = 0:max(Fid_Ch1_corr(:,RegionID));
    
text(sum(Fid_Ch1_corr(Fid_Ch1_corr(:,RegionID)==i,xCol))/length(Fid_Ch1_corr(Fid_Ch1_corr(:,RegionID)==i,xCol)), ...
     sum(Fid_Ch1_corr(Fid_Ch1_corr(:,RegionID)==i,yCol))/length(Fid_Ch1_corr(Fid_Ch1_corr(:,RegionID)==i,yCol)),num2str(i));
end


box on; axis equal;
title('2C Fiducials');

%% Correct the fiducial tracks using LWM transform

moving = []; moving = Fid_Ch2_corr(:,xCol:yCol); corrected_moving = [];
corrected_moving    = moving;             % correct the 750 channel


figure('Position',[100 400 700 300])
subplot(1,2,1);
scatter(Fid_Ch1_corr(:,xCol),Fid_Ch1_corr(:,yCol),10,'g','filled');hold on;
scatter(Fid_Ch2_corr(:,xCol),Fid_Ch2_corr(:,yCol),10,'r','filled');
box on; axis equal;
title('Before Correction');

subplot(1,2,2);
scatter(Fid_Ch1_corr(:,xCol),Fid_Ch1_corr(:,yCol),10,'g','filled');hold on;
scatter(corrected_moving(corrected_moving(:,1)<1e6,1),corrected_moving(corrected_moving(:,2)<1e6,2),10,'r','filled');
box on; axis equal;
title('After LWM Correction');

Fid_Ch2_corr_subset = Fid_Ch2_corr;
Fid_Ch2_corr_subset(:,xCol) = corrected_moving(:,1);
Fid_Ch2_corr_subset(:,yCol) = corrected_moving(:,2);

Fid_Ch2_corr_subset = Fid_Ch2_corr_subset(and(Fid_Ch2_corr_subset(:,xCol)<1e6,Fid_Ch2_corr_subset(:,yCol)<1e6),1:end);
Fid_Ch2_corr = Fid_Ch2_corr_subset;

% This part only if not all fiducials are to be used

% Fid_Ch2_corr_subset = [];
% Fid_Ch2_corr_subset = Fid_Ch2_corr(or(Fid_Ch2_corr(:,RegionID)==0,Fid_Ch2_corr(:,RegionID)==0),1:end);
% 
% Fid_Ch2_corr = Fid_Ch2_corr_subset;
% 
% Fid_Ch1_corr_subset = [];
% Fid_Ch1_corr_subset = Fid_Ch1_corr(or(Fid_Ch1_corr(:,RegionID)==0,Fid_Ch1_corr(:,RegionID)==0),1:end);
% Fid_Ch1_corr = Fid_Ch1_corr_subset;


fprintf('\n -- Applied LWM on Fiducials --\n')

%% Find CoM

close all;

center_Ch1 = [];center_Ch2 = [];


for i = 0:max(Fid_Ch1_corr(:,RegionID));
    
    center_Ch1(i+1,1) = sum(Fid_Ch1_corr(Fid_Ch1_corr(:,RegionID)==i,xCol))/length(Fid_Ch1_corr(Fid_Ch1_corr(:,RegionID)==i,xCol));
    center_Ch1(i+1,2) = sum(Fid_Ch1_corr(Fid_Ch1_corr(:,RegionID)==i,yCol))/length(Fid_Ch1_corr(Fid_Ch1_corr(:,RegionID)==i,yCol));
    
end

for i = 0:max(Fid_Ch2_corr(:,RegionID));
    
    center_Ch2(i+1,1) = sum(Fid_Ch2_corr(Fid_Ch2_corr(:,RegionID)==i,xCol))/length(Fid_Ch2_corr(Fid_Ch2_corr(:,RegionID)==i,xCol));
    center_Ch2(i+1,2) = sum(Fid_Ch2_corr(Fid_Ch2_corr(:,RegionID)==i,yCol))/length(Fid_Ch2_corr(Fid_Ch2_corr(:,RegionID)==i,yCol));
    
end

% Delete NaNs

center_Ch1_noNan = [];
center_Ch2_noNan = [];

for i = 1:size(center_Ch1,1);
    
    if isnan(center_Ch1(i,1))==1;
        
    else
    center_Ch1_noNan(i,1) = center_Ch1(i,1);
    center_Ch1_noNan(i,2) = center_Ch1(i,2);

    end
    
end

center_Ch1 = [];
center_Ch1(:,1) = nonzeros(center_Ch1_noNan(:,1));
center_Ch1(:,2) = nonzeros(center_Ch1_noNan(:,2));


for i = 1:size(center_Ch2,1);
    
    if isnan(center_Ch2(i,1))==1;
        
    else
    center_Ch2_noNan(i,1) = center_Ch2(i,1);
    center_Ch2_noNan(i,2) = center_Ch2(i,2);

    end
    
end

center_Ch2 = [];
center_Ch2(:,1) = nonzeros(center_Ch2_noNan(:,1));
center_Ch2(:,2) = nonzeros(center_Ch2_noNan(:,2));

figure
scatter(Fid_Ch1(:,xCol),Fid_Ch1(:,yCol),10,'g','filled');hold on;
scatter(Fid_Ch2_corr(:,xCol),Fid_Ch2_corr(:,yCol),10,'r','filled');
scatter(center_Ch1(:,1),center_Ch1(:,2),20,'b');hold on;
scatter(center_Ch2(:,1),center_Ch2(:,2),20,'b');hold on;
box on; axis equal;
title('Indentified Fiducial Centers');

fprintf('\n -- CoM identified --\n')


%% Extract and Save linear Transformation

deltaXY = [];

for i = 1:size(center_Ch1,1);
    
    deltaXY(i,1) = center_Ch1(i,1) - center_Ch2(i,1);
    deltaXY(i,2) = center_Ch1(i,2) - center_Ch2(i,2);
    
end

cd(savepath);
save(savename,'deltaXY');

center_Ch2_corr = [];
center_Ch2_corr(:,1) = center_Ch2(:,1) + mean(deltaXY(:,1));
center_Ch2_corr(:,2) = center_Ch2(:,2) + mean(deltaXY(:,2));

TRE = [];
for i = 1:size(center_Ch1,1);
    
TRE(:,i) = sqrt((center_Ch1(i,1)-center_Ch2_corr(i,1))^2 + (center_Ch1(i,2)-center_Ch2_corr(i,2))^2);

end

figure
scatter(center_Ch1(:,1),center_Ch1(:,2),10,'g','filled');hold on;
scatter(center_Ch2(:,1) + mean(deltaXY(:,1)),center_Ch2(:,2) + mean(deltaXY(:,2)),10,'r','filled');  
box on; axis equal;
title(['Fid After 2nd trans TRE = ', num2str(mean(TRE))]);

fprintf('\n -- Linear Transformation extracted and saved --\n')

%% Apply the Rigid translation on the full fiducial dataset

corrected_moving_X = [];
corrected_moving_Y = [];
corrected_moving_X = Fid_Ch2_corr(:,xCol) + mean(deltaXY(:,1));
corrected_moving_Y = Fid_Ch2_corr(:,yCol) + mean(deltaXY(:,2));


figure('Position',[500 500 700 300])
subplot(1,2,1);
scatter(Fid_Ch1_corr(:,xCol),Fid_Ch1_corr(:,yCol),10,'g','filled');hold on;
scatter(Fid_Ch2_corr(:,xCol),Fid_Ch2_corr(:,yCol),10,'r','filled');
box on; axis equal;
title(['Fid After 1st']);

subplot(1,2,2);
scatter(Fid_Ch1_corr(:,xCol),Fid_Ch1_corr(:,yCol),10,'g','filled');hold on;
scatter(corrected_moving_X,corrected_moving_Y,10,'r','filled');
box on; axis equal;
title(['Fid After 2nd trans TRE = ', num2str(mean(TRE))]);

fprintf('\n -- Dataset corrected --\n');

