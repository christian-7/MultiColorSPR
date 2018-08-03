function RCC_short(locPath, segpara, imsize, pixelsize, binsize, rmax)

locPath     = 'W:\splineFitter\test_data\MT_test_noDrift.csv';
addpath('W:\splineFitter\RCC');
segpara     = 500;
imsize      = 256;
pixelsize 	= 150;
binsize     = 15;

%%%%%%%%%%%%%%%%%%%%%%%

[folder,name, ext] = fileparts(locPath);

cd(folder);
locs = dlmread([name ext], ',',1,0);

file = fopen([name ext]);
line = fgetl(file);
header1 = regexp( line, ',', 'split' );

xCol            = strmatch('x_pix',header1);
yCol            = strmatch('x_pix',header1);
framesCol       = strmatch('frame',header1);

fprintf('\n -- Data Loaded -- \n')
%% Generate Input for RCC
coords(:,1) = locs(:,xCol)/pxlsize;
coords(:,2) = locs(:,yCol)/pxlsize;
coords(:,3) = locs(:,framesCol);

fprintf('\n -- Starting RCC ... \n')

[coordscorr, finaldrift] = RCC(coords, segpara, imsize, pixelsize, binsize, 0.2);
%% output TS csv file

fileout         = locs;
fileout(:, 1)   = coordscorr(:, 3);
fileout(:, 2:3) = coordscorr(:, 1:2) * pixelsize;

cd(folder);
outname = [name '_RCC_DC.csv'];
fid = fopen(outname, 'w');
fprintf(fileID,[[line] ' \n']);
dlmwrite(outname, fileout, '-append', 'delimiter', ',');
fclose('all');
end
