
% 1  - locs Ch1
% 2  - Rg Ch1
% 3  - Ecc Ch1
% 4  - FRC Ch1
% 5  - MeanH Ch1;
% 6  - StdH Ch1;
% 7  - MinH Ch1;
% 8  - MaxH Ch1;
% 9  - Circularity 
% 10 - Rectangularity Ch1
% 11 - FA Ch1
% 12 - Symmetry Ch1
% 13 - Circularity Ch1

%% Generate test table from filtered Centrioles to train the Classifier

line = {'Rg', 'Ecc', 'FRC', 'MeanH', 'StdH', 'MinH', 'MaxH', 'CircRatio','RectRatio','FA','Sym','Circ','response'};

Rg          = cell2mat(CentForTraining(:,2));
Ecc         = cell2mat(CentForTraining(:,3));
FRC         = cell2mat(CentForTraining(:,4));
MeanH       = cell2mat(CentForTraining(:,5));
StdH        = cell2mat(CentForTraining(:,6));
MinH        = cell2mat(CentForTraining(:,7));
MaxH        = cell2mat(CentForTraining(:,8));
CircRatio   = cell2mat(CentForTraining(:,9));
RectRatio   = cell2mat(CentForTraining(:,10));
FA          = cell2mat(CentForTraining(:,11));
Sym         = cell2mat(CentForTraining(:,12));
Circ        = cell2mat(CentForTraining(:,13));

% clear Rg Ecc FRC MeanH StdH MinH MaxH CircRatio

test_data = table(Rg,Ecc,FRC,MeanH,StdH,MinH,MaxH,CircRatio,RectRatio,FA,Sym,Circ,response2,...
    'VariableNames',line);

%% Start the classification

classificationLearner;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Generate tabular data from segmented dataset

% dataForClass = CentForTraining; % Selected Centrioles
dataForClass = DBSCAN_filtered; % Full dataset

% For Channel 1

line = {'Rg', 'Ecc', 'FRC', 'MeanH', 'StdH', 'MinH', 'MaxH', 'CircRatio','RectRatio','FA','Sym','Circ'};
    
Rg          = cell2mat(dataForClass(:,2));
Ecc         = cell2mat(dataForClass(:,3));
FRC         = cell2mat(dataForClass(:,4));
MeanH       = cell2mat(dataForClass(:,5));
StdH        = cell2mat(dataForClass(:,6));
MinH        = cell2mat(dataForClass(:,7));
MaxH        = cell2mat(dataForClass(:,8));
CircRatio   = cell2mat(dataForClass(:,9));
RectRatio   = cell2mat(dataForClass(:,10));
FA          = cell2mat(dataForClass(:,11));
Sym         = cell2mat(dataForClass(:,12));
Circ        = cell2mat(dataForClass(:,13));   
    
test_data = table(Rg,Ecc,FRC,MeanH,StdH,MinH,MaxH,CircRatio,RectRatio,FA,Sym,Circ,...
    'VariableNames',line);

clc
disp([' -- Table generated, Ready to Classify -- ']);

%% Load an existing classifier

% load('Z:\Christian-Sieben\data_HTP\2017-07-26_humanCent_Cep57_Sas6\analysis\machine_learning\Cep57_Top_allPred.mat')
% load('Z:\Christian-Sieben\data_HTP\2017-07-26_humanCent_Cep57_Sas6\analysis\machine_learning\Cep57_Side_allPred.mat')

% load('Z:\Christian-Sieben\data_HTP\2017-08-22_humanCent_Cep192_Cep57\machine_learning\Cep57_Ch2_Side.mat')


clc

Class_Result = Cep152_Side.predictFcn(test_data);

disp([' -- Particles Classified -- ']);



%%  Export the Classified Top Views 

Predicted_Top = {};

count = 1;

for i = 1:length(Class_Result);
    
    if Class_Result(i,1)==1;  
    
    Predicted_Top{count,1} = DBSCAN_filtered{i,1}; % Channel 1

%     Predicted_Top{count,1} = CentForTraining{i,1}; % Channel 1
    
    count = count+1;

    else end
    
end

count
   
%% Show overview of selection

close all;

pxlsize = 10; xCol = 1; yCol = 2;

for i = 1:length(Predicted_Top);

        heigth      = round((max(Predicted_Top{i,1}(:,yCol)) - min(Predicted_Top{i,1}(:,yCol)))/pxlsize);
        width       = round((max(Predicted_Top{i,1}(:,xCol)) - min(Predicted_Top{i,1}(:,xCol)))/pxlsize);
        
        rendered    = hist3([Predicted_Top{i,1}(:,yCol),Predicted_Top{i,1}(:,xCol)],[heigth width]);
        
        Predicted_Top{i,2} = hist3([Predicted_Top{i,1}(:,yCol),Predicted_Top{i,1}(:,xCol)],[heigth width]);
       
end

% Make a Gallery of both channels

NbrOfSubplots = round(sqrt(length(Predicted_Top)))+1;

figure('Position',[100 100 800 800]);

for i = 1:length(Predicted_Top);
    
    subplot(NbrOfSubplots,NbrOfSubplots,i);
    imagesc(imgaussfilt(Predicted_Top{i,2},1));
    title(['ID = ' num2str(i)]);
    set(gca,'YTickLabel',[],'XTickLabel',[]);
    colormap hot
    axis equal
    
end


%% Make fine selection

clc, close all

% ID = [2,3,6];
% or
ID = 1:1:length(Predicted_Top);

PredictedTop_Subset = Predicted_Top;

PredictedTop_Subset = {};
PredictedTop_Subset = Predicted_Top(transpose(ID),1:2);

% ID = transpose(1:1:length(Predicted_Top));

% Make a Gallery of both Channels

NbrOfSubplots = round(sqrt(length(ID)))+1;

figure('Position',[100 100 800 800],'name',['Channel 1']);

for i = 1:length(ID);
    
    subplot(NbrOfSubplots,NbrOfSubplots,i);
    imagesc(imgaussfilt(Predicted_Top{ID(i),2},1));
    title(['ID = ' num2str(ID(i))]);
    set(gca,'YTickLabel',[],'XTickLabel',[]);
    colormap hot
    axis equal
        
end


%% Create Overlay based on center of mass for both channels

ProjectionX_Ch1 = []; ProjectionY_Ch1 = [];

for i = 1:size(PredictedTop_Subset,1);
    
    % Channel 1
    
    PredictedTop_Subset{i,3}(:,1) = PredictedTop_Subset{i,1}(:,1) - min(PredictedTop_Subset{i,1}(:,1));
    PredictedTop_Subset{i,3}(:,2) = PredictedTop_Subset{i,1}(:,2) - min(PredictedTop_Subset{i,1}(:,2));
    
    ProjectionX_Ch1 = vertcat(ProjectionX_Ch1,PredictedTop_Subset{i,1}(:,1) - median(PredictedTop_Subset{i,1}(:,1))); 
    ProjectionY_Ch1 = vertcat(ProjectionY_Ch1,PredictedTop_Subset{i,1}(:,2) - median(PredictedTop_Subset{i,1}(:,2))); 
    
    
end

% Show averaged view

        heigth      = round((max(ProjectionY_Ch1) - min(ProjectionY_Ch1))/pxlsize);
        width       = round((max(ProjectionX_Ch1) - min(ProjectionX_Ch1))/pxlsize);
        
        renderedAvg_Ch1    = hist3([ProjectionY_Ch1,ProjectionX_Ch1],[heigth width]);
                
         
        figure
        imagesc(imgaussfilt(renderedAvg_Ch1,1));
        axis off
        colormap hot
        axis equal
        title('Averaged Image Ch1')
               
        
%% Add Box around each Particle

% Combine both images

xCol = 1; yCol = 2; xmax = []; ymax = [];

for i=1:size(PredictedTop_Subset,1);
    
% find the maximum

xmax(1,i) = max(PredictedTop_Subset{i,3}(:,xCol));
ymax(1,i) = max(PredictedTop_Subset{i,3}(:,yCol));

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
upperLine(1:end,2) = max(max(ymax),max(xmax))*1.5; 

leftLine = [];
leftLine(:,2) = ymin:((max(ymax))/interval):max(ymax); 
leftLine(1:end,1) = xmin; 

rightLine = [];
rightLine(:,2) = ymin:(max(ymax)/interval):max(ymax); 
rightLine(1:end,1) = max(max(ymax),max(xmax))*1.5; 

addedBox = [lowerLine; upperLine; leftLine; rightLine];

figure
scatter(addedBox(:,1), addedBox(:,2));

% Add the box to each channel and separate the two channels


for i=1:size(PredictedTop_Subset,1);

PredictedTop_Subset{i,4} = [PredictedTop_Subset{i,3}+round(max(rightLine(:,1))/5); addedBox]; % Channel 1

end

clc
fprintf('-- Box added to each particle --');


%% Render the filtered images 
close all

LocColCh1 = 4;

pxlsize = 10;

current_dir = pwd;
[status, message, messageid] = rmdir('rendered_selected', 's');
mkdir rendered_selected;
cd('rendered_selected');

% Images Channel 1

count=1;

for i = 1:size(PredictedTop_Subset,1);
    
        heigth      = round((max(PredictedTop_Subset{i,LocColCh1}(:,yCol)) - min(PredictedTop_Subset{i,LocColCh1}(:,yCol)))/pxlsize);
        width       = round((max(PredictedTop_Subset{i,LocColCh1}(:,xCol)) - min(PredictedTop_Subset{i,LocColCh1}(:,xCol)))/pxlsize);
        
        rendered         = hist3([PredictedTop_Subset{i,LocColCh1}(:,yCol),PredictedTop_Subset{i,LocColCh1}(:,xCol)],[heigth width]);
        rendered_cropped = imcrop(rendered,[2 2 width*0.95 heigth*0.95]);

        empty       = zeros(round((max(addedBox(:,1))/pxlsize)*1.5),round((max(addedBox(:,2))/pxlsize*1.5)));

        size_DC     = size(empty);
        center_X    = round(size_DC(2)/2);
        center_Y    = round(size_DC(1)/2);

        empty(round(center_Y-size(rendered_cropped,1)/2):(round(center_Y-size(rendered_cropped,1)/2))+size(rendered_cropped,1)-1,round(center_X-size(rendered_cropped,2)/2):(round(center_X-size(rendered_cropped,2)/2))+size(rendered_cropped,2)-1) = rendered_cropped;
       
        name32rendered  = ['Particles_Channel_1_PxlSize_' num2str(pxlsize) '_' num2str(i) '.tiff'];


I32 = [];
I32 = uint32(rendered_cropped);

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

%% Use ImageJ to create, blur and save the Montage

% javaaddpath 'C:\Program Files\MATLAB\R2016b\java\mij.jar'
% javaaddpath 'C:\Program Files\MATLAB\R2016b\java\ij-1.51g.jar'
% Mij.start;
% Miji

% Channel 1

string1 = ['Image Sequence...']; string2 = ['open=' num2str('rendered_selected') ' file=Channel_1 sort'];
MIJ.run(string1, string2);
MIJ.run('Gaussian Blur...','sigma=1 stack');
MIJ.run('16-bit');
string1 = ['Image Sequence... ']; 
string2 = ['format=TIFF name=Particles_Ch1_ start=1 digits=3 save=' strrep(pwd,'\','\\') '\\rendered_selected\\Particles_Ch1_001.tif'];

MIJ.run(string1, string2);
MIJ.run('Close All')

disp([' -- Images Converted --']);

%% Rotate the image and compare it with the reference

folder      = 'Cep63_top';
data_name   = 'Cep63_top';
Channel     = 1; % Channel 1 or 2
mode        = 1; % 0 = min; 1 = max;

%%%%%%%%%%%%%%

cd(folder); Im1 = im2double(imread([data_name '_000.tif'])); cd ..

for j = 1:1:7%length(ID);
    
    % Construct the file name

if (0<j) && (j<10);
image_name = [[data_name '_00'] num2str(j) '.tif'];   
elseif (10<=j) && (j<100);
image_name = [[data_name '_0'] num2str(j) '.tif'];
else
image_name = [[data_name '_'] num2str(j) '.tif'];
end

cd(folder); Im2 = im2double(imread(image_name)); cd ..

rot_reg = [];
rot_reg = zeros(360,5);
rot_reg(:,1) = 1:1:360;

    % Rotate image 2 and crop overhangs 

for i=1:length(rot_reg);
    
Im2_rot = imrotate(Im2, rot_reg(i,1));

if size(Im2_rot,1) == size(Im2,1);
  
    Im2_rot_crop = Im2_rot;  

else
    
%   Im2_rot_crop = imcrop(Im2_rot,[round(size(Im2_rot,1)/2-size(Im2,1)/2) round(size(Im2_rot,1)/2-size(Im2,1)/2) size(Im2,1)-1 size(Im2,1)-1]);
    Im2_rot_crop = imcrop(Im2_rot,[round(size(Im2_rot,1)/2-size(Im2,1)/2) round(size(Im2_rot,1)/2-size(Im2,1)/2) size(Im1,1) size(Im1,1)]);
    
end


try
    
usfac = 10;
[output, Greg] = dftregistration(fft2(Im1),fft2(Im2_rot_crop),usfac);

catch
    rot_reg(i,2:5) = 0;
continue
end

rot_reg(i,2:5) = output;

end

% Find the minimum/maximum error

if mode == 0;
    target = find(rot_reg(:,2)==min(rot_reg(:,2)));
else
    target = find(rot_reg(:,2)==max(rot_reg(:,2)));
end

if length(target)>1;
    target = target(1);
else end

% Apply the best rotation

Im2_rot = imrotate(Im2, rot_reg(target,1));

if size(Im2_rot,1) == size(Im2);
  Im2_rot_crop = Im2_rot;  
else
%   Im2_rot_crop = imcrop(Im2_rot,[round(size(Im2_rot,1)/2-size(Im2,1)/2) round(size(Im2_rot,1)/2-size(Im2,1)/2) size(Im2,1)-1 size(Im2,1)-1]);
    Im2_rot_crop = imcrop(Im2_rot,[round(size(Im2_rot,1)/2-size(Im2,1)/2) round(size(Im2_rot,1)/2-size(Im2,1)/2) size(Im1,1) size(Im1,1)]);
end

% Register rotated image again to the first

usfac = 10;

[output, Greg] = dftregistration(fft2(Im1),fft2(Im2_rot_crop),usfac);

Im2_corr = abs(ifft2(Greg));

AveragedIm = imadd(Im1,Im2_corr)/2;
% AveragedIm = imadd(Im1,Im2_rot_crop)/2;

Im1 = AveragedIm;

clc; display(j);

end

if Channel==1;  
    Im1_Ch1 = Im1;
    figure;imagesc(imgaussfilt(Im1_Ch1,1));
elseif Channel==2;
    Im1_Ch2 = Im1;
    figure;imagesc(imgaussfilt(Im1_Ch2,1));
else
end

%% Show final images

figure('Position',[100 600 500 300]);

subplot(2,2,1)
imagesc(imgaussfilt(renderedAvg_Ch1,1));
colormap hot
axis equal
axis off
title('Ch1 Before CC');

subplot(2,2,2)
imagesc(imgaussfilt(Im1_Ch1,1));
colormap hot
axis equal
axis off
title('Ch1 After CC');

subplot(2,2,3)
imagesc(imgaussfilt(renderedAvg_Ch2,1));
colormap hot
axis equal
axis off
title('Ch2 Before CC');

subplot(2,2,4)
imagesc(imgaussfilt(Im1_Ch2,1));
colormap hot
axis equal
axis off
title('Ch2 After CC');

C = imfuse(imgaussfilt(Im1_Ch1,1),imgaussfilt(Im1_Ch2,1),'falsecolor','Scaling','independent','ColorChannels',[1 2 0]);

figure('Position',[600 600 500 500]);

imshow(C);
axis equal
axis off
title('Channel Overlay');


%% Save the images

savename = 'renderedAvg_Ch1_Top.tiff';

I32     = [];
I32     = uint32(renderedAvg_Ch1);

t = Tiff(savename,'w');

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

savename = 'renderedAvg_Ch2_Top.tiff';

I32     = [];
I32     = uint32(renderedAvg_Ch2);

t = Tiff(savename,'w');

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

imwrite(Im1_Ch1,'Cep152_Top_afterCC_allPart.tiff');
imwrite(Im1_Ch2,'Im1_Ch2_Top.tiff');


%% 


