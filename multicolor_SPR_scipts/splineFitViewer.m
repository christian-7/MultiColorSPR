%% Open localization file

cd('E:\Shares\lebpc4-data12TB\to_analyze\2018-03-21_humanCent_Cep164_Cep152\locResults\Spline');

filename = 'Cep152_DL755_4_Localizations2';
locs     = dlmread([filename '.csv'],',',1,0);

file          = fopen([filename '.csv']);
line          = fgetl(file);
header        = regexp( line, ',', 'split' );

xCol            = strmatch('x_nm',header);
yCol            = strmatch('y_nm',header);
framesCol       = strmatch('frame',header);
LLCol           = strmatch('logLikelyhood',header);
photonsCol      = strmatch('photons',header);

%% Show histograms of filter parameters

close all

figure('Position',[400 300 700 300])
subplot(1,2,1);
bins = -1000:50:0;
h1 = hist(locs(:,LLCol),bins);
bar(bins,h1/sum(h1));
xlabel('LL')
title(['Median = ' num2str(median(locs(:,LLCol)))]);
axis([-1000 0 0 max(h1/sum(h1))])


subplot(1,2,2);
bins = 0:200:10000;
h1 = hist(locs(:,photonsCol),bins);
bar(bins,h1/sum(h1));
xlabel('Photons');
title(['Median = ' num2str(median(locs(:,photonsCol)))]);
axis([0 1e4 0 max(h1/sum(h1))])

%% Filter localizations

minFrame            = 10000;
MinPhotons          = 300;
MaxLL               = -300;
        
filter              = [];
filter              = find(locs(:,photonsCol) > MinPhotons & locs(:,LLCol) > MaxLL & locs(:,framesCol) > minFrame);
locsFilt            = locs(filter,1:end);

clc
display(['Localizations filtered (' num2str(length(locsFilt)/length(locs)) ' left)']);

%% Render localizations

pxlsize = 10;

heigth = round((max(locsFilt(:,yCol)) - min((locsFilt(:,yCol))))/pxlsize);
width  = round((max(locsFilt(:,xCol)) - min((locsFilt(:,xCol))))/pxlsize);
        
rendered = hist3([locsFilt(:,yCol),locsFilt(:,xCol)],[heigth width]);

figure 
% imagesc(imadjust(imgaussfilt(rendered,1)));
imshow(imgaussfilt(rendered,1),[0.01 1]);
colormap hot

%% Save image

I32 = [];
I32 = uint32(rendered);

t = Tiff('test.tiff','w');
tagstruct.ImageLength     = size(I32,1);
tagstruct.ImageWidth      = size(I32,2);
tagstruct.Photometric     = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample   = 32;
tagstruct.SamplesPerPixel = 1;
tagstruct.RowsPerStrip    = 16;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.Software        = 'MATLAB';
t.setTag(tagstruct)

t.write(I32);
t.close()