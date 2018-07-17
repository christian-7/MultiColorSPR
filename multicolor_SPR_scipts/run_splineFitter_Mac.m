%% Define input and output folder

clear, clc, close all

input_folder    = '/Volumes/lebpc4-data12TB/to_analyze/2018-06-05_DNA_Origami/Cy5/image_stacks/Cy5_1_1';
loc_folder      = '/Volumes/lebpc4-data12TB/to_analyze/2018-06-05_DNA_Origami/locResults';
variance_map    = '/Volumes/sieben/splineFitter/prime_alice/varOffset.mat'; 

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

%% Create input variable for simple_fitter

addpath('fit3Dcspline/shared');
addpath('fit3Dcspline/bfmatlab');

% For Miji on Mac, run this before runnig starting miji

% javaaddpath '/Applications/MATLAB_R2016b.app/java/mij.jar';
% javaaddpath '/Applications/MATLAB_R2016b.app/java/mij.jar';
% addpath('/Applications/Fiji.app/scripts');

Miji;

myMiji(true,'ImageJ');

%% Loop the fitting throught the folder

for i = 1:size(image_files,1);
    
image_name  = image_files(i).name;
base        = regexp(image_name,'\.','split');

input_file  = ['path=[' input_folder image_name ']'];
output_file = [loc_folder '/' base{1} '_Localizations.csv'];

MIJ.run('Open...', input_file);
            
p                   = {};
p.imagefile         = '';
p.calfile           = '';
p.offset            = 100; %in ADU
p.conversion        = 0.1; % e/ADU
p.previewframe      = false;
p.peakfilter        = 1.2;  % filter size (pixel)
p.peakcutoff        = 5;    % photons
p.roifit            = 13;   % ROI size (pixel)
p.bidirectional     = true; % 2D
p.mirror            = false;
p.status            = '';
p.outputfile        = output_file;
p.outputformat      = 'csv';
p.pixelsize         = 106;
p.loader            = 3; % {'simple tif','ome loader','ImageJ'}
p.mij               = MIJ;
p.backgroundmode    = 'Difference of Gaussians (fast)';
p.preview           = false;
p.isscmos           = false;
p.scmosfile         = '';
p.mirror            = false;
            
% simplefitter_cspline(p)
                
end