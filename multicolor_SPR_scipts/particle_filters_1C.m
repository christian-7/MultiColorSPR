% Input data from the particle segmentation

% For 2C Data

% 1 - locs              Channel 1
% 2 - number of locs in Channel 1
% 3 - int Intensity     Channel 1
% 4 - cropped WF ROI    Channel 1
% 5 - locs              Channel 2
% 6 - number of locs in Channel 2
% 7 - int Intensity     Channel 2
% 8 - cropped WF ROI    Channel 2

% For 1C Data

% 1 - locs              Channel 1
% 2 - number of locs in Channel 1
% 3 - int Intensity     Channel 1
% 4 - cropped WF ROI    Channel 1


savename = '2018-04-27_humanCent_Cep164_Cep152_extractedParticles_DBSCAN_filtered.mat';

%% Filter by the number of locs per ROI
clc
Cent = all;

count = 0;
Cent_filt = {};

for i = 1:length(Cent);
    
    NbrOfLocs(i,1) = length(Cent{i,1});
    
if isempty(Cent{i,1}) == 1;

elseif length(Cent{i,1})>50 & length(Cent{i,1})<30000;
      
count = count+1;    
    
Cent_filt{count,1} = Cent{i,1}; 
% Cent_filt{count,2} = Cent{i,2};
% Cent_filt{count,3} = Cent{i,3};

else end

end

figure
hist(NbrOfLocs,50);
xlabel('Number of localizations');
xlabel('Count');
title(['Median = ' num2str(median(NbrOfLocs))])

fprintf([num2str(size(Cent_filt,1)/size(Cent,1)) '  left after filtering'])

%% Vizualize in 3D

i = 122;

figure
scatter3(Cent_filt{i,1}(:,1)-min(Cent_filt{i,1}(:,1)),Cent_filt{i,1}(:,2)-min(Cent_filt{i,1}(:,2)),Cent_filt{i,1}(:,12),1)


%% Filter by WF intensity (i.e. number of molecules)

Numbr_of_Molecules = [];

for i = 1:length(all);

Numbr_of_Molecules(i,1) = (all{i,3}/8500)*50;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Cent_filt = {};
count = 1;
for i = 1:length(all);

if ((all{i,3}/8500)*50)<1500; 
    
Cent_filt{count,1} = all{i,1};
Cent_filt{count,2} = all{i,2};
Cent_filt{count,3} = all{i,3};

count = count+1;   

else end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


figure('Position',[300 500 1000 300])    

subplot(1,2,1)    
bins = 1 : 1e4: 1e6;
h2 = hist(cell2mat(all(:,2)),bins);
bar(bins, h2/sum(h2));
xlabel('Int Intensity');
ylabel('frequency');
title(['selected particles: ' num2str(length(Cent_filt))])
box on;

subplot(1,2,2)

bins = 1 : 50: 5000;
h1 = hist(Numbr_of_Molecules,bins);
bar(bins, h1/sum(h1));
xlabel('number of molecules');
ylabel('frequency');
title(['selected particles: ' num2str(length(Cent_filt))])
box on;


%% NN filter

x=1; y=2;

for j = 505;
    
    NN = rangesearch(Cent_filt{j,1}(:,x:y),Cent_filt{j,1}(:,x:y),50);
    
end

NofN = [];

for i = 1:length(NN);
    
    NofN(i,1) = length(NN{i,1});

end

minNN = 50;

figure
scatter(Cent_filt{j,1}(:,x)/1000,Cent_filt{j,1}(:,y)/1000,10,'k');hold on;

scatter(Cent_filt{j,1}(NofN>minNN,x)/1000,Cent_filt{j,1}(NofN>minNN,y)/1000,1,'o','red');

%% FRC resolution

close all

Cent_ID = 10;

pixelsize = 107;

coords      = [];
coords(:,1) = (Cent_filt{Cent_ID,1}(:,1) - min(Cent_filt{Cent_ID,1}(:,1)))/pixelsize;
coords(:,2) = (Cent_filt{Cent_ID,1}(:,2) - min(Cent_filt{Cent_ID,1}(:,2)))/pixelsize;;
coords(:,3) = Cent_filt{Cent_ID,1}(:,3);


superzoom = 10;
szx = superzoom * round(max(coords(:,1))-min(coords(:,1)))*1.5;
szy = superzoom * round(max(coords(:,2))-min(coords(:,2)))*1.5;

im = binlocalizations(coords, szx, szy, superzoom);
h=dipshow(im);
dipmapping(h,[0 10],'colormap',hot)

%% compute resolution

fprintf('\n -- computing resolution --\n')
[res_value, ~, resH, resL] = postoresolution(coords, szx, superzoom); % in super-resolution pixels
fprintf('resolution value %2.1f +- %2.2f [px]\n', res_value, (resL-resH)/2);
fprintf('resolution value %2.1f +- %2.2f [nm]\n', res_value*pixelsize/superzoom, (resL-resH)/2*pixelsize/superzoom);

% compute FRC curve
fprintf('\n -- computing FRC curve--\n')
[~,frc_curve] = postoresolution(coords, szx, superzoom); 
figure;
qmax = 0.5/(pixelsize/superzoom);
plot(linspace(0,qmax*sqrt(2), length(frc_curve)), frc_curve,'-')
xlim([0,qmax])
hold on
plot([0 qmax],[1/7 1/7],'r-');
plot([0 qmax],[0 0],'k--'); hold off
xlabel('spatial frequency (nm^{-1})')
ylabel('FRC')
title('Fourier Ring Correlation curve')


%% compute resolution (averaged over 20 runs)

fprintf('\n -- computing resolution averaged over 20 random block splits --\n')
[res_value, ~, resH, resL] = postoresolution(coords, szx, superzoom, 500,[], 20); % in super-resolution pixels
fprintf('res value %2.1f +- %2.2f [px]\n', res_value, (resL-resH)/2);
fprintf('res value %2.1f +- %2.2f [nm]\n', res_value*pixelsize/superzoom, (resL-resH)/2*pixelsize/superzoom);


%%  compute resolution as a function of frame time (takes ~1-2min.)

fprintf('\n -- computing resolution as a function of time for in 25 steps--\n')
tfrac = 25;
[~,~,~,~,resT] = postoresolution(coords, szx, superzoom, 500, tfrac); % in super-resolution pixels
figure;
plot(linspace(0,1,tfrac),resT*pixelsize/superzoom,'x-')
xlabel('time fraction')
ylabel('Resolution (nm)')
title('Resolution as a function of total number of frames')

%% Filter the localizations

% 1   - x [nm]
% 2   - y [nm]
% 3   - frame
% 4   - uncertainty [nm]
% 5   - intensity [photon]
% 6   - offset [photon]
% 7   - loglikelihood
% 8   - sigma_x [nm]
% 9   - sigma_y [nm]
% 10  - dx
% 11  - dy
% 12  - z[nm]
% 13  - Particle ID from segmentation

% 14  - Channel ID
% 15  - Cluster ID

% Filter parameters [Ch1, Ch2]

minFrame            = 10000;
MinPhotons          = 300;
Maxuncertainty      = 25;
Minsigma            = 90;
Maxsigma            = 150;

xCol = 1; yCol = 2; frameCol = 3; uncCol = 4; photonCol = 5; LLCol = 7; sigmaCol = 8; zCol = 12;

for i = 1:length(Cent_filt)
        
filter_Ch1              = [];
filter_Ch1              = find(Cent_filt{i,1}(:,photonCol) > MinPhotons & Cent_filt{i,1}(:,uncCol) < Maxuncertainty & Cent_filt{i,1}(:,frameCol) > minFrame & ... 
                               Cent_filt{i,1}(:,sigmaCol) > Minsigma & Cent_filt{i,1}(:,sigmaCol) < Maxsigma);

Cent_filt{i,1}          = Cent_filt{i,1}(filter_Ch1,1:end);
end

clc
display('Localizations filtered');


%% DBSCAN particle size filter

tic
DBSCAN_filtered = {};

for m = 1:length(Cent_filt);
    
% [DBSCAN_res] = DBSCAN_batch(dataDBS,minLength);
%  DBSCAN_res[locResults, Rg, Ecc]

[DBSCAN_filtered_temp] = DBSCAN_batch(Cent_filt{m,1},50,10000);

if isempty(DBSCAN_filtered_temp)==1;
else

DBSCAN_filtered = vertcat(DBSCAN_filtered,DBSCAN_filtered_temp);
end

clear DBSCAN_filtered_temp

clc
X = [' Finished DBSCAN ',num2str(m),' of ',num2str(length(Cent_filt)),];
disp(X)

end

save(savename,'DBSCAN_filtered','-v7.3');

fprintf(' -- DBSCAN computed in %f sec -- \n',toc)

%%  Test DBSCAN particle size Filter

tic
clc, close all

m = 3; % Cent ID

fprintf('\n -- DBSCAN started --\n')
x = 1; y = 2;
DBSCAN_filtered = {};

% Find out if the data was processed in bstore or TS

dataDBS      = [];
dataDBS(:,1) = Cent_filt{m,1}(:,1); % x in mum
dataDBS(:,2) = Cent_filt{m,1}(:,2); % y in mum


if isempty(dataDBS)
   Cent_filt{m,4} = [];
else

% Run DBSCAN on each particle 

k   = 10;                                                  % minimum number of neighbors within Eps
Eps = 15;                                                   % minimum distance between points, nm

[class,type]=DBSCAN(dataDBS,k,Eps);                         % uses parameters specified at input
class2=transpose(class);                                    % class - vector specifying assignment of the i-th object to certain cluster (m,1)
type2=transpose(type);                                      % (core: 1, border: 0, outlier: -1)

coreBorder = [];
coreBorder = find(type2 >= 0);

subset          = [];
subset          = Cent_filt{m,1}(coreBorder,1:end);
subset(:,end+1) = class2(coreBorder);


subsetP = [];

subsetP(:,1)    = dataDBS(coreBorder,1);
subsetP(:,2)    = dataDBS(coreBorder,2);
subsetP(:,3)    = class2(coreBorder);

figure('Position',[700 600 1000 300])
subplot(1,3,1)
scatter(dataDBS(:,1),dataDBS(:,2),1);
title('Raw Data')
axis on
axis([min(dataDBS(:,1)) max(dataDBS(:,1)) min(dataDBS(:,2)) max(dataDBS(:,2))])
box on

subplot(1,3,2)
scatter(subsetP(:,1),subsetP(:,2),1,mod(subsetP(:,3),10))
title('identified Clusters')
axis on
axis([min(dataDBS(:,1)) max(dataDBS(:,1)) min(dataDBS(:,2)) max(dataDBS(:,2))])
box on

% Select only the largest cluster(s)

if isempty(subset);
else

ClusterLength = [];

for i = 1:max(subset(:,end));           % find the i-th cluster
    
    vx = find(subset(:,end)==i);
    
    if length(vx)>100;
        
    DBSCAN_filtered{length(DBSCAN_filtered)+1,1} = subset(vx,1:end);   
    
    subplot(1,3,3)
    scatter(DBSCAN_filtered{length(DBSCAN_filtered),1}(:,1),DBSCAN_filtered{length(DBSCAN_filtered),1}(:,2),1,'k');hold on;
    title('selected Clusters')
    axis on
    axis([min(dataDBS(:,1)) max(dataDBS(:,1)) min(dataDBS(:,2)) max(dataDBS(:,2))])
    box on
    
    else end
   
end


end

end

fprintf(' -- DBSCAN computed in %f sec -- \n',toc)

%% Compute FRC for all particles

rmpath('D:\Christian\Quantitative_imaging\FRCresolution_software\FRCresolution_software\matlabdistribution\FRCresolutionfunctions');
addpath('D:\Christian\Quantitative_imaging\FRCresolution_software\FRCresolution_software\matlabdistribution\FRCresolutionfunctions');

pixelsize = 106; superzoom = 10; tic;

for i = 1:length(DBSCAN_filtered);  

coords      = [];
coords(:,1) = (DBSCAN_filtered{i,1}(:,1) - min(DBSCAN_filtered{i,1}(:,1)))/pixelsize;
coords(:,2) = (DBSCAN_filtered{i,1}(:,2) - min(DBSCAN_filtered{i,1}(:,2)))/pixelsize;
coords(:,3) =  DBSCAN_filtered{i,1}(:,3) - min(DBSCAN_filtered{i,1}(:,3));

szx = superzoom * round(max(coords(:,1))-min(coords(:,1)))*1.5;
szy = superzoom * round(max(coords(:,2))-min(coords(:,2)))*1.5;

% %% compute resolution as a


%[res_value, ~, resH, resL] = postoresolution(coords, szx, superzoom);                       % in super-resolution pixels

try
    
[res_value, ~, resH, resL] = postoresolution(coords, szx, superzoom, 500,[], 5); % in super-resolution pixels

catch
    
    DBSCAN_filtered{i,4} = NaN;

continue
end

DBSCAN_filtered{i,4} = res_value*pixelsize/superzoom; 

clc; 
X = [' Calculated ',num2str(i),' of ',num2str(length(DBSCAN_filtered)),];
clc;disp(X)

end

fprintf(' -- FRC computed in %f sec -- \n',toc)

save(savename,'DBSCAN_filtered','-v7.3');

%% Filter out NaN rows

Temp = [];
RowsToDelete = [];

for i = 1: length(DBSCAN_filtered)
    
    if isnan(DBSCAN_filtered{i,4}) == 1;
    
    RowsToDelete = vertcat(RowsToDelete,i);    
               
    elseif isempty(DBSCAN_filtered{i,4}) == 1;
    
    RowsToDelete = vertcat(RowsToDelete,i);     
        
    end
    
end

[Temp,ps] = removerows(DBSCAN_filtered,'ind',[RowsToDelete]);

DBSCAN_filtered = Temp;
clear Temp

toPrint = [' -- Cleaned DBSCAN filtered.  ' num2str(length(RowsToDelete)) ' Particles were filtered out --'];

disp(toPrint);

%% Compute Hollowness 

% DBSCAN_filtered=Cep152_all_filtered;

tic

for i = 1:length(DBSCAN_filtered);

[MeanH, StdH, MinH, MaxH] = calculate_Hollowness(DBSCAN_filtered{i,1});

DBSCAN_filtered{i,5} = MeanH;
DBSCAN_filtered{i,6} = StdH;
DBSCAN_filtered{i,7} = MinH;
DBSCAN_filtered{i,8} = MaxH;

end

clc
X = [' -- Calculated Hollowness descriptors in ', num2str(toc),' sec -- '];
disp(X)

%% Compute Circularity Ratio 


% C1 = As/Ac = (Area of a shape)/(Area of circle)
% where circle has the same perimeter

tic

for i = 1:length(DBSCAN_filtered);

[CircRatio] = calculate_Cicularity(DBSCAN_filtered{i,1});

DBSCAN_filtered{i,9} = CircRatio;

end

clc

X = [' -- Calculated Circularity Ratio in ', num2str(toc),' sec -- '];
disp(X)

line = ['locResults, Rg, Ecc, FRC, MeanH, StdH, MinH, MaxH, CircRatio'];
h = regexp(line, ',', 'split' );

save(savename,'DBSCAN_filtered');

%% Plot Descriptors in subplots

close all

figure('Position',[100 100 1000 900])

subplot(3,3,1)
hist(cell2mat(DBSCAN_filtered(:,2)),30);
title('Radius of Gyration');
box on

subplot(3,3,2)
hist(cell2mat(DBSCAN_filtered(:,3)),30);
title('Eccentricity');
box on

subplot(3,3,3)
scatter(cell2mat(DBSCAN_filtered(:,2)),cell2mat(DBSCAN_filtered(:,3)),'.');
title('Rg vs Ecc');
xlabel('Radius of gyrration')
ylabel('Eccentricity')
box on

subplot(3,3,4)
hist(cell2mat(DBSCAN_filtered(:,4)),30);
title(['FRC resolution, Median = ', num2str(median(cell2mat(DBSCAN_filtered(:,4))))]);
box on

subplot(3,3,5)
hist(cell2mat(DBSCAN_filtered(:,5)),30);
title(['Mean Hollowness']);
box on

subplot(3,3,6)
hist(cell2mat(DBSCAN_filtered(:,6)),30);
title(['Std Hollowness']);
box on

subplot(3,3,7)
scatter(cell2mat(DBSCAN_filtered(:,7)),cell2mat(DBSCAN_filtered(:,8)),'.');
title('Min Hollown vs Max Hollown');
xlabel('Min Hollowness')
ylabel('Max Hollowness')
box on

subplot(3,3,8)
hist(cell2mat(DBSCAN_filtered(:,9)),30);
title('Circularity');
box on

subplot(3,3,9)
scatter(cell2mat(DBSCAN_filtered(:,5)),cell2mat(DBSCAN_filtered(:,6)),'.');
title('Mean vs Std');
xlabel('Mean Hollowness')
ylabel('Std Hollowness')
box on

%% Filter Top Views

close all

count = 0;
Cent_filt_2 = {};
NbrOfLocs = [];

% First filter by length

for i = 1:length(DBSCAN_filtered);
    
NbrOfLocs(i,1) = length(DBSCAN_filtered{i,1});

if length(DBSCAN_filtered{i,1})>100 & length(DBSCAN_filtered{i,1})<10000;
   
count = count+1;    
    
Cent_filt_2{count,1} = DBSCAN_filtered{i,1}; 
Cent_filt_2{count,2} = DBSCAN_filtered{i,2};
Cent_filt_2{count,3} = DBSCAN_filtered{i,3};
Cent_filt_2{count,4} = DBSCAN_filtered{i,4};
Cent_filt_2{count,5} = DBSCAN_filtered{i,5}; 
Cent_filt_2{count,6} = DBSCAN_filtered{i,6};
Cent_filt_2{count,7} = DBSCAN_filtered{i,7};
Cent_filt_2{count,8} = DBSCAN_filtered{i,8};
Cent_filt_2{count,9} = DBSCAN_filtered{i,9};

else end

end

% Second filter by Rg, Ecc and FRC

select1 = [];
select1 = find(     (cell2mat(Cent_filt_2(:,2))>50)     & ...    % Rg 
                    (cell2mat(Cent_filt_2(:,2))<200)    & ...    % Rg
                    (cell2mat(Cent_filt_2(:,3))>1)    & ...    % Ecc
                    (cell2mat(Cent_filt_2(:,3))<3)    & ...    % Ecc
                    (cell2mat(Cent_filt_2(:,9))>0.8)    & ...    % Circularity
                    (cell2mat(Cent_filt_2(:,9))<0.96)    & ...    % Circularity
                    (cell2mat(Cent_filt_2(:,5))>100)    & ...    % Mean Hollowness
                    (cell2mat(Cent_filt_2(:,5))<200)    & ...    % Mean Hollowness
                     cell2mat(Cent_filt_2(:,4))<100);          % FRC
                     

Cent_selected = {};

for i = 1:length(select1);  
    
Cent_selected{i,1} = Cent_filt_2{select1(i),1};
Cent_selected{i,2} = Cent_filt_2{select1(i),2};
Cent_selected{i,3} = Cent_filt_2{select1(i),3};
Cent_selected{i,4} = Cent_filt_2{select1(i),4};

end

X = [' -- Selected ', num2str(length(Cent_selected)),' of ' ,num2str(length(DBSCAN_filtered)) ];
disp(X)



%% Filter by length, Rg, Ecc and FRC

close all

count = 0;
Cent_filt_2 = {};
NbrOfLocs = [];

% First filter by length

for i = 1:length(DBSCAN_filtered);
    
NbrOfLocs(i,1) = length(DBSCAN_filtered{i,1});

if length(DBSCAN_filtered{i,1})>100 & length(DBSCAN_filtered{i,1})<10000;
   
count = count+1;    
    
Cent_filt_2{count,1} = DBSCAN_filtered{i,1}; 
Cent_filt_2{count,2} = DBSCAN_filtered{i,2};
Cent_filt_2{count,3} = DBSCAN_filtered{i,3};
Cent_filt_2{count,4} = DBSCAN_filtered{i,4};

else end

end

% Second filter by Rg, Ecc and FRC

select1 = [];
select1 = find(     (cell2mat(Cent_filt_2(:,2))>10)    & ...   % Rg 
                    (cell2mat(Cent_filt_2(:,2))<50)   & ...   % Rg
                    (cell2mat(Cent_filt_2(:,3))>1)    & ...   % Ecc
                    (cell2mat(Cent_filt_2(:,3))<3)    & ...   % Ecc
                     cell2mat(Cent_filt_2(:,4))<100);          % FRC
                     

Cent_selected = {};

for i = 1:length(select1);  
    
Cent_selected{i,1} = Cent_filt_2{select1(i),1};
Cent_selected{i,2} = Cent_filt_2{select1(i),2};
Cent_selected{i,3} = Cent_filt_2{select1(i),3};
Cent_selected{i,4} = Cent_filt_2{select1(i),4};

end

X = [' -- Selected ', num2str(length(Cent_selected)),' of ' ,num2str(length(DBSCAN_filtered)) ];
disp(X)



%% Vizualize in 3D

i = 56;

figure
scatter3(Cent_selected{i,1}(:,1)-min(Cent_selected{i,1}(:,1)),Cent_selected{i,1}(:,2)-min(Cent_selected{i,1}(:,2)),Cent_selected{i,1}(:,12),1)



%% Render the filtered images 

pxlsize = 10;

current_dir = pwd;
[status, message, messageid] = rmdir('rendered', 's')
mkdir rendered
cd('rendered')

% Determine the box size form the largest particle

im_size = []; x = 1; y = 2;

for i=1:length(Cent_selected);
    
        
im_size(i,1) = round((max(Cent_selected{i,1}(:,y))-min(Cent_selected{i,1}(:,y)))/pxlsize);
im_size(i,2) = round((max(Cent_selected{i,1}(:,x))-min(Cent_selected{i,1}(:,x)))/pxlsize);
        
                
end

for i = 1:length(Cent_selected);

% Filter the locs

subsetLL = Cent_selected{i,1};

% subsetLL = [];
% subsetLL = locs(filter,1:end);

% Filter the locs
    
        heigth = round((max(subsetLL(:,y)) - min(subsetLL(:,y)))/pxlsize);
        width  = round((max(subsetLL(:,x)) - min(subsetLL(:,x)))/pxlsize);
        
        rendered = hist3([subsetLL(:,y),subsetLL(:,x)],[heigth width]);
        empty    = zeros(round(max(max(im_size))*1.5),round(max(max(im_size))*1.5));

        size_DC    = size(empty);
        center_X   = round(size_DC(2)/2);
        center_Y   = round(size_DC(1)/2);

        empty(round(center_Y-heigth/2):(round(center_Y-heigth/2))+heigth-1,round(center_X-width/2):(round(center_X-width/2))+width-1) = rendered;

        name32rendered  = ['ID' num2str(pxlsize) '_' num2str(i) '.tiff'];


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

end

cd ..

disp([' -- Images Saved --']);

%% Select best images from Montage

ID = [6,8,31,47,75,76,60,66,85,93,101,138,155,169,230,275,272];  
ID = [34,35,26,27,57,61,82,97,101,138,158,201,241,280,365,372,400,401,399,386,416,461,485,511,512,515,516];
ID = [5,12,11,18,20,21,36,33,32,31,80,78,115,175,183,230,277,374];
ID = [1,5,6,16,25,28,38,49,41,58,95,94,81,80,98,97,101,126,179,208,225,244,240,236,232,229,248,250,266,270];
ID = [38,49,94,98,208,229,232,244,266,250,270,314];
ID = [16,38,49,94,179,174,204,208,229,232,244,250,248,270,314];
ID = [3,4,14,34,28,26,19,64,56,74,80,165,167,169,172,176,203,190];
  
Particles_Selected = {};

for i = 1:length(ID);
    
    
Particles_Selected{i,1} = Cent_selected{ID(i),1}; % X,Y,Z

Particles_Selected{i,2} = ID(i);

end


%% Use ImageJ to create, blur and save the Montage
% 
% javaaddpath 'C:\Program Files\MATLAB\R2016b\java\mij.jar'
% javaaddpath 'C:\Program Files\MATLAB\R2016b\java\ij-1.51g.jar'
% Mij.start;
% 
% % cd('rendered');

string1 = ['Image Sequence...']; string2 = ['open=' num2str('rendered') ' file=ID sort'];

MIJ.run(string1, string2);
MIJ.run('Gaussian Blur...','sigma=1 stack');

string1 = ['Make Montage...']; string2 = ['columns=' num2str(round(sqrt(length(Cent_selected)))) ' rows=' num2str(round(sqrt(length(Cent_selected))))  ' scale=1'];

MIJ.run(string1, string2);
MIJ.run('Enhance Contrast', 'saturated=0.35');
MIJ.run('Save', 'Tiff..., path=[Z:\\Christian-Sieben\\data_HTP\\2018-04-27_humanCent_Cep152\\analysis\\Cep63_4.tif]');
MIJ.run('Close All')

disp([' -- Montage Saved --']);

%% First Classification - TopOrSide / Unclassified

% This classifier uses the function waitforbuttonpress

% Start this after the density filtering

Cent_selected = DBSCAN_filtered(1:300,1:end);

Cent = Cent_selected;

Top                 = {};
unclassified        = {};
response = [];
          
% Top = {};
% Side= {};

clc, close all

for i = 1:length(Cent);

            
        figure('Position',[500 300 300 300]);
        
        scatter(Cent{i,1}(:,1)-min(Cent{i,1}(:,1)),Cent{i,1}(:,2)-min(Cent{i,1}(:,2)),1,'filled','black');
        title(['ROI :', num2str(i) ' Particle :', num2str(j)],'FontSize',9);
        axis([0 max(Cent{i,1}(:,1))-min(Cent{i,1}(:,1)) 0 max(Cent{i,1}(:,2))-min(Cent{i,1}(:,2))])
        box on
        axis on  
        
        fprintf('Mouse --> Top or Side');
        fprintf('\n');
        fprintf('\n');
        fprintf('Key --> unclassified');
                
        w = waitforbuttonpress;                                     % 0 if it detects a mouse button click / 1 if it detects a key press
        
        if w == 0;  
            
        Top = vertcat(Top,Cent{i,1});              % Put on the shown cluster into the new variable  
        response(i,1) = 1; 
        disp('Top')
        
        else
            
        unclassified = vertcat(unclassified,Cent{i,1});        % Put on the shown cluster into the new variable 
        response(i,1) = 2;
        disp('Side')
        end


    close all  , clc     

       
end
%% First Classification - Top / Side / Unclassified

% This classifier uses the function input
% Start this after the density filtering

% Cent_selected = Cent_filt(1:300,1:end);

Cent_selected = DBSCAN_filtered(1:300,1:end);

Cent = Cent_selected;

Top             = {};
Side            = {};
Unclassified    = {};
response        = []; % 1>Top, 2>Side, 3>Unclassified

clc, close all

for i = 1:length(Cent);

            
        figure('Position',[500 300 300 300]);
        
        scatter(Cent{i,1}(:,1)-min(Cent{i,1}(:,1)),Cent{i,1}(:,2)-min(Cent{i,1}(:,2)),1,'filled','black');
        title(['ROI :', num2str(i) ' Particle :', num2str(j)],'FontSize',9);
        axis([0 max(Cent{i,1}(:,1))-min(Cent{i,1}(:,1)) 0 max(Cent{i,1}(:,2))-min(Cent{i,1}(:,2))])
        box on
        axis on  

        w = input('Waiting for Input: t > Top, s > Side, u > unclassified','s')
                
        if strcmpi(w,'t');  
            
        Top = vertcat(Top,Cent{i,1});              % Put on the shown cluster into the new variable  
        response(i,1) = 1; 
        disp('Top View')
        
        elseif strcmpi(w,'s')
            
        Side = vertcat(Side,Cent{i,1});        % Put on the shown cluster into the new variable 
        response(i,1) = 2;
        disp('Side View')
        
        else 
            
        Unclassified = vertcat(Unclassified,Cent{i,1});        % Put on the shown cluster into the new variable 
        response(i,1) = 3;
        disp('Unclassified')
        
        end


    close all  , clc     

       
end




