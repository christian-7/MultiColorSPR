function [Cent] = extractParticles_1C(ICh1,locs_Ch1,minLength_Ch1,B,pxl); 

% Extract particles

xCol = 1;
yCol = 2;

intI  = [];

for i = 1:length(B);
    
    intI(i,1)   = sum(sum(ICh1(min(B{i,1}(:,1)):max(B{i,1}(:,1)),min(B{i,1}(:,2)):max(B{i,1}(:,2)))));
    
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

Center=[];

for k=1:length(B)
        
            boundary    = B{k};
            Center(k,1) = (((max(B{k,1}(:,1))-min(B{k,1}(:,1)))/2)+min(B{k,1}(:,1)))*(pxl);             % Center of the segemented spot in nm
            Center(k,2) = (((max(B{k,1}(:,2))-min(B{k,1}(:,2)))/2)+min(B{k,1}(:,2)))*(pxl);             % Center of the segemented spot in nm
            
            if mean(pdist(B{k,1}))>5;
            
            Center(k,3) = mean(pdist(B{k,1}))*1;                                                         % Size of the box, measure the max distance as input for the box size
            
            elseif mean(pdist(B{k,1}))<3;
            
            Center(k,3) = mean(pdist(B{k,1}))*3; 
            
            else
            Center(k,3) = mean(pdist(B{k,1}))*2;
            
            
            end
end

CFX = (max(locs_Ch1(:,xCol)/pxl))./size(ICh1);
CFY = (max(locs_Ch1(:,yCol)/pxl))./size(ICh1);

center2 = [];

center2(:,1)    =   Center(:,2)*CFX(:,1);   % Center of the segmented spot in nm
center2(:,2)    =   Center(:,1)*CFY(:,1);   % Center of the segmented spot in nm
center2(:,3)    =   Center(:,3);            % Dimensions of the box around each ROI
Center          =   center2;

fprintf('\n -- Particles extracted --\n')

% Filter out overlapping clusters

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


fprintf('\n -- Removed overlapping clusters --\n')

% Select points within a circle

% Cent={}; 
% count = 1;
% minLength_Ch1 = 20; minLength_Ch2 = 100;
% 
% for i = 1:length(center2);
%     
%     tic
% 
% idx_Ch1 = rangesearch([locs_Ch1(:,xCol),locs_Ch1(:,yCol)],[center2(i,1),center2(i,2)],center2(i,3)*pxl); 
% idx_Ch2 = rangesearch([locs_Ch2(:,xCol),locs_Ch2(:,yCol)],[center2(i,1),center2(i,2)],center2(i,3)*pxl); 
% 
% if length(idx_Ch1{1,1})>minLength_Ch1 == 1 & length(idx_Ch1{1,1})>minLength_Ch2 == 1;
% 
%     Cent{count,1} = locs_Ch1(transpose(idx_Ch1{1,1}),1:end);
%     Cent{count,2} = length(transpose(idx_Ch1{1,1}));
%     Cent{count,3} = intI(i);
%     Cent{count,4} = Particles_WF{i,1};
%     
%     Cent{count,5} = locs_Ch2(target_Ch2,1:end);
%     Cent{count,6} = length(target_Ch2);
%     Cent{count,7} = intI2(i);
%     Cent{count,8} = Particles_WF2{i,1};
%     
% else end
% 
% clc; 
% fprintf(['Done ' num2str(i) ' of ' num2str(length(center2)) ' in ' num2str(toc) ' sec ' ]);
% 
% end
% 
% fprintf('\n -- %f Particles selected from localitaion dataset --\n',length(Cent))

% Build box around each Center and copy locs into separate variable -> structure Cent

Cent            = {}; 
count           = 1;

for i = 1:length(Center);
    
    vx1 = Center(i,1)+Center(i,3)*pxl;
    vx2 = Center(i,1)-Center(i,3)*pxl;
    vy1 = Center(i,2)+Center(i,3)*pxl;
    vy2 = Center(i,2)-Center(i,3)*pxl;
    
    target_Ch1 = find(locs_Ch1(:,xCol)>vx2 & locs_Ch1(:,xCol)<vx1 & locs_Ch1(:,yCol)>vy2 & locs_Ch1(:,yCol)<vy1);

    if length(target_Ch1)>minLength_Ch1 == 1;
    
    Cent{count,1} = locs_Ch1(target_Ch1,1:end);
    Cent{count,2} = length(target_Ch1);
    Cent{count,3} = intI(i);
    Cent{count,4} = Particles_WF{i,1};
    
    count = count + 1;
    
    else end
   
end 
    
fprintf('\n -- %f Particles selected from localitaion dataset --\n',length(Cent))

% Overlay with Widefield image and plot correlations

Cent_wo_duplicates = Cent;

% the coordinates need be backtransformed into pxl coordinates
% 1. divide by correction factor
% 2. divide trough pxl size

f1 = figure('Position',[150 150 400 400],'NumberTitle','off','name',['Extracted Particles on WF']);
imshow(imadjust(ICh1)); hold on;

for i = 1:size(Cent_wo_duplicates,1);
    
CentO=[];
CentO(:,1) = Cent_wo_duplicates{i,1}(:,xCol)/CFX(:,1);
CentO(:,2) = Cent_wo_duplicates{i,1}(:,yCol)/CFY(:,1);

    
cmap = parula(length(Cent_wo_duplicates));  % Creates a 6-by-3 set of colors from the HSV colormap
    
scatter(CentO(:,1)/pxl,CentO(:,2)/pxl,1,cmap(randi([1 length(Cent_wo_duplicates)],1,1),1:3));
    
hold on;
end


f3 = figure('Position',[400 100 300 300],'NumberTitle','off','name','# of Locs vs. WF Intensity');

scatter(cell2mat(Cent_wo_duplicates(:,2)),cell2mat(Cent_wo_duplicates(:,3)),5,'filled','r');hold on;
xlabel('Nbr of localizations');
ylabel('WF integrated intensity');
box on;
axis square;


end