clear, clc, close all

path     = 'W:\splineFitter\test_data';
filename = 'MT_test_noDrift.csv';

cd(path)
locs = dlmread(filename, ',',1,0);

file = fopen(filename);
line = fgetl(file);
header1 = regexp( line, ',', 'split' );

xCol            = strmatch('x_pix',header1);
yCol            = strmatch('x_pix',header1);
framesCol       = strmatch('frame',header1);

fprintf(' -- Data Loaded -- ')

%% Add drft to test data


drift_x = transpose(linspace(0,4,length(coords)));
drift_y = transpose(linspace(0,-2,length(coords)));

coords = [];
coords(:,1) = (locs(:,xCol)/pixelsize)+drift_x;
coords(:,2) = (locs(:,yCol)/pixelsize)+drift_y;
coords(:,3) = locs(:,framesCol);


%% 

clc
cd('W:\splineFitter\RCC')

coords(:,1) = locs(:,xCol);
coords(:,2) = locs(:,yCol);
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

segpara     = 500;
imsize      = 256;
pixelsize 	= 150;
binsize     = 15;

[coordscorr, finaldrift] = RCC(coords, segpara, imsize, pixelsize, binsize, 0.2);

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




