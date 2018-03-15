function [NewName] = generateFilename(FOV);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Example:

% locName = base_sample_channel_FOV_MM-standard-filename.csv
% WFpath  = /Sample_Channel_WFFOV/
% WFname  = Sample_Channel_WFFOV_MM-standard-filename.ome.tif

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input

path     = '/Users/christian/Documents/Arbeit/MatLab/SPARTAN_gui/example_data' 
filename = 'humanCent_Cep57_DL755_4_1_MMStack_1_Localizations.csv'
savepath = '/Users/christian/Documents/Arbeit/MatLab/SPARTAN_gui/example_data'

Channel  = {'A647','DL755'}; % channel names;
Sample   = {'Sas6','Cep152'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find column names

cd(path);

file       = fopen(filename);
line       = fgetl(file);
h          = regexp( line, ',', 'split' );

xCol       = strmatch('x [nm]',h);
yCol       = strmatch('y [nm]',h);

% Find name composition and separate them

h           = regexp(filename, '_', 'split' );

PosFOV      = 4; % point to the running number
PosDye      = 3; % point to the channel
PosSample   = 2; % point to the channel
NewName     = {};

for j = 1:length(Channel);
    
    line        = h{1,1};

for i = 2:length(h);
    
    if i == PosSample;
        
    line = [line, '_', Sample{1,j}];
    
    elseif i == PosDye;
        
    line = [line, '_', Channel{1,j}];

    elseif i == PosFOV;
        
    line = [line, '_', num2str(FOV)];
    
    else

    line = [line, '_', h{1,i}];
    
    end
    
end
    NewName{j,1} = path; % locPath
    NewName{j,2} = line; % locName
    
    NewName{j,3} = [Sample{1,j},'_', Channel{1,j},'_', 'WF', num2str(FOV)]; % WFpath
    NewName{j,4} = [Sample{1,j},'_', Channel{1,j},'_', 'WF', num2str(FOV) '_MMStack_Pos0.ome.tif']; % WFname
    
end
