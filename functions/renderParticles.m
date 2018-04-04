function renderParticles(Cent_selected, channel_ID, pxlsize);

% Add Box around each Particle

% Combine both images

xCol = 1; yCol = 2;

Cent_selected_2C = {}; xmax = []; ymax = [];

for i=1:length(Cent_selected);
    
Cent_selected_2C{i,1} = vertcat(Cent_selected{i,1}(:,1:end),Cent_selected{i,2}(:,1:end));

end



for i=1:length(Cent_selected_2C);
  
% subtract minimum from the combined loc list    
    
Cent_selected_2C{i,1}(:,xCol) = Cent_selected_2C{i,1}(:,xCol) - min(Cent_selected_2C{i,1}(:,xCol));
Cent_selected_2C{i,1}(:,yCol) = Cent_selected_2C{i,1}(:,yCol) - min(Cent_selected_2C{i,1}(:,yCol));
    
% find the maximum

xmax(1,i) = max(Cent_selected_2C{i,1}(:,xCol));
ymax(1,i) = max(Cent_selected_2C{i,1}(:,yCol));

end

% Define the bounding box 

xmin = 0;
ymin = 0;

interval = 10;

lowerLine = [];
lowerLine(:,1) = xmin:((max(xmax))/interval):max(xmax); 
lowerLine(1:end,2) = ymin; 

upperLine = [];
upperLine(:,1) = xmin:(max(xmax)/interval):max(xmax); 
upperLine(1:end,2) = max(ymax)*1.5; 

leftLine = [];
leftLine(:,2) = ymin:((max(ymax))/interval):max(ymax); 
leftLine(1:end,1) = xmin; 

rightLine = [];
rightLine(:,2) = ymin:(max(ymax)/interval):max(ymax); 
rightLine(1:end,1) = max(xmax)*1.5; 

addedBox = [lowerLine; upperLine; leftLine; rightLine];

% figure
% scatter(addedBox(:,1), addedBox(:,2));

% Add the box to each channel and separate the two channels

% channel_ID = 12;

for i=1:length(Cent_selected_2C);

Cent_selected{i,3} = [Cent_selected_2C{i,1}(Cent_selected_2C{i,1}(:,channel_ID) == 1,1:2)+200; addedBox]; % Channel 1
Cent_selected{i,4} = [Cent_selected_2C{i,1}(Cent_selected_2C{i,1}(:,channel_ID) == 2,1:2)+200; addedBox]; % Channel 2

end


fprintf('-- Box added to each particle --');


%% Render the filtered images 

LocColCh1 = 3;
LocColCh2 = 4;

current_dir = pwd;
[status, message, messageid] = rmdir('rendered', 's');
mkdir rendered;
cd('rendered');

% Images Channel 1

count = 1;

for i = 1:size(Cent_selected,1);
    
        heigth      = round((max(Cent_selected{i,LocColCh1}(:,yCol)) - min(Cent_selected{i,LocColCh1}(:,yCol)))/pxlsize);
        width       = round((max(Cent_selected{i,LocColCh1}(:,xCol)) - min(Cent_selected{i,LocColCh1}(:,xCol)))/pxlsize);
        
        rendered    = hist3([Cent_selected{i,LocColCh1}(:,yCol),Cent_selected{i,LocColCh1}(:,xCol)],[heigth width]);
        rendered_cropped = imcrop(rendered,[2 2 width*0.95 heigth*0.95]);

        empty       = zeros(round((max(addedBox(:,1))/pxlsize)*1.5),round((max(addedBox(:,2))/pxlsize*1.5)));

        size_DC     = size(empty);
        center_X    = round(size_DC(2)/2);
        center_Y    = round(size_DC(1)/2);

        empty(round(center_Y-size(rendered_cropped,1)/2):(round(center_Y-size(rendered_cropped,1)/2))+size(rendered_cropped,1)-1,round(center_X-size(rendered_cropped,2)/2):(round(center_X-size(rendered_cropped,2)/2))+size(rendered_cropped,2)-1) = rendered_cropped;
       
        name32rendered  = ['image_particles_Channel_1_PxlSize_' num2str(pxlsize) '_' num2str(i) '.tiff'];
        

I32 = [];
I32 = uint32(empty);

t = Tiff(name32rendered,'w');
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

count=count+1;

end

% Images Channel 2

count=1;

for i = 1:size(Cent_selected,1);
    
        heigth      = round((max(Cent_selected{i,LocColCh2}(:,yCol)) - min(Cent_selected{i,LocColCh2}(:,yCol)))/pxlsize);
        width       = round((max(Cent_selected{i,LocColCh2}(:,xCol)) - min(Cent_selected{i,LocColCh2}(:,xCol)))/pxlsize);
        
        rendered    = hist3([Cent_selected{i,LocColCh2}(:,yCol),Cent_selected{i,LocColCh2}(:,xCol)],[heigth width]);
        rendered_cropped = imcrop(rendered,[2 2 width*0.95 heigth*0.95]);
        
        empty       = zeros(round((max(addedBox(:,1))/pxlsize)*1.5),round((max(addedBox(:,2))/pxlsize*1.5)));

        size_DC    = size(empty);
        center_X   = round(size_DC(2)/2);
        center_Y   = round(size_DC(1)/2);

        empty(round(center_Y-size(rendered_cropped,1)/2):(round(center_Y-size(rendered_cropped,1)/2))+size(rendered_cropped,1)-1,round(center_X-size(rendered_cropped,2)/2):(round(center_X-size(rendered_cropped,2)/2))+size(rendered_cropped,2)-1) = rendered_cropped;
       
        name32rendered  = ['image_particles_Channel_2_PxlSize_' num2str(pxlsize) '_' num2str(i) '.tiff'];


I32 = [];
I32 = uint32(empty);

t = Tiff(name32rendered,'w');
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

count=count+1;

end

cd ..

clc;
disp([' -- Images Saved --']);