%% Particle segmentation from 2C data (TS format)

% Input: 
% 
%         individual localization files   --> loc path and name
%         individual WF images            --> WF path and name


% Workflow: 

% Load data and WF images
% Adjust WF image contrast
% Binarize and segment
% Produce overlay images and save the extraced particles

% Output: 
% 
%       Variable Cent

%     Cent{i,1} = locs_Ch1(target_Ch1,1:9);
%     Cent{i,2} = length(target_Ch1);
%     Cent{i,3} = intI(i);
%     Cent{i,4} = Particles_WF{i,1};
%     Cent{i,5} = locs_Ch2(target_Ch2,1:9);
%     Cent{i,6} = length(target_Ch2);
%     Cent{i,7} = intI2(i);
%     Cent{i,8} = Particles_WF2{i,1};


%% Read Data
clear, clc, close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for IM_number = 2; % loop for batch processing

pxl       = 106;                                                                    % Pixel size in nm
filetype  = 2;                                                                      % 1 for ThunderStorm, 2 for B-Store

%%%%%%%%%%%%%%%%% Manual Input %%%%%%%%%%%%%%%%%%%%%%%
  
WFpath          = ['/test_data_for_MultiColorSPR/Dual_color_STORM_dataset/Sas6_A647_WF' num2str(IM_number)]; 
WF_name         = ['Sas6_A647_WF' num2str(IM_number) '_MMStack_Pos0.ome.tif'];  

WFpath2         = ['/test_data_for_MultiColorSPR/Dual_color_STORM_dataset/Cep152_DL755_WF' num2str(IM_number)];
WF_name2        = ['Cep152_DL755_WF' num2str(IM_number) '_MMStack_Pos0.ome.tif'];          


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Locpath1         = ['/test_data_for_MultiColorSPR/Dual_color_STORM_dataset/Sas6_A647_' num2str(IM_number) '_1'];
locName1         = ['Sas6_A647_' num2str(IM_number) '_1_MMStack_1_Localizations_DC.csv'];

Locpath2         = ['/test_data_for_MultiColorSPR/Dual_color_STORM_dataset/Cep152_DL755_' num2str(IM_number) '_1'];
locName2         = ['Cep152_DL755_' num2str(IM_number) '_1_MMStack_1_Localizations_affineApplied_DC_corrected.csv'];

savename         = ['humanCent_Cep152_Sas6_2D_FOV_' num2str(IM_number) '_extractedParticles'];
savepath         =  '';
savepath_Images =   '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('\n -- Path and File information loaded --\n')
cd(Locpath1);

%% Load data

% First Channel, 642 nm

cd(WFpath);
ICh1   =   imread(WF_name);

% Second Channel, 750 nm

cd(WFpath2);
ICh2  =  imread(WF_name2);

% Load localization data set

cd(Locpath1);
locs_Ch1=dlmread(locName1,',',1,0);

cd(Locpath2);
locs_Ch2=dlmread(locName2,',',1,0);

% Load header

cd(Locpath1);
file    = fopen(locName1);
line    = fgetl(file);
h       = regexp( line, ',', 'split' );

if filetype == 1;
    
xCol       = strmatch('"x [nm]"',h);
yCol       = strmatch('"y [nm]"',h);
LLCol      = strmatch('"loglikelihood"',h);

else

xCol       = strmatch('x [nm]',h);
yCol       = strmatch('y [nm]',h);
LLCol      = strmatch('loglikelihood',h);

end

fprintf('\n -- Data loaded --\n')

%% (Optional) Find segmentation parameters using ImageJ

% javaaddpath 'C:\Program Files\MATLAB\R2016b\java\mij.jar'
% javaaddpath 'C:\Program Files\MATLAB\R2016b\java\ij-1.51g.jar'
% Miji;
% 
% MIJ.createImage('WF_Ch2', ICh2, true);
% MIJ.createImage('WF_CH1', ICh1, true);


%% Adjust segmentation parameters
%  Use OTSU or Manual segmentation

% Select Channel for Segmentation

Seg_Channel = 2;

if Seg_Channel==1; I=ICh1;
else I=ICh2;
end

% Using Otsu automatic Thresholding

% level       = graythresh(imadjust(I));
% bin         = im2bw(imadjust(I),level);

close all

% Using Manual Thresholding

minWF = 100;
maxWF = 1.0e3;

% blur the image
figure('Position',[10 600 500 500],'name','Raw GFP Image'), imshow(I,[minWF maxWF],'InitialMagnification','fit');

% adjust the contrast of the raw image
I2 = imadjust(I,[0.005 0.01],[]);
figure('Position',[600 600 500 500],'name','Image after adjusted contrast'), imshow(I2,'InitialMagnification','fit');

% lowpass filter of size and gaussian blur sigma, [lowpass filter] sigma
G = fspecial('gaussian',[3 3],100); % lowpass filter of size and gaussian blur sigma, [lowpass filter] sigma
imG = imfilter(I2,G,'same');
figure('Position',[1200 600 500 500],'name','Image after adjusted contrast, blurring'), imshow(imG,'InitialMagnification','fit');

% adjust the background
I3 = imadjust(imG,[0.5 0.7],[]);
figure('Position',[10 10 500 500],'name','Image after adjusted contrast, blurring, adjusted contrast'), imshow(I3,'InitialMagnification','fit');

% Make binary image
bin = im2bw(I3,0.3);
figure('Position',[600 10 500 500],'name','Binary image result'),imshow(bin,'InitialMagnification','fit')
[B,L,N,A] = bwboundaries(bin); % B - connectivity

figure('Position',[600 10 500 500],'name','Otsu segmentation'), imshow(bin,'InitialMagnification','fit');

[B,L,N,A]   = bwboundaries(bin); % B - connectivity

%% Extract particles

close all

% Extract the integrated intensity of the Ch1 WF (A647) image for each ROI
% Extract the integrated intensity of the Ch2 WF (A750) image for each ROI

intI = [];
intI2 = [];

for i = 1:length(B);
    
    intI(i,1) = sum(sum(ICh1(min(B{i,1}(:,1)):max(B{i,1}(:,1)),min(B{i,1}(:,2)):max(B{i,1}(:,2)))));
    intI2(i,1) = sum(sum(ICh2(min(B{i,1}(:,1)):max(B{i,1}(:,1)),min(B{i,1}(:,2)):max(B{i,1}(:,2)))));
    
end

% Extract subimages from both WF channels

Particles_WF  ={};
Particles_WF2 ={};

box_size = 20;

for k=1:length(B)
    
%   the border particles WF ROIs are saved without the box
    
    
       if      min(B{k,1}(:,1))<box_size+1 | min(B{k,1}(:,2)) < box_size+1 | max(B{k,1}(:,1))+box_size>length(ICh1) | max(B{k,1}(:,2))+box_size>length(ICh1)
           
               Particles_WF{k,1}  = ICh1((min(B{k,1}(:,1))):(max(B{k,1}(:,1))),(min(B{k,1}(:,2))):(max(B{k,1}(:,2))));
               Particles_WF2{k,1} = ICh2((min(B{k,1}(:,1))):(max(B{k,1}(:,1))),(min(B{k,1}(:,2))):(max(B{k,1}(:,2))));
           
       else
               Particles_WF{k,1}  = ICh1((min(B{k,1}(:,1))-box_size):(max(B{k,1}(:,1))+box_size),(min(B{k,1}(:,2))-box_size):(max(B{k,1}(:,2))+box_size));  
               Particles_WF2{k,1} = ICh2((min(B{k,1}(:,1))-box_size):(max(B{k,1}(:,1))+box_size),(min(B{k,1}(:,2))-box_size):(max(B{k,1}(:,2))+box_size));   
            
       end
    
           
end

%Find the center of each particle and transform into an X,Y coordinate

Center=[];

for k=1:length(B)
        
            boundary    = B{k};
            Center(k,1) = (((max(B{k,1}(:,1))-min(B{k,1}(:,1)))/2)+min(B{k,1}(:,1)))*(pxl);             % Center of the segemented spot in nm
            Center(k,2) = (((max(B{k,1}(:,2))-min(B{k,1}(:,2)))/2)+min(B{k,1}(:,2)))*(pxl);             % Center of the segemented spot in nm
            
            if mean(pdist(B{k,1}))>5;
            
            Center(k,3) = mean(pdist(B{k,1}))*1.0;                                                         % Size of the box, measure the max distance as input for the box size
            
            elseif mean(pdist(B{k,1}))<3;
            
            Center(k,3) = mean(pdist(B{k,1}))*3.0; 
            
            else
            Center(k,3) = mean(pdist(B{k,1}))*2.5;
            
            
            end
end

CFX = (max(locs_Ch1(:,xCol)/pxl))./size(I);
CFY = (max(locs_Ch1(:,yCol)/pxl))./size(I);

center2(:,1)    =   Center(:,2)*CFX(:,1); % Center of the segmented spot in nm
center2(:,2)    =   Center(:,1)*CFY(:,1); % Center of the segmented spot in nm
center2(:,3)    =   Center(:,3);
Center          =   center2;

fprintf('\n -- Particles extracted --\n')

%% Build box around each Center and copy locs into separate variable -> structure Cent

Cent={}; 
count = 1;
minLength_Ch1 = 100; minLength_Ch2 = 20;

for i = 1:length(Center);
    
    vx1 = Center(i,1)+Center(i,3)*pxl;
    vx2 = Center(i,1)-Center(i,3)*pxl;
    vy1 = Center(i,2)+Center(i,3)*pxl;
    vy2 = Center(i,2)-Center(i,3)*pxl;
    
    target_Ch1 = find(locs_Ch1(:,xCol)>vx2 & locs_Ch1(:,xCol)<vx1 & locs_Ch1(:,yCol)>vy2 & locs_Ch1(:,yCol)<vy1);
    target_Ch2 = find(locs_Ch2(:,xCol)>vx2 & locs_Ch2(:,xCol)<vx1 & locs_Ch2(:,yCol)>vy2 & locs_Ch2(:,yCol)<vy1);
    
    if length(target_Ch1)>minLength_Ch1 == 1 & length(target_Ch2)>minLength_Ch2 == 1;
    
    Cent{count,1} = locs_Ch1(target_Ch1,1:end);
    Cent{count,2} = length(target_Ch1);
    Cent{count,3} = intI(i);
    Cent{count,4} = Particles_WF{i,1};
    Cent{count,5} = locs_Ch2(target_Ch2,1:end);
    Cent{count,6} = length(target_Ch2);
    Cent{count,7} = intI2(i);
    Cent{count,8} = Particles_WF2{i,1};
    
    count = count + 1;
    
    else end
   
end 
    
fprintf('\n -- %f Particles selected from localitaion dataset --\n',length(Cent))

%% Remove duplicates

all_segmented_Locs_Ch1 = []; sumOfLocsCh1 = 0;
all_segmented_Locs_Ch2 = []; sumOfLocsCh2 = 0;

for i = 1:size(Cent,1);
    
    Cent{i,1}(:,end+1) = i; % add the cent ID
    Cent{i,5}(:,end+1) = i; % add the cent ID
    
    sumOfLocsCh1 = sumOfLocsCh1 + length(Cent{i,1});  sumOfLocsCh2 = sumOfLocsCh2 + length(Cent{i,5});
    
    all_segmented_Locs_Ch1 = vertcat(all_segmented_Locs_Ch1, Cent{i,1}(:,1:end));
    all_segmented_Locs_Ch2 = vertcat(all_segmented_Locs_Ch2, Cent{i,5}(:,1:end));

    clc; 
    fprintf(['Copied ' num2str(i) ' of ' num2str(length(Cent))]);
    
end

C_Ch1 = unique(all_segmented_Locs_Ch1,'rows');
C_Ch2 = unique(all_segmented_Locs_Ch2,'rows');

Cent_wo_duplicates = Cent;

for i = 1:size(Cent,1);
    
   Cent_wo_duplicates{i,1} = C_Ch1(C_Ch1(:,11)==i, 1:end);
   Cent_wo_duplicates{i,5} = C_Ch2(C_Ch2(:,11)==i, 1:end);

   clc; 
   fprintf(['Cleaned ' num2str(i) ' of ' num2str(length(Cent))]);
   
end

ratioCh1 = length(C_Ch1)/length(all_segmented_Locs_Ch1)     % removed duplicates
Ch1_fromTotal = sumOfLocsCh1/length(locs_Ch1)               % from all los

ratioCh2 = length(C_Ch2)/length(all_segmented_Locs_Ch2)
Ch1_fromTotal = sumOfLocsCh2/length(locs_Ch2)


fprintf('\n -- Duplicates removed --\n');

%% Overlay with Widefield image and plot correlations

% the coordinates need be backtransformed into pxl coordinates
% 1. divide by correction factor
% 2. divide trough pxl size
close all 
% MIJ.closeAllWindows;
cd(savepath)

figure('Position',[150 150 400 400],'name',['Extracted Particles from Ch1 on WF of Ch1']);
imshow(ICh1,[minWF maxWF]); hold on;

for i = 1:size(Cent_wo_duplicates,1);
    
CentO=[];
CentO(:,1) = Cent_wo_duplicates{i,1}(:,xCol)/CFX(:,1);
CentO(:,2) = Cent_wo_duplicates{i,1}(:,yCol)/CFY(:,1);

    
cmap = parula(length(Cent_wo_duplicates));  %# Creates a 6-by-3 set of colors from the HSV colormap
    
scatter(CentO(:,1)/pxl,CentO(:,2)/pxl,1,cmap(randi([1 length(Cent_wo_duplicates)],1,1),1:3));
    
hold on;
end

cd(savepath_Images);
% savefig(['Overlay_extracted_particles_on_WF_Ch1_FOV_' num2str(IM_number) '.fig']); cd ..

figure('Position',[150 150 400 400],'name',['Extracted Particles from Ch2 on WF of Ch2']);
imshow(ICh2,[minWF maxWF]); hold on;

for i = 1:size(Cent_wo_duplicates,1);
    
CentO=[];
CentO(:,1) = Cent_wo_duplicates{i,5}(:,xCol)/CFX(:,1);
CentO(:,2) = Cent_wo_duplicates{i,5}(:,yCol)/CFY(:,1);
    
scatter(CentO(:,1)/pxl,CentO(:,2)/pxl,1,cmap(randi([1 length(Cent_wo_duplicates)],1,1),1:3));

hold on;
end

cd(savepath_Images);
% savefig(['Overlay_extracted_particles_on_WF_Ch2_FOV_' num2str(IM_number) '.fig']); cd ..

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
% figure('Position',[1000 600 500 500],'name','All localizations');
% imshow(I,[minWF_GFP maxWF_GFP]); hold on;
% CentO = [];
% CentO(:,1) = locs_Ch1(:,x)/CFX(:,1);
% CentO(:,2) = locs_Ch1(:,y)/CFX(:,1);;
% scatter(CentO(:,1)/pxl,CentO(:,2)/pxl,1,'r');
% 
% savefig('Overlay_all_Locs_onGFP.fig');

% Plot for each Particle (1) the integrate intensity vs (2) the nbr of locs 

figure('Position',[400 100 900 300],'name','# of Locs vs. GFP Intensity');

subplot(1,3,1)
scatter(cell2mat(Cent_wo_duplicates(:,2)),cell2mat(Cent_wo_duplicates(:,3)),5,'filled','r');hold on;
xlabel('Nbr of locs Ch1');
ylabel('Ch1 WF int intensity');
box on;
axis square;

subplot(1,3,2);
scatter(cell2mat(Cent_wo_duplicates(:,6)),cell2mat(Cent_wo_duplicates(:,7)),5,'filled','r');hold on;
xlabel('Nbr of locs Ch2');
ylabel('Ch2 WF int intensity');
box on;
axis square;

subplot(1,3,3);
scatter(cell2mat(Cent_wo_duplicates(:,3)),cell2mat(Cent_wo_duplicates(:,7)),5,'filled','r');hold on;
xlabel('Ch1 intensity');
ylabel('Ch2 intensity');
box on;
axis square;


C = imfuse(ICh1,ICh2,'falsecolor','Scaling','independent','ColorChannels',[1 2 0]);

figure('Position',[100 300 1400 400]); 
subplot(1,3,1)
imshow(imadjust(ICh1));
title('Channel 1 642 nm');
subplot(1,3,2)
imshow(imadjust(ICh2));
title('Channel 2 750 nm');
subplot(1,3,3)
imshow(C);
title('Overlay');

% cd(savepath_Images);
% savefig(['WF_correlation_FOV_' num2str(IM_number) '.fig']); cd ..

cd(savepath)
save(savename,'Cent','-v7.3');


fprintf('\n -- Extracted centrioles saved --\n')

% clear, clc, close all
end

%% Combine each FOV into single file

clear, clc

all = {};

for i = [1,2,3,4,5,6,7,8,9,10,11,12,14,15,16,17,18,19,20,22,23];

load(['2017-12-08_humanCent_Cep152_Sas6_2D_FOV_' num2str(i) '_extractedParticles.mat'])

all = vertcat(Cent,all);

clc
fprintf([' Done FOV ' num2str(i)])

end

save('2017-12-08_humanCent_Cep152_Sas6_2D_extractedParticles.mat','all','-v7.3');


fprintf(' - Finished - ');
