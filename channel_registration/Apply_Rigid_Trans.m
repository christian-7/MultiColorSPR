%% Load loc file that need to be corrected

% Step 2 of the channel regsitration protocol
% script corrects localization data using a linear transformation

% long WL channel, 750 nm

clear, clc, close all, tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for FOV = 2; % loop for batch processing

locpath     = ['/test_data_for_MultiColorSPR/Dual_color_STORM_dataset/Cep152_DL755_' num2str(FOV) '_1'];
locname     = ['Cep152_DL755_' num2str(FOV) '_1_MMStack_1_Localizations_affineApplied_DC'];

cd(''); % Insert path to the rigid translation
T2 =  load(['Name_of_rigid_translation' num2str(FOV) '.mat']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(locpath);
locs        = dlmread([locname '.csv'],',',1,0);

file = fopen([locname '.csv']);
line = fgetl(file);
header1 = regexp( line, ',', 'split' );

xCol            = strmatch('x [nm]',header1);
yCol            = strmatch('y [nm]',header1);
framesCol       = strmatch('frame',header1);
LLCol           = strmatch('loglikelihood',header1);
photonsCol      = strmatch('intensity [photon]',header1);
sigmaCol        = strmatch('sigma [nm]',header1);
uncertaintyCol  = strmatch('uncertainty [nm]',header1);

fprintf('\n -- Data Loaded --\n');

%% Load and Apply the LWM transformation

% Apply LWM tranformation

corrected_moving = locs(:,xCol:yCol);

% Apply the Rigid translation

corrected_moving_X = [];
corrected_moving_Y = [];
corrected_moving_X = corrected_moving(:,1) + mean(T2.deltaXY(:,1));
corrected_moving_Y = corrected_moving(:,2) + mean(T2.deltaXY(:,2));

locs_corrected = locs;
locs_corrected(:,xCol) = corrected_moving_X;
locs_corrected(:,yCol) = corrected_moving_Y;

fprintf('\n -- Dataset corrected --\n');

%% Filter out of bound points

locs_corrected_filtered = [];
locs_corrected_filtered = locs_corrected(locs_corrected(:,xCol)<1e5,1:end);

Left_after_fitlering = length(locs_corrected_filtered)/length(locs_corrected)


%% Save the corrected file

cd(locpath);tic;

NameCorrected = [locname '_corrected.csv'];

fileID = fopen(NameCorrected,'w');
fprintf(fileID,[line ' \n']);
dlmwrite(NameCorrected,locs_corrected_filtered,'-append');
fclose('all');

fprintf('\n -- Data Saved in %f --\n',toc)

end

