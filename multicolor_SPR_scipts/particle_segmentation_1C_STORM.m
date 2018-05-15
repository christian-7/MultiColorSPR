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

%           Other options:

%                           DBSCAN filter
%                           overview plotting
%                           save images

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

% for IM_number = [9,10,11,12,13,14,15,16,17,19,20];

pxl       = 106;                                                                    % Pixel size in nm
IM_number = 4;                                                                      % image number
filetype  = 3;                                                                      % 1 for TS, 2 for bstore, 3 for rapidStorm

%%%%%%%%%%%%%%%%% Manual Input %%%%%%%%%%%%%%%%%%%%%%%

WFpath          = ['/Users/christian/Downloads/p24wD - pUL37 Secondary labelling/MALK_Format'];
WF_name         = ['AVG_a' num2str(IM_number) '_AF568_after.tif'];         

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Locpath1         = ['/Users/christian/Downloads/p24wD - pUL37 Secondary labelling/MALK_Format'];
locName1         = ['a' num2str(IM_number) '_AF647_Malk.txt'];

savename         = ['a1_AF647_Malk' num2str(IM_number) '_extractedParticles'];
savepath         =  '/Users/christian/Downloads/p24wD - pUL37 Secondary labelling/MALK_Format';

savepath_Images =   '/Users/christian/Downloads/p24wD - pUL37 Secondary labelling/MALK_Format';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('\n -- Path and File information loaded --\n')
cd(Locpath1);

%% Load data

if filetype == 3;
    
cd(Locpath1);
locs_Ch1 = dlmread(locName1,' ',2,0);  
xCol       = 1;
yCol       = 2;

cd(WFpath);
ICh1   =   imread(WF_name);

else

% First Channel, 642 nm

cd(WFpath);
ICh1   =   imread(WF_name);

% Load localization data set

cd(Locpath1);
locs_Ch1 = dlmread(locName1,',',1,0);

% Load header

cd(Locpath1);
file    = fopen(locName1);
line    = fgetl(file);
h       = regexp( line, ',', 'split' );

if filetype == 1;
    
xCol       = strmatch('"x [nm]"',h);
yCol       = strmatch('"y [nm]"',h);
LLCol      = strmatch('"loglikelihood"',h);

elseif filetype == 1;

xCol       = strmatch('x [nm]',h);
yCol       = strmatch('y [nm]',h);
LLCol      = strmatch('loglikelihood',h);

else
end

end

fprintf('\n -- Data loaded --\n')

%% Find segmentation parameters using ImageJ

% javaaddpath 'C:\Program Files\MATLAB\R2016b\java\mij.jar'
% javaaddpath 'C:\Program Files\MATLAB\R2016b\java\ij-1.51g.jar'
% % Mij.start;
% Miji;
% 
% MIJ.createImage('WF_Ch2', ICh2, true);
% MIJ.createImage('WF_CH1', ICh1, true);


%% Adjust segmentation parameters

I = ICh1;

close all

minWF = 25;
maxWF = 233;

% blur the image
figure('Position',[10 600 500 500],'name','Raw GFP Image'), imshow(I,[minWF maxWF],'InitialMagnification','fit');

% adjust the contrast of the raw image
I2 = imadjust(I,[0.3 0.4],[]);
figure('Position',[600 600 500 500],'name','Image after adjusted contrast'), imshow(I2,'InitialMagnification','fit');

% lowpass filter of size and gaussian blur sigma, [lowpass filter] sigma
G = fspecial('gaussian',[3 3],100); % lowpass filter of size and gaussian blur sigma, [lowpass filter] sigma
imG = imfilter(I2,G,'same');
figure('Position',[1200 600 500 500],'name','Image after adjusted contrast, blurring'), imshow(imG,'InitialMagnification','fit');

% adjust the background
I3 = imadjust(imG,[0.2 0.6],[]);
figure('Position',[10 10 500 500],'name','Image after adjusted contrast, blurring, adjusted contrast'), imshow(I3,'InitialMagnification','fit');

% Make binary image
bin = im2bw(I3,0.3);
figure('Position',[600 10 500 500],'name','Binary image result'),imshow(bin,'InitialMagnification','fit')
[B,L,N,A] = bwboundaries(bin); % B - connectivity

% Using Otsu automatic Thresholding

% level       = graythresh(imadjust(I));
% bin         = im2bw(imadjust(I),level);

figure('Position',[600 10 500 500],'name','Otsu segmentation'), imshow(bin,'InitialMagnification','fit');

[B,L,N,A]   = bwboundaries(bin); % B - connectivity

%% Extract particles

close all

% Extract the integrated intensity of the Ch1 WF (A647) image for each ROI
% Extract the integrated intensity of the Ch2 WF (A750) image for each ROI

intI = [];


for i = 1:length(B);
    
    intI(i,1) = sum(sum(ICh1(min(B{i,1}(:,1)):max(B{i,1}(:,1)),min(B{i,1}(:,2)):max(B{i,1}(:,2)))));
    
end

% Extract subimages from both WF channels

Particles_WF  ={};


box_size = 20;

for k=1:length(B)
    
%   the border particles WF ROIs are saved without the box
    
    
       if      min(B{k,1}(:,1))<box_size+1 | min(B{k,1}(:,2)) < box_size+1 | max(B{k,1}(:,1))+box_size>length(ICh1) | max(B{k,1}(:,2))+box_size>length(ICh1)
           
               Particles_WF{k,1}  = ICh1((min(B{k,1}(:,1))):(max(B{k,1}(:,1))),(min(B{k,1}(:,2))):(max(B{k,1}(:,2))));
               
           
       else
               Particles_WF{k,1}  = ICh1((min(B{k,1}(:,1))-box_size):(max(B{k,1}(:,1))+box_size),(min(B{k,1}(:,2))-box_size):(max(B{k,1}(:,2))+box_size));  
               
            
       end
    
           
end

%Find the center of each particle and transform into an X,Y coordinate

Center=[];center2 = [];

for k=1:length(B)
        
            boundary    = B{k};
            Center(k,1) = (((max(B{k,1}(:,1))-min(B{k,1}(:,1)))/2)+min(B{k,1}(:,1)))*(pxl);             % Center of the segemented spot in nm
            Center(k,2) = (((max(B{k,1}(:,2))-min(B{k,1}(:,2)))/2)+min(B{k,1}(:,2)))*(pxl);             % Center of the segemented spot in nm
            
            if mean(pdist(B{k,1}))>5;
            
            Center(k,3) = mean(pdist(B{k,1}))*1;                                                         % Size of the box, measure the max distance as input for the box size
            
            elseif mean(pdist(B{k,1}))<3;
            
            Center(k,3) = mean(pdist(B{k,1}))*1; 
            
            else
            Center(k,3) = mean(pdist(B{k,1}))*1;
            
            
            end
end

CFX = (max(locs_Ch1(:,xCol)/pxl))./size(I);
CFY = (max(locs_Ch1(:,yCol)/pxl))./size(I);

center2(:,1)    =   Center(:,2)*CFX(:,1); % Center of the segmented spot in nm
center2(:,2)    =   Center(:,1)*CFY(:,1); % Center of the segmented spot in nm
center2(:,3)    =   Center(:,3);
Center          =   center2;

fprintf('\n -- Particles extracted --\n')

%% Filter out overlapping clusters

Distance = [];center2 = [];

count = 1;

for i = 1:length(Center);
    
    
    % Check if radii overlap
    
            otherClusters = Center(setdiff(1:length(Center),i),:);
    
            for j = 1:length(otherClusters);
    
            Distance(j,1) = sqrt((Center(i,1)-otherClusters(j,1))^2+(Center(i,2)-otherClusters(j,2))^2);
    
            if Distance(j,1)>(otherClusters(j,3)*pxl+Center(i,3)*pxl) == 1;
    
            Distance(j,2) = 0;
    
            else
            
            Distance(j,2) = 1;
                
            end
    
      
            end
    
    if sum(Distance(:,2))==0;
        
    center2(count,1) =  Center(i,1);  
    center2(count,2) =  Center(i,2);  
    center2(count,3) =  Center(i,3);
    
    count = count + 1;
    
    else end
        
end

Center = center2;

%% Build box around each Center and copy locs into separate variable -> structure Cent

Cent={}; 
count = 1;
minLength_Ch1 = 20;

for i = 1:length(Center);
    
    vx1 = Center(i,1)+Center(i,3)*pxl;
    vx2 = Center(i,1)-Center(i,3)*pxl;
    vy1 = Center(i,2)+Center(i,3)*pxl;
    vy2 = Center(i,2)-Center(i,3)*pxl;
    
    target_Ch1 = find(locs_Ch1(:,xCol)>vx2 & locs_Ch1(:,xCol)<vx1 & locs_Ch1(:,yCol)>vy2 & locs_Ch1(:,yCol)<vy1);
    
    if length(target_Ch1)>minLength_Ch1 == 1 ;
    
    Cent{count,1} = locs_Ch1(target_Ch1,1:end);
    Cent{count,2} = length(target_Ch1);
    Cent{count,3} = intI(i);
    Cent{count,4} = Particles_WF{i,1};
    
    count = count + 1;
    
    else end
   
end 
    
fprintf('\n -- %f Particles selected from localitaion dataset --\n',length(Cent))

%% Remove duplicates

% all_segmented_Locs_Ch1 = []; sumOfLocsCh1 = 0;
% 
% for i = 1:size(Cent,1);
%     
%     Cent{i,1}(:,end+1) = i; % add the cent ID
%     
%     sumOfLocsCh1 = sumOfLocsCh1 + length(Cent{i,1});  
%     
%     all_segmented_Locs_Ch1 = vertcat(all_segmented_Locs_Ch1, Cent{i,1}(:,1:end));
% 
%     clc; 
%     fprintf(['Copied ' num2str(i) ' of ' num2str(length(Cent))]);
%     
% end
% 
% C_Ch1 = unique(all_segmented_Locs_Ch1,'rows');
% 
% Cent_wo_duplicates = Cent;
% 
% for i = 1:size(Cent,1);
%     
%    Cent_wo_duplicates{i,1} = C_Ch1(C_Ch1(:,end)==i, 1:end);
%  
%    clc; 
%    fprintf(['Cleaned ' num2str(i) ' of ' num2str(length(Cent))]);
%    
% end
% 
% ratioCh1 = length(C_Ch1)/length(all_segmented_Locs_Ch1)     % removed duplicates
% Ch1_fromTotal = sumOfLocsCh1/length(locs_Ch1)               % from all los
% 
% fprintf('\n -- Duplicates removed --\n');

%% Overlay with Widefield image and plot correlations

Cent_wo_duplicates = Cent;

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

% Plot for each Particle (1) the integrate intensity vs (2) the nbr of locs 

figure('Position',[400 100 300 300],'name','# of Locs vs. GFP Intensity');

scatter(cell2mat(Cent_wo_duplicates(:,2)),cell2mat(Cent_wo_duplicates(:,3)),5,'filled','r');hold on;
xlabel('Nbr of locs Ch1');
ylabel('Ch1 WF int intensity');
box on;
axis square;

cd(savepath)
save(savename,'Cent','-v7.3');

fprintf('\n -- Extracted centrioles saved --\n')

% clear, clc, close all
% 
% end

%% Combine each FOV into single file

clear, clc

all = {};

for i = [1,2,3,4];

load(['a1_AF647_Malk' num2str(i) '_extractedParticles.mat'])

all = vertcat(Cent,all);

clc
fprintf([' Done FOV ' num2str(i)])

end

save('Laine_Data_AF647_Malk_extractedParticles.mat','all','-v7.3');


fprintf(' - Finished - ');
