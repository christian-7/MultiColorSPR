% Input data from 2C particle segmentation

% Variable Cent

% For 2C Data

% 1 - locs              Channel 1
% 2 - number of locs in Channel 1
% 3 - int Intensity     Channel 1
% 4 - cropped WF ROI    Channel 1
% 5 - locs              Channel 2
% 6 - number of locs in Channel 2
% 7 - int Intensity     Channel 2
% 8 - cropped WF ROI    Channel 2

% Structure of each Cell/Particle
% For 3D

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

% 14  - Channel for DBSCAN
% 15  - Particle ID from segmentation

addpath('/Supplementary_Software/functions/');

savename = 'Cep152_Sas6_extractedParticles_DBSCAN_filtered.mat';

%% Filter by the number of locs per ROI

Cent = all;

count = 0;
Cent_filt = {};

for i = 1:length(Cent);
    
    if isempty(Cent{i,1}) | isempty(Cent{i,5})
    
    else
        
NbrOfLocs(i,1) = length(Cent{i,1}); % Channel 1
NbrOfLocs(i,2) = length(Cent{i,5}); % Channel 2

if length(Cent{i,1})>10 & length(Cent{i,1})<2e4 & length(Cent{i,5})>1 & length(Cent{i,5})<2e4;
   
count = count+1;    
    
Cent_filt{count,1} = Cent{i,1}; 
Cent_filt{count,2} = Cent{i,2};
Cent_filt{count,3} = Cent{i,3};
Cent_filt{count,4} = Cent{i,4};
Cent_filt{count,5} = Cent{i,5};
Cent_filt{count,6} = Cent{i,6};
Cent_filt{count,7} = Cent{i,7};
Cent_filt{count,8} = Cent{i,8};

else end

    end
end

figure
hist(NbrOfLocs,50);
xlabel('Number of localizations');
xlabel('Count');
title(['Median = ' num2str(median(NbrOfLocs))])
legend('Channel 1','Channel 2');

display([num2str(length(Cent_filt)/length(Cent)) '  left after filtering'])

%% Filter the localizations and generate combined variable for DBSCAN

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

minFrame            = [100,100];
MinPhotons          = [500, 200];
Maxuncertainty      = [25, 25];

xCol = 1; yCol = 2; frameCol = 3; uncCol = 4; photonCol = 5; LLCol = 7; sigmaCol = 8; zCol = 12;

Cent_filt_2C = {}; % New variable combining both datasets for each ROI

for i = 1:length(Cent_filt)
        
Cent_filt{i,1}(:,size(Cent{1,1},2)+1) = 1; % new channel ID variable
filter_Ch1              = [];
filter_Ch1              = find(Cent_filt{i,1}(:,photonCol) > MinPhotons(1) & Cent_filt{i,1}(:,uncCol) < Maxuncertainty(1) & Cent_filt{i,1}(:,frameCol) > minFrame(1));

Cent_filt{i,5}(:,size(Cent{1,1},2)+1) = 2; % new channel ID variable
filter_Ch2              = [];
filter_Ch2              = find(Cent_filt{i,5}(:,photonCol) > MinPhotons(2) & Cent_filt{i,5}(:,uncCol) < Maxuncertainty(2) & Cent_filt{i,5}(:,frameCol) > minFrame(2));

Cent_filt_2C{i,1}       = vertcat(Cent_filt{i,1}(filter_Ch1,1:end),Cent_filt{i,5}(filter_Ch2,1:end));

end

clc
display('Localizations filtered and combined in Cent_filt_2C');


%% DBSCAN particle size filter

% Run the next cell first to find the ebst DBSCAN parameters

% % Output:   1. locs Ch1
%             2. locs Ch2
%             3. Rg Ch1
%             4. Rg Ch2
%             5. Ecc Ch1
%             6. Ecc Ch2

tic

DBSCAN_filtered = {};

for m = 1:length(Cent_filt_2C);
    
[DBSCAN_filtered_temp] = DBSCAN_batch_2C_3D(Cent_filt_2C{m,1},100,50);% dataDBS,minLength_C1,minLength_C2;

DBSCAN_filtered = vertcat(DBSCAN_filtered,DBSCAN_filtered_temp);

clear DBSCAN_filtered_temp

clc
X = [' Finished DBSCAN ',num2str(m),' of ',num2str(length(Cent_filt_2C)),];
disp(X)

end

save(savename,'DBSCAN_filtered','-v7.3');

fprintf(' -- DBSCAN computed in %f sec -- \n',toc)

%%  Test DBSCAN particle size Filter

tic
clc, close all

m = 49; % Cent ID

fprintf('\n -- DBSCAN started --\n')
DBSCAN_filtered = {};

% Find out if the data was processed in bstore or TS

dataDBS      = [];
dataDBS(:,1) = Cent_filt_2C{m,1}(:,1); % x in mum
dataDBS(:,2) = Cent_filt_2C{m,1}(:,2); % y in mum

% Run DBSCAN 

k   = 20; % 40                                                    % minimum number of neighbors within Eps
Eps = 20; % 10                                                   % minimum distance between points, nm

[class,type]=DBSCAN(dataDBS,k,Eps);                         % uses parameters specified at input
class2=transpose(class);                                    % class - vector specifying assignment of the i-th object to certain cluster (m,1)
type2=transpose(type);                                      % (core: 1, border: 0, outlier: -1)

coreBorder = [];
coreBorder = find(type2 >= 0);

subset          = [];
subset          = Cent_filt_2C{m,1}(coreBorder,1:end);
subset(:,end+1) = class2(coreBorder);

subsetP = [];
subsetP(:,1)    = dataDBS(coreBorder,1);
subsetP(:,2)    = dataDBS(coreBorder,2);
subsetP(:,3)    = class2(coreBorder);

figure('Position',[100 600 300 300]) % all data from both channels
scatter(dataDBS(:,1)/1e3,dataDBS(:,2)/1e3,1);
box on

figure('Position',[700 600 1000 300]) % all data from both channels
subplot(1,3,1)
scatter(Cent_filt_2C{m,1}(Cent_filt_2C{m,1}(:,end)==1,1),Cent_filt_2C{m,1}(Cent_filt_2C{m,1}(:,end)==1,2),1,'black'); hold on;
scatter(Cent_filt_2C{m,1}(Cent_filt_2C{m,1}(:,end)==2,1),Cent_filt_2C{m,1}(Cent_filt_2C{m,1}(:,end)==2,2),1,'red'); hold on;
title('Raw Data')
axis on
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

for i = 1:max(subset(:,end));                                               % find the i-th cluster
    
    vx = find(subset(:,end)==i);
    
    if length(vx)>100;
        
    DBSCAN_filtered{length(DBSCAN_filtered)+1,1} = subset(vx,1:end);        % Put the cluster ID in the last column 
    
    subplot(1,3,3)
    scatter(DBSCAN_filtered{length(DBSCAN_filtered),1}(:,1),DBSCAN_filtered{length(DBSCAN_filtered),1}(:,2),1);hold on;
    title('selected Clusters')
    axis on
    axis([min(dataDBS(:,1)) max(dataDBS(:,1)) min(dataDBS(:,2)) max(dataDBS(:,2))])
    box on
    
    else end
   
end
end

figure('Position',[700 600 500 500])

for i = 1:length(DBSCAN_filtered);
    
scatter(DBSCAN_filtered{i,1}(DBSCAN_filtered{i,1}(:,end-1)==1,1),DBSCAN_filtered{i,1}(DBSCAN_filtered{i,1}(:,end-1)==1,2),1,'black');hold on;
scatter(DBSCAN_filtered{i,1}(DBSCAN_filtered{i,1}(:,end-1)==2,1),DBSCAN_filtered{i,1}(DBSCAN_filtered{i,1}(:,end-1)==2,2),1,'red');hold on;

title('Found Particles');
legend('Channel 1', 'Channel 2');
box on; axis square;

end

fprintf(' -- DBSCAN computed in %f sec -- \n',toc)

%% Compute FRC for all particles

% Download FRCresolution_software from http://www.diplib.org/add-ons

rmpath('\FRCresolution_software\FRCresolution_software\matlabdistribution\FRCresolutionfunctions');
addpath('\FRCresolution_software\FRCresolution_software\matlabdistribution\FRCresolutionfunctions');

pixelsize = 106; superzoom = 10; tic;

% Channel 1

for i = 1:length(DBSCAN_filtered);  

coords_C1      = [];
coords_C1(:,1) = (DBSCAN_filtered{i,1}(:,1) - min(DBSCAN_filtered{i,1}(:,1)))/pixelsize;
coords_C1(:,2) = (DBSCAN_filtered{i,1}(:,2) - min(DBSCAN_filtered{i,1}(:,2)))/pixelsize;
coords_C1(:,3) =  DBSCAN_filtered{i,1}(:,4) - min(DBSCAN_filtered{i,1}(:,4));

szx_C1 = superzoom * round(max(coords_C1(:,1))-min(coords_C1(:,1)))*1.5;
szy_C1 = superzoom * round(max(coords_C1(:,2))-min(coords_C1(:,2)))*1.5;

try
    
[res_value_C1, ~, resH_C1, resL_C1] = postoresolution(coords_C1, szx_C1, superzoom, 500,[], 5); % in super-resolution pixels

catch
    
 DBSCAN_filtered{i,7} = NaN;

continue
end

DBSCAN_filtered{i,7} = res_value_C1*pixelsize/superzoom; 

clc; 
X = [' Channel 1: Calculated ',num2str(i),' of ',num2str(length(DBSCAN_filtered)),];
clc;disp(X)

end

% Channel 2

for i = 1:length(DBSCAN_filtered);  

coords_C2      = [];
coords_C2(:,1) = (DBSCAN_filtered{i,2}(:,1) - min(DBSCAN_filtered{i,2}(:,1)))/pixelsize;
coords_C2(:,2) = (DBSCAN_filtered{i,2}(:,2) - min(DBSCAN_filtered{i,2}(:,2)))/pixelsize;
coords_C2(:,3) =  DBSCAN_filtered{i,2}(:,4) - min(DBSCAN_filtered{i,2}(:,4));

szx_C2 = superzoom * round(max(coords_C2(:,1))-min(coords_C2(:,1)))*1.5;
szy_C2 = superzoom * round(max(coords_C2(:,2))-min(coords_C2(:,2)))*1.5;

try
    
[res_value_C2, ~, resH_C2, resL_C2] = postoresolution(coords_C2, szx_C2, superzoom, 500,[], 5); % in super-resolution pixels

catch
    
    DBSCAN_filtered{i,8} = NaN;

continue
end

DBSCAN_filtered{i,8} = res_value_C2*pixelsize/superzoom; 

clc; 
X = [' Channel 2: Calculated ',num2str(i),' of ',num2str(length(DBSCAN_filtered)),];
clc;disp(X)

end

fprintf(' -- FRC computed in %f sec -- \n',toc)

save(savename,'DBSCAN_filtered','-v7.3');

%% Filter out NaN rows

Temp = [];
RowsToDelete = [];

for i = 1: length(DBSCAN_filtered)
    
    if or(isnan(DBSCAN_filtered{i,7}) == 1, isnan(DBSCAN_filtered{i,8})==1);
    
    RowsToDelete = vertcat(RowsToDelete,i);    
               
    elseif or(isempty(DBSCAN_filtered{i,7}) == 1, isempty(DBSCAN_filtered{i,8})==1);
    
    RowsToDelete = vertcat(RowsToDelete,i);     
        
    end
    
end

[Temp,ps] = removerows(DBSCAN_filtered,'ind',[RowsToDelete]);

DBSCAN_filtered = Temp;
clear Temp
clc
toPrint = [' -- Cleaned DBSCAN filtered.  ' num2str(length(RowsToDelete)) ' Particles were filtered out --'];

disp(toPrint);

%% Compute Hollowness 

% DBSCAN_filtered=Cep152_all_filtered;

tic

for i = 1:length(DBSCAN_filtered);
    
    try

[MeanH, StdH, MinH, MaxH] = calculate_Hollowness(DBSCAN_filtered{i,1});

    catch
        
DBSCAN_filtered{i,9} = 0;
DBSCAN_filtered{i,10} = 0;
DBSCAN_filtered{i,11} = 0;
DBSCAN_filtered{i,12} = 0;

        continue
    end

DBSCAN_filtered{i,9} = MeanH;
DBSCAN_filtered{i,10} = StdH;
DBSCAN_filtered{i,11} = MinH;
DBSCAN_filtered{i,12} = MaxH;

end

for i = 1:length(DBSCAN_filtered);

    try
    
[MeanH, StdH, MinH, MaxH] = calculate_Hollowness(DBSCAN_filtered{i,2});

    catch
        
DBSCAN_filtered{i,13} = 0;
DBSCAN_filtered{i,14} = 0;
DBSCAN_filtered{i,15} = 0;
DBSCAN_filtered{i,16} = 0;

        continue
    end
    

DBSCAN_filtered{i,13} = MeanH;
DBSCAN_filtered{i,14} = StdH;
DBSCAN_filtered{i,15} = MinH;
DBSCAN_filtered{i,16} = MaxH;

end

clc
X = [' -- Calculated Hollowness descriptors in ', num2str(toc),' sec -- '];
disp(X)

%% Compute Circularity Ratio 

tic

for i = 1:length(DBSCAN_filtered);
    
    try

[CircRatio] = calculate_Cicularity(DBSCAN_filtered{i,1});

    catch
        
   CircRatio = 0;
   continue
    end

DBSCAN_filtered{i,17} = CircRatio;

end

for i = 1:length(DBSCAN_filtered);

[CircRatio] = calculate_Cicularity(DBSCAN_filtered{i,2});

DBSCAN_filtered{i,18} = CircRatio;

end

clc

X = [' -- Calculated Circularity Ratio in ', num2str(toc),' sec -- '];
disp(X)

%% Compute Rectangularity

tic

for i = 1:length(DBSCAN_filtered);
    
    try

[Rectangularity] = calculate_Rectangularity(DBSCAN_filtered{i,1});

    catch
        
        Rectangularity = 0;
        
        continue
    end

DBSCAN_filtered{i,19} = Rectangularity;

end

for i = 1:length(DBSCAN_filtered);

[Rectangularity] = calculate_Rectangularity(DBSCAN_filtered{i,2});

DBSCAN_filtered{i,20} = Rectangularity;

end

X = [' -- Calculated Rectangularity Ratio in ', num2str(toc),' sec -- '];
disp(X)

%% Fractional Anisotropy

tic

for i = 1:length(DBSCAN_filtered);
    
    try

[FA] = calculate_FA(DBSCAN_filtered{i,1}(:,1),DBSCAN_filtered{i,1}(:,2));

    catch
            FA = 0;
            
            continue
    end


DBSCAN_filtered{i,21} = FA;

end

for i = 1:length(DBSCAN_filtered);

[FA] = calculate_FA(DBSCAN_filtered{i,2}(:,1),DBSCAN_filtered{i,2}(:,2));;

DBSCAN_filtered{i,22} = FA;

end

X = [' -- Calculated FA in ', num2str(toc),' sec -- '];
disp(X)

%% Estimate symmetry along the long axis

tic

for i = 1:length(DBSCAN_filtered);
    
    try

[Sym] = Estimate_Symmetry(DBSCAN_filtered{i,1}(:,1),DBSCAN_filtered{i,1}(:,2));

    catch
            Sym = 0;
            
            continue
    end
    
if isempty(Sym)==1;
    Sym = 0;
else end

DBSCAN_filtered{i,23} = Sym;

end

for i = 1:length(DBSCAN_filtered);
    
    try

[Sym] = Estimate_Symmetry(DBSCAN_filtered{i,2}(:,1),DBSCAN_filtered{i,2}(:,2));

    catch
            Sym = 0;
            
            continue
    end
    
if isempty(Sym)==1;
    Sym = 0;
else end

DBSCAN_filtered{i,24} = Sym;

end

% clean columns

for i = 1:length(DBSCAN_filtered);
    
  if isempty(DBSCAN_filtered{i,23})==1;
    DBSCAN_filtered{i,23} = 0;
  else end  
  
  if isempty(DBSCAN_filtered{i,24})==1;
    DBSCAN_filtered{i,24} = 0;
  else end 

end

X = [' -- Calculated Symmetry in ', num2str(toc),' sec -- '];
disp(X)

%% 2nd Circularity Estimation

tic

for i = 1:length(DBSCAN_filtered);
    
    try

CircEst = Estimate_circularity(DBSCAN_filtered{i,1}(:,1),DBSCAN_filtered{i,1}(:,2));

    catch 
        
        CircEst = 0;
        continue
    end

DBSCAN_filtered{i,25} = CircEst;

end

for i = 1:length(DBSCAN_filtered);

CircEst = Estimate_circularity(DBSCAN_filtered{i,2}(:,1),DBSCAN_filtered{i,2}(:,2));;

DBSCAN_filtered{i,26} = CircEst;

end

X = [' -- Calculated 2nd Circularity Estimate in ', num2str(toc),' sec -- '];
disp(X)

%% Put the data into a new nested structure for clarity

for i = 1:length(DBSCAN_filtered);

Data_DBSCANed.Channel1.locs{i,1} = DBSCAN_filtered{i,1};
Data_DBSCANed.Channel2.locs{i,1} = DBSCAN_filtered{i,2};

Data_DBSCANed.Channel1.Rg{i,1} = DBSCAN_filtered{i,3};
Data_DBSCANed.Channel2.Rg{i,1} = DBSCAN_filtered{i,4};

Data_DBSCANed.Channel1.Ecc{i,1} = DBSCAN_filtered{i,5};
Data_DBSCANed.Channel2.Ecc{i,1} = DBSCAN_filtered{i,6};

Data_DBSCANed.Channel1.FRC{i,1} = DBSCAN_filtered{i,7};
Data_DBSCANed.Channel2.FRC{i,1} = DBSCAN_filtered{i,8};

Data_DBSCANed.Channel1.MeanHo{i,1} = DBSCAN_filtered{i,9};
Data_DBSCANed.Channel1.StdHo{i,1} = DBSCAN_filtered{i,10};
Data_DBSCANed.Channel1.MinHo{i,1} = DBSCAN_filtered{i,11};
Data_DBSCANed.Channel1.MaxHo{i,1} = DBSCAN_filtered{i,12};

Data_DBSCANed.Channel2.MeanHo{i,1} = DBSCAN_filtered{i,13};
Data_DBSCANed.Channel2.StdHo{i,1} = DBSCAN_filtered{i,14};
Data_DBSCANed.Channel2.MinHo{i,1} = DBSCAN_filtered{i,15};
Data_DBSCANed.Channel2.MaxHo{i,1} = DBSCAN_filtered{i,16};

Data_DBSCANed.Channel1.CircRatio{i,1} = DBSCAN_filtered{i,17};
Data_DBSCANed.Channel2.CircRatio{i,1} = DBSCAN_filtered{i,18};

Data_DBSCANed.Channel1.RectRatio{i,1} = DBSCAN_filtered{i,19};
Data_DBSCANed.Channel2.RectRatio{i,1} = DBSCAN_filtered{i,20};

Data_DBSCANed.Channel1.FA{i,1} = DBSCAN_filtered{i,21};
Data_DBSCANed.Channel2.FA{i,1} = DBSCAN_filtered{i,22};

Data_DBSCANed.Channel1.Symmetry{i,1} = DBSCAN_filtered{i,23};
Data_DBSCANed.Channel2.Symmetry{i,1} = DBSCAN_filtered{i,24};

Data_DBSCANed.Channel1.Circularity{i,1} = DBSCAN_filtered{i,25};
Data_DBSCANed.Channel2.Circularity{i,1} = DBSCAN_filtered{i,26};

end

%% Plot Descriptors in subplots

close all

% Channel 1

figure('Position',[100 100 1000 900],'Name','Channel1')

subplot(3,3,1)
histogram(cell2mat(Data_DBSCANed.Channel1.Rg),40,'FaceColor','black');
% title('Radius of Gyration');
xlabel('Rg [nm]')
box on

subplot(3,3,2)
histogram(cell2mat(Data_DBSCANed.Channel1.Ecc),40,'FaceColor','black');
% title('Eccentricity');
xlabel('Ecc [nm]')
box on

subplot(3,3,3)
scatter(cell2mat(Data_DBSCANed.Channel1.Rg),cell2mat(Data_DBSCANed.Channel1.Ecc),5,'filled','k');
% title('Rg vs Ecc');
xlabel('Rg [nm]')
ylabel('Ecc [nm]')
box on

subplot(3,3,4)
histogram(cell2mat(Data_DBSCANed.Channel1.FRC),30,'FaceColor','black');
title(['Median = ', num2str(median(cell2mat(Data_DBSCANed.Channel1.FRC)))]);
xlabel('FRC [nm]')
box on

subplot(3,3,5)
% hist(cell2mat(Data_DBSCANed.Channel1.MeanHo),30);
scatter(cell2mat(Data_DBSCANed.Channel1.MeanHo),cell2mat(Data_DBSCANed.Channel1.StdHo),5,'filled','k');
% title(['Mean Hollowness']);
xlabel('Mean Hollowness')
ylabel('Std Hollowness')
box on

subplot(3,3,6)
% hist(cell2mat(Data_DBSCANed.Channel1.StdHo),30);
scatter(cell2mat(Data_DBSCANed.Channel1.MeanHo),cell2mat(Data_DBSCANed.Channel1.CircRatio),5,'filled','k');
% title(['Mean Hollowness vs. CircRatio']);
xlabel('Mean Hollowness')
ylabel('Circularity')
box on

subplot(3,3,7)
scatter(cell2mat(Data_DBSCANed.Channel1.RectRatio),cell2mat(Data_DBSCANed.Channel1.CircRatio),5,'filled','k');
% title('RectRatio vs CircRatio');
xlabel('Rectangularity')
ylabel('Circularity')
box on

subplot(3,3,8)
scatter(cell2mat(Data_DBSCANed.Channel1.Circularity),cell2mat(Data_DBSCANed.Channel1.CircRatio),5,'filled','k');
% title('Circularity');
xlabel('Circularity 1 (R)')
ylabel('Circularity 2 (P)')
box on

subplot(3,3,9)
scatter(cell2mat(Data_DBSCANed.Channel1.FA),cell2mat(Data_DBSCANed.Channel1.Symmetry),5,'filled','k');
set(gca,'yscale','log')
% title('FA vs Sym');
xlabel('FA')
ylabel('Symmetry')
box on

% Channel 2

figure('Position',[800 100 1000 900],'Name','Channel 2')


subplot(3,3,1)
histogram(cell2mat(Data_DBSCANed.Channel2.Rg),40,'FaceColor','black');
% title('Radius of Gyration');
xlabel('Rg [nm]')
box on

subplot(3,3,2)
histogram(cell2mat(Data_DBSCANed.Channel2.Ecc),40,'FaceColor','black');
% title('Eccentricity');
xlabel('Ecc [nm]')
box on

subplot(3,3,3)
scatter(cell2mat(Data_DBSCANed.Channel2.Rg),cell2mat(Data_DBSCANed.Channel2.Ecc),5,'filled','k');
% title('Rg vs Ecc');
xlabel('Rg [nm]')
ylabel('Ecc [nm]')
box on

subplot(3,3,4)
histogram(cell2mat(Data_DBSCANed.Channel2.FRC),30,'FaceColor','black');
title(['Median = ', num2str(median(cell2mat(Data_DBSCANed.Channel2.FRC)))]);
xlabel('FRC [nm]')
box on

subplot(3,3,5)
% hist(cell2mat(Data_DBSCANed.Channel1.MeanHo),30);
scatter(cell2mat(Data_DBSCANed.Channel2.MeanHo),cell2mat(Data_DBSCANed.Channel2.StdHo),5,'filled','k');
% title(['Mean Hollowness']);
xlabel('Mean Hollowness')
ylabel('Std Hollowness')
box on

subplot(3,3,6)
% hist(cell2mat(Data_DBSCANed.Channel1.StdHo),30);
scatter(cell2mat(Data_DBSCANed.Channel2.MeanHo),cell2mat(Data_DBSCANed.Channel2.CircRatio),5,'filled','k');
% title(['Mean Hollowness vs. CircRatio']);
xlabel('Mean Hollowness')
ylabel('Circularity')
box on

subplot(3,3,7)
scatter(cell2mat(Data_DBSCANed.Channel2.RectRatio),cell2mat(Data_DBSCANed.Channel2.CircRatio),5,'filled','k');
% title('RectRatio vs CircRatio');
xlabel('Rectangularity')
ylabel('Circularity')
box on

subplot(3,3,8)
scatter(cell2mat(Data_DBSCANed.Channel2.Circularity),cell2mat(Data_DBSCANed.Channel2.CircRatio),5,'filled','k');
% title('Circularity');
xlabel('Circularity 1 (R)')
ylabel('Circularity 2 (P)')
box on

subplot(3,3,9)
scatter(cell2mat(Data_DBSCANed.Channel2.FA),cell2mat(Data_DBSCANed.Channel2.Symmetry),5,'filled','k');
set(gca,'yscale','log')
% title('FA vs Sym');
xlabel('FA')
ylabel('Symmetry')
box on

%% Filter by length, Rg, Ecc and FRC 

close all, clc

count = 0;
Cent_selected = {}; CentForTraining = {};

% Choose Filtering parameters [Ch1, Ch2]

MinLength   = [50,200];
MaxLength   = 500;
MinRg       = [5,100]; 
MaxRg       = [100,150];
MinEcc      = [1,1]; 
MaxEcc      = [2.5,2.5];
MaxFRC      = [50,100];


% First filter by length

for i = 1:length(DBSCAN_filtered);
    
if length(DBSCAN_filtered{i,1})>MinLength(1)   == 1        & ... % length Ch1
   length(DBSCAN_filtered{i,1})<MaxLength      == 1        & ... % length Ch1     
   length(DBSCAN_filtered{i,2})>MinLength(2)   == 1        & ... % length Ch2
   DBSCAN_filtered{i,3}>MinRg(1)               == 1        & ... % Rg Ch1
   DBSCAN_filtered{i,3}<MaxRg(1)               == 1        & ... % Rg Ch1
   DBSCAN_filtered{i,4}>MinRg(2)               == 1        & ... % Rg Ch2
   DBSCAN_filtered{i,4}<MaxRg(2)               == 1        & ... % Rg Ch2
   DBSCAN_filtered{i,5}>MinEcc(1)              == 1        & ... % Ecc Ch1
   DBSCAN_filtered{i,5}<MaxEcc(1)              == 1        & ... % Ecc Ch1
   DBSCAN_filtered{i,6}>MinEcc(2)              == 1        & ... % Ecc Ch2
   DBSCAN_filtered{i,6}<MaxEcc(2)              == 1        & ... % Ecc Ch2
   DBSCAN_filtered{i,7}<MaxFRC(1)              == 1        & ... % Ecc Ch2
   DBSCAN_filtered{i,8}<MaxFRC(2)              == 1;
   
count = count+1;    
    
Cent_selected{count,1} = DBSCAN_filtered{i,1}; 
Cent_selected{count,2} = DBSCAN_filtered{i,2};

CentForTraining(count,:) = DBSCAN_filtered(i,1:end);

else end

end

X = [num2str(length(Cent_selected)) '/' num2str(length(DBSCAN_filtered)) '  particles are left'];
disp(X)


%% Add Box around each Particle

% Combine both images

xCol = 1; yCol = 2;

Cent_selected_2C = {}; xmax = []; ymax = [];

for i=1:length(Cent_selected);
    
Cent_selected_2C{i,1} = vertcat(Cent_selected{i,1}(:,1:13),Cent_selected{i,2}(:,1:end));

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

figure
scatter(addedBox(:,1), addedBox(:,2));

% Add the box to each channel and separate the two channels

channel_ID = 12;

for i=1:length(Cent_selected_2C);

Cent_selected{i,3} = [Cent_selected_2C{i,1}(Cent_selected_2C{i,1}(:,channel_ID) == 1,1:2)+200; addedBox]; % Channel 1
Cent_selected{i,4} = [Cent_selected_2C{i,1}(Cent_selected_2C{i,1}(:,channel_ID) == 2,1:2)+200; addedBox]; % Channel 2

end


fprintf('-- Box added to each particle --');


%% Render the filtered images 

LocColCh1 = 3;
LocColCh2 = 4;

pxlsize = 10;

current_dir = pwd;
[status, message, messageid] = rmdir('rendered', 's');
mkdir rendered;
cd('rendered');

% Images Channel 1

count=1;

for i = 1:length(Cent_selected);
    
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

for i = 1:length(Cent_selected);
    
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

%% Use ImageJ to create, blur and save the Montage

% javaaddpath 'C:\Program Files\MATLAB\R2016b\java\mij.jar'
% javaaddpath 'C:\Program Files\MATLAB\R2016b\java\ij-1.51g.jar'
% Mij.start;

%cd('rendered');

string1 = ['Image Sequence...']; string2 = ['open=' num2str('rendered') ' file=Channel_2 sort'];

MIJ.run(string1, string2);
MIJ.run('Gaussian Blur...','sigma=1 stack');

string1 = ['Make Montage...']; string2 = ['columns=' num2str(round(sqrt(length(Cent_selected)))) ' rows=' num2str(round(sqrt(length(Cent_selected))))  ' scale=1'];

MIJ.run(string1, string2);
MIJ.run('Enhance Contrast', 'saturated=0.35');
MIJ.run('Save', 'Tiff..., path=[Z:\\Christian-Sieben\\data_HTP\\2017-12-08_humanCent_Cep152_Sas6\\analysis\\Particle_selection_Ch2.tif]');
MIJ.run('Close All')

% cd ..

%% Classification - Top / Side / Unclassified

% This classifier uses the function input
% Start this after the density filtering

% Cent_selected = Cent_filt(1:300,1:end);

Cent = Cent_selected(1:300,1:end); % Channel 1 -- 3, Channel 2 -- 4

Top             = {};
Side            = {};
Unclassified    = {};
response        = []; % 1>Top, 2>Side, 3>Unclassified

clc, close all

for i = 1:length(Cent);

            
        figure('Position',[500 300 300 300]);
        
        scatter(Cent{i,1}(:,1)-min(Cent{i,1}(:,1)),Cent{i,1}(:,2)-min(Cent{i,1}(:,2)),3,'filled','black');hold on;
        scatter(Cent{i,2}(:,1)-min(Cent{i,2}(:,1)),Cent{i,2}(:,2)-min(Cent{i,2}(:,2)),3,'filled','red');
        title(['ROI :', num2str(i) ' Particle :', num2str(j)],'FontSize',9);
        axis([0 max(max(Cent{i,1}(:,1)),max(Cent{i,2}(:,1)))-min(min(Cent{i,1}(:,1)),min(Cent{i,2}(:,1))) 0 max(max(Cent{i,1}(:,2)),max(Cent{i,2}(:,2)))-min(min(Cent{i,1}(:,2)),min(Cent{i,2}(:,2)))])
        box on
        axis on  

        w = input('Waiting for Input: t > Top, s > Side, u > unclassified','s')
                
        if strcmpi(w,'t');  
            
        Top = vertcat(Top,Cent_selected(i,1:2));              % Put on the shown cluster into the new variable  
        response(i,1) = 1; 
        disp('Top View')
        
        elseif strcmpi(w,'s')
            
        Side = vertcat(Side,Cent_selected(i,1:2));        % Put on the shown cluster into the new variable 
        response(i,1) = 2;
        disp('Side View')
        
        else 
            
        Unclassified = vertcat(Unclassified,Cent_selected(i,1:2));        % Put on the shown cluster into the new variable 
        response(i,1) = 3;
        disp('Unclassified')
        
        end


    close all  , clc     

       
end



