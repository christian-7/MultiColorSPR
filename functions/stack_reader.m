javaaddpath '/Applications/MATLAB_R2016b.app/java/mij.jar';
javaaddpath '/Applications/MATLAB_R2016b.app/java/mij.jar';
addpath('/Applications/Fiji.app/scripts');

Miji;

%% Read Stack 

% Read stack length

file_path = '/Users/christian/Desktop/single_bead.tif';

fname = file_path;
info  = imfinfo(fname);

NbrFrames = size(info,1);

frame_matrix = [1,round(NbrFrames/2);round(NbrFrames/2)+1,size(info,1)];

% Load Substack one at a time

for i = 1:size(frame_matrix,1);
    
range = ['z_begin=' num2str(frame_matrix(i,1)) ' z_end=' num2str(frame_matrix(i,2))];

MIJ.run('Bio-Formats Importer', ['open=' file_path 'color_mode=Default rois_import=[ROI manager] specify_range view=[Standard ImageJ] stack_order=Default' range 'z_step=1']);

end