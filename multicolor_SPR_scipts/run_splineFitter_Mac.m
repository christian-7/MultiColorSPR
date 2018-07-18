%% Define input and output folder

clear, clc, close all

input_folder    = '/Volumes/lebpc4-data12TB/to_analyze/2018-06-05_DNA_Origami/Cy5/image_stacks/Cy5_1_1';
output_folder   = '/Volumes/lebpc4-data12TB/to_analyze/2018-06-05_DNA_Origami/locResults';
variance_map    = '/Volumes/sieben/splineFitter/prime_alice/varOffset.mat'; 
calib_file      = '/Volumes/sieben/splineFitter/single_bead_3dcal_HTP_647nm.mat'
path_splineFit  = '/Volumes/sieben/splineFitter/fit3Dcspline';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath(path_splineFit));

% For Miji on Mac, run this before runnig starting miji

javaaddpath '/Applications/MATLAB_R2016b.app/java/mij.jar';
javaaddpath '/Applications/MATLAB_R2016b.app/java/mij.jar';
addpath('/Applications/Fiji.app/scripts');

Miji;

%% Index the input folder

cd(input_folder);

metadata_file = dir(sprintf('*metadata.txt'));

image_files = dir(sprintf('*ome.tif'));

fprintf('\n -- Indexed input folder -- \n');   

%% For sCMOS cameras, load respective variance map and select ROI

% Open metadata and extract the ROI coordinates

fid = fopen(metadata_file.name, 'rt');
s   = textscan(fid, '%s',100, 'delimiter', '\n'); % load only the first 100 lines
fid = fclose(fid);

fprintf('\n -- Metadata file loaded -- \n');   

row = strfind(s{1}, '"ROI":'); roi = {};

for i = 1:length(s{1,1});
    
    if row{i,1} == 1;
    roi = s{1,1}(i+1,1);
    end
    
end

% temp    = regexp(roi,'\"','split');
% roi     = regexp(temp{1,1}{1,4},',','split');

% MM2 beta

temp1       = regexp(roi,'\"','split');
temp2       = regexp(temp1{1,1}{1,4},',','split');
temp3       = regexp(temp2{1,1},'[','split');
temp4       = regexp(temp2{1,4},']','split');

roi = [];
roi(1,1) = str2num(temp3{1,2});
roi(2,1) = str2num(temp2{1,2});
roi(3,1) = str2num(temp2{1,3});
roi(4,1) = str2num(temp4{1,1});


% Extract ROI from camera variance map
% ROI format (x,y,widht,height) --> XY of upper left corner

var_Alice    = load(variance_map); 

var_map = [];
var_map = var_Alice.varOffset(roi(1, 1):roi(1, 1)+roi(3, 1)-1,... 
                              roi(2, 1):roi(2, 1)+roi(4, 1)-1);
                          
% save('var_map.mat','var_map');                          
                
fprintf('\n -- Variance map selected -- \n');  

%% Loop fitting through the folder

for i = 1:size(image_files,1); % For all image files in folder
    
image_name   = image_files(i).name;
base         = regexp(image_name,'\.','split');

input_file   = ['path=[' input_folder image_name ']'];

info         = imfinfo([input_folder image_name]); % Read stack length
NbrFrames    = size(info,1);
frame_matrix = [1,round(NbrFrames/2);round(NbrFrames/2)+1,size(info,1)]; % Generate Matrix of substacks

% Load Substacks and localize 

for j = 1:size(frame_matrix,1);
    
range = ['z_begin=' num2str(frame_matrix(j,1)) ' z_end=' num2str(frame_matrix(j,2))];

output_file  = [output_folder '/' base{1} '_Localizations_' num2str(j) '.csv'];

MIJ.run('Bio-Formats Importer', ['open=' file_path 'color_mode=Default rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order=Default' range 'z_step=1']);

%%%%
% 
% MIJ.run('Open...', input_file);
            
p                   = {};
p.imagefile         = '';
p.calfile           = calib_file;
p.offset            = 100; %in ADU
p.conversion        = 0.1; % e/ADU
p.previewframe      = false;
p.peakfilter        = 1.2;  % filter size (pixel)
p.peakcutoff        = 5;    % photons
p.roifit            = 13;   % ROI size (pixel)
p.bidirectional     = false; % 2D
p.mirror            = false;
p.status            = '';
p.outputfile        = output_file;
p.outputformat      = 'csv';
p.pixelsize         = 106;
p.loader            = 3; % {'simple tif','ome loader','ImageJ'}
p.mij               = MIJ;
p.backgroundmode    = 'Difference of Gaussians (fast)';
p.preview           = false;
p.isscmos           = true;
p.scmosfile         = [input_folder '\var_map.mat'];;
p.mirror            = false;
            
% simplefitter_cspline(p)

end
                
end