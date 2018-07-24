
function [var_map_path,image_files,temp_output_folder] = initializeSpline(output_folder,input_folder,var_map);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(output_folder);

mkdir('temp');
temp_output_folder = [output_folder '\temp'];

% addpath(genpath(path_splineFit));
addpath(genpath('functions\fit3Dcspline\'));

% For Miji on Win, run this before runnig starting miji

% cd(path_splineFit);

% javaaddpath 'functions\fit3Dcspline\ImageJ\ij.jar';
% javaaddpath 'functions\fit3Dcspline\ImageJ\mij.jar';
% 
% myMiji(true,'ImageJ');

%% Index the input folder

cd(input_folder);

metadata_file = dir(sprintf('*metadata.txt'));

image_files = dir(sprintf('*ome.tif'));

fprintf('\n -- Indexed input folder -- \n');   

save('test.mat','image_files');

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

var_Alice    = var_map; 

var_map_ROI = [];
var_map_ROI = var_Alice(roi(1, 1):roi(1, 1)+roi(3, 1)-1,... 
                              roi(2, 1):roi(2, 1)+roi(4, 1)-1);

var_map_path = [input_folder '\var_map.mat'];
                          
save(var_map_path,'var_map_ROI');    
             
fprintf('\n -- Variance map selected -- \n');                

end

