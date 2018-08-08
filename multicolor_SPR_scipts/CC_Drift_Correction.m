clear, clc, close all

path     = '/Volumes/sieben/splineFitter/test_data';
filename = '2016-12-09_Cos7_aTub_PAINT_FOV_2_MMStack_Pos0_locResults.csv';
pixelsize 	= 106;

cd(path)
locs = dlmread(filename, ',',1,0);

file = fopen(filename);
line = fgetl(file);
header1 = regexp( line, ',', 'split' );

xCol            = strmatch('"x [nm]"',header1);
yCol            = strmatch('"y [nm]"',header1);
framesCol       = strmatch('"frame"',header1);

fprintf(' -- Data Loaded -- ')

% drift_x = transpose(linspace(0,1e3,length(locs)));
% drift_y = transpose(linspace(0,-2e3,length(locs)));
% 
% locs(:,xCol) = locs(:,xCol)+(drift_x*pixelsize);
% locs(:,yCol) = locs(:,yCol)+(drift_y*pixelsize);

%% Add drft to test data


drift_x = transpose(linspace(0,4,length(coords))); % drift in pxl
drift_y = transpose(linspace(0,-2,length(coords)));

coords = [];
coords(:,1) = (locs(:,xCol)/pixelsize)+drift_x;
coords(:,2) = (locs(:,yCol)/pixelsize)+drift_y;
coords(:,3) = locs(:,framesCol);


%% 

clc
% cd('W:\splineFitter\RCC')

coords(:,1) = locs(:,xCol)/pixelsize;
coords(:,2) = locs(:,yCol)/pixelsize;
coords(:,3) = locs(:,framesCol);

%% 
tic

% Input:    coords:             localization coordinates [x y frame], 
%           segpara:            segmentation parameters (time wimdow, frame)
%           imsize:             image size (pixel)
%           pixelsize:          camera pixel size (nm)
%           binsize:            spatial bin pixel size (nm)
%           rmax:               error threshold for re-calculate the drift (pixel)
% Output:   coordscorr:         localization coordinates after correction [xc yc] 
%           finaldrift:         drift curve (save A and b matrix for other analysis)

%finaldrift = RCC_TS(filepath, 1000, 256, 160, 30, 0.2);

segpara     = 5000;
imsize      = 293;
pixelsize 	= 106;
binsize     = 15;

% [coordscorr, finaldrift] = RCC(coords, segpara, imsize, pixelsize, binsize, 0.2);

% [coordscorr, finaldrift] = DCC(coords, segpara, imsize, pixelsize, binsize);

[coordscorr, finaldrift] = MCC(coords, segpara, imsize, pixelsize, binsize);

clc
toc

%% Plot Drift curves

figure('Position',[100 100 900 400])
subplot(2,1,1)
plot(finaldrift(:,1))
title('x Drift')
subplot(2,1,2)
plot(finaldrift(:,2))
title('y Drift')

%% Show before and after DC  

close all, clc

figure('Position',[100 400 400 400])
scatter(coords(:,1),coords(:,2),1);

figure('Position',[500 400 400 400])
scatter(coordscorr(:,1),coordscorr(:,2),1);

%% output TS csv file
outname = strrep(TSname, 'K_TS', 'K_RCC_TS');
TSpathout = strcat(TSparent, filesep, outname, TSext);
fid = fopen(TSpathout, 'w');
fprintf(fid, '%s\n', headerline);
fclose(fid);

TSfileout = TSfile;
TSfileout(:, 1) = coordscorr(:, 3);
TSfileout(:, 2:3) = coordscorr(:, 1:2) * pixelsize;
dlmwrite(TSpathout, TSfileout, '-append', 'delimiter', ',');

%% 

fileID = fopen('MT_test_wDrift.csv','w');
fprintf(fileID,[line ' \n']);
dlmwrite('MT_test_wDrift.csv',locs,'-append');
fclose('all');



