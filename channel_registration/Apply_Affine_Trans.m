% Load the file DL755 localization file 

clear, clc, close all

for i = 2; % loop for batch processing

IM_number = i;

Locpath1         = ['/test_data_for_MultiColorSPR/Dual_color_STORM_dataset/Cep152_DL755_' num2str(IM_number) '_1'];
locName1         = ['Cep152_DL755_' num2str(IM_number) '_1_MMStack_1_Localizations'];

cd(Locpath1);
locs_Ch1        = dlmread([locName1 '.csv'],',',1,0);

file            = fopen([locName1 '.csv']);
line            = fgetl(file);
header1         = regexp( line, ',', 'split' );

cd(''); % Insert path to the affine transformation
T1 = load('Global_LWMtrans.mat');

xCol            = strmatch('x [nm]',header1);
yCol            = strmatch('y [nm]',header1);
framesCol       = strmatch('frame',header1);
LLCol           = strmatch('loglikelihood',header1);
photonsCol      = strmatch('intensity [photon]',header1);
sigmaCol        = strmatch('sigma [nm]',header1);
uncertaintyCol  = strmatch('uncertainty [nm]',header1);

fprintf('\n -- Data Loaded --\n');

%% Apply LWM tranformation

moving = []; moving = locs_Ch1(:,xCol:yCol); corrected_moving = [];

corrected_moving = transformPointsInverse(T1.T_lwm,moving); % correct the 750 channel

%% Filter out of bound points

locs_corrected = locs_Ch1;
locs_corrected(:,xCol) = corrected_moving(:,1);
locs_corrected(:,yCol) = corrected_moving(:,2);

locs_corrected_filtered = [];
locs_corrected_filtered = locs_corrected(locs_corrected(:,xCol)<1e5,1:end);

Left_after_fitlering = length(locs_corrected_filtered)/length(corrected_moving)

fprintf('\n -- Data Corrected --\n');

%% Save the corrected file

cd(Locpath1);tic;

NameCorrected = [locName1 '_affineApplied.csv'];

fileID = fopen(NameCorrected,'w');
fprintf(fileID,[line ' \n']);
dlmwrite(NameCorrected,locs_corrected_filtered,'-append');
fclose('all');

fprintf('\n -- Data Saved in %f --\n',toc)

fprintf('\n -- Finished FOV %f --\n',num2str(i))

end
