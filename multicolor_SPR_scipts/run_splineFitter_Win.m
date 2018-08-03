%% Define input and output parameters

clear, clc, close all

input_folder       = 'E:\Shares\lebpc4-data12TB\to_analyze\2018-03-21_humanCent_Cep164_Cep152\Cep152_DL755\image_stacks\Cep152_DL755_4_1';
output_folder      = 'E:\Shares\lebpc4-data12TB\to_analyze\2018-03-21_humanCent_Cep164_Cep152\locResults\Spline';
calib_file         = 'T:\splineFitter\single_bead_3dcal_HTP_750nm.mat';
variance_map       = 'T:\splineFitter\prime_alice\varOffset.mat'; 
path_splineFit     = 'E:\Shares\lebpc4-data12TB\Christian\fit3Dcspline';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(output_folder);
mkdir('temp');
temp_output_folder = [output_folder '\temp'];

addpath(genpath(path_splineFit));

% For Miji on Win, run this before runnig starting miji
cd(path_splineFit);

javaaddpath '\ImageJ\ij.jar';
javaaddpath '\ImageJ\mij.jar';

myMiji(true,'ImageJ');

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

                          
save([input_folder '\var_map.mat'],'var_map');                          
                
fprintf('\n -- Variance map selected -- \n');                

%% Loop the fitting throught the folder
tic
for i = 1:size(image_files,1);
    
image_name  = image_files(i).name;
base        = regexp(image_name,'\.','split');

% input_file  = ['path=[' input_folder '\' image_name ']']; % if using normal stack import
input_file  = ['open=[' input_folder '\' image_name ']'];   % if using virtual stack import
output_file = [temp_output_folder '\' base{1} '_LocalizationsPC4.csv'];

image_files(i).output = output_file; % Save the output path

% MIJ.run('Open...', input_file); % Open tiff stack

MIJ.run('TIFF Virtual Stack...', input_file); % Open virtual tiff stack

% tic

p                   = {};
p.imagefile         = '';
p.calfile           = calib_file;
p.offset            = 163.65; % in ADU
p.conversion        = 0.48;    % e/ADU
p.previewframe      = false;
p.peakfilter        = 1.2;  % filter size (pixel)
p.peakcutoff        = 5;    % photons
p.roifit            = 15;   % ROI size (pixel)
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
p.scmosfile         = [input_folder '\var_map.mat'];
p.mirror            = false;

fprintf('\n -- Starting localization ...  \n'); 

simplefitter_cspline(p);

% fprintf(['\n -- Finished processing substack ' num2str(i) ' of ' num2str(size(image_files,1)) ' in ' num2str(toc/60) ' min -- \n']); 

MIJ.run('Close All');

end

toc
%% Combine files and save as single localization file

cd(temp_output_folder); all_locs = [];frames = [];

% Load Header

file      = fopen(image_files(1).output);
line      = fgetl(file);
h         = regexp( line, ',', 'split' );
frameCol  =  strmatch('frame',h);
fclose('all');

for i = 1:size(image_files,1);

    locs     = [];
    locs     = dlmread(image_files(i).output,',',1,0);
    all_locs = vertcat(all_locs,locs);
    
    if isempty(frames)==1;
    
        frames   = vertcat(frames,locs(:,frameCol));
    else
        
        frames   = vertcat(frames,locs(:,frameCol)+max(frames));
    
    end
    
    clc
    fprintf(['\n -- Processed locfile ' num2str(i) ' of ' num2str(size(image_files,1)) '-- \n']); 
    
end

all_locs(:,frameCol) = frames;

delete *.csv
new_name_temp   = regexp(base{1},'_','split');
new_name        = [new_name_temp{1,1} '_' new_name_temp{1,2} '_' new_name_temp{1,3} '_Localizations2.csv'];

cd(output_folder);

fileID = fopen(new_name,'w');
fprintf(fileID,[[line] ' \n']);
dlmwrite(new_name,all_locs,'-append');
fclose('all');
