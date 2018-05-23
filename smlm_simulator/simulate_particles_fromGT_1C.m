%% Generate library of rotated centrioles

clear; clc; close all; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_of_structures   = 100;
                                                                            % Set simulation parameters                                                           
labelling_eff   = 0.8;
nframes         = 20e3;
minNoise        = -200; 
maxNoise        = 200;
noise_mol       = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd('/Users/christian/Documents/Arbeit/MatLab/centriole_sim/Centriole_GT_structures'); 
load('GT_Cep152_Sas6_18fold_23-05-18.mat'); 

ptCloud  = ptCloud_Cep152_Sas6;


a = [1, 0, 0, 0]; % initial vector

% Compute the random rotation axes in 3D. (u,v,w) is a unit vector pointing
% in direction uniformly random in any direction.

r1 = rand(num_of_structures, 1);
r2 = rand(num_of_structures, 1);

phi = 2 * pi * r1;
theta = acos(2 * r2 - 1);

u = sin(theta) .* cos(phi);
v = sin(theta) .* sin(phi);
w = cos(theta);

% Uncomment this to verify that the points uniformly cover the unit sphere.
% plot3(u, v, w, '.');

% figure;

for i = 1:num_of_structures
    % Find the angle t between the initial vector and the random axis of
    % rotation.
    uu = u(i);
    vv = v(i);
    ww = w(i);
    t = acos(dot(a, [uu, vv, ww, 0]) / norm(a));

    % (l,m,n) is the axis of rotation.
    ax_of_rot = cross(a(1:3), [uu, vv, ww]);
    ax_of_rot = ax_of_rot / norm(ax_of_rot); % Makes ax_of_rot a unit vector
    l = ax_of_rot(1); m = ax_of_rot(2); n = ax_of_rot(3);

    % This rotation matrix assumes that (l,m,n) is normalized and that it
    % passes through the origin.
    %
    % See section 5.2 at
    % https://sites.google.com/site/glennmurray/Home/rotation-matrices-and-formulas/rotation-about-an-arbitrary-axis-in-3-dimensions.
    
    R = [l^2 + (1 - l^2) * cos(t), l * m * (1 - cos(t)) - n * sin(t), l * n * (1 - cos(t)) + m * sin(t), 0;
         l * m * (1 - cos(t)) + n * sin(t), m^2 + (1 - m^2) * cos(t), m * n * (1 - cos(t)) - l * sin(t), 0;
         l * n * (1 - cos(t)) - m * sin(t), m * n * (1 - cos(t)) + l * sin(t), n^2 + (1 - n^2) * cos(t), 0;
         0, 0, 0, 1];

%     aa = R * a';
%     plot3(aa(1), aa(2), aa(3), '.');
%     hold on;axis equal;

tform = affine3d(R);
ptCloudOut_final = pctransform(ptCloud,tform);

sim_cent{i,1}(:,1) = ptCloudOut_final.Location(:,1)-sum(ptCloudOut_final.Location(:,1))/length(ptCloudOut_final.Location(:,1));
sim_cent{i,1}(:,2) = ptCloudOut_final.Location(:,2)-sum(ptCloudOut_final.Location(:,2))/length(ptCloudOut_final.Location(:,2));
sim_cent{i,1}(:,3) = ptCloudOut_final.Location(:,3)-sum(ptCloudOut_final.Location(:,3))/length(ptCloudOut_final.Location(:,3));

clc; 
fprintf(['Done ' num2str(i) ' of ' num2str(num_of_structures)]);
   
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NoiseX = (maxNoise-minNoise).*rand(1000,1) + minNoise; % short side, x position
NoiseY = (maxNoise-minNoise).*rand(1000,1) + minNoise; % short side, y position
NoiseZ = (maxNoise-minNoise).*rand(1000,1) + minNoise; % short side, z position

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(sim_cent);
    
nbr_of_labels = length(sim_cent{i,1})*labelling_eff;
   
% Select random molecules from the list

% r = randi([1,length(sim_cent{i,1})],1,round(nbr_of_labels));
r = randperm(length(sim_cent{i,1}),round(nbr_of_labels));

% Add Noise molecules

NoiseMol(:,1) = NoiseX(randi([1 length(NoiseX)],noise_mol,1));
NoiseMol(:,2) = NoiseY(randi([1 length(NoiseY)],noise_mol,1));
NoiseMol(:,3) = NoiseY(randi([1 length(NoiseZ)],noise_mol,1));

sim_cent{i,2} = vertcat(sim_cent{i,1}(r,1:3),NoiseMol);             % this adds 10 noise molecules to mol_list

end

sim_cent(:,1) = [];    

fprintf('\n -------------------------------    Ready to start simulation ------------------------------- \n')

%% Plot a random example

close all
ID = randi([1 num_of_structures],1,1)
figure
subplot(1,2,1)
scatter3(sim_cent{ID, 1}(:,1),sim_cent{ID, 1}(:,2),sim_cent{ID, 1}(:,3));
axis([-300 300 -300 300])
view([60,40])
axis equal

subplot(1,2,2)
scatter(sim_cent{ID, 1}(:,1),sim_cent{ID, 1}(:,2));
axis([-300 300 -300 300])
axis equal

%% Run the simulator
tic
clc

fprintf('Progress:\n');
fprintf(['\n' repmat('.',1,num_of_structures) '\n\n']);

parfor i = 1:length(sim_cent);
   
simCent_wNoise{i,1} = SMLM_simulator_batch_3D(sim_cent{i,1}, nframes);

fprintf('\b|\n');

end

fprintf('\n -------------------------------    All Simulations Finished after %f  min ------------------------------- \n', toc/60)
toc

cd('/Users/christian/Documents/Arbeit/MatLab/centriole_sim/Nine_fold'); 
save('sim_Cep152_9fold_LE02.mat','simCent_wNoise');

%% Plot a random example along with GT

close all
ID = randi([1 num_of_structures],1,1)
figure
subplot(1,2,1)
scatter3(sim_cent{ID, 1}(:,1),sim_cent{ID, 1}(:,2),sim_cent{ID, 1}(:,3),1);
axis([-300 300 -300 300]);view([60,40]);axis equal

subplot(1,2,2)
scatter3(simCent_wNoise{ID, 1}(:,1),simCent_wNoise{ID, 1}(:,2),simCent_wNoise{ID, 1}(:,3),1);
axis([-300 300 -300 300]);view([60,40]);
axis equal

%% Clean up

xCol = 1; yCol = 2; zCol = 3;

simCent_wNoise_cleaned = {}; 

for i = 1:length(simCent_wNoise); % for all cells

count = 1;

    for j = 1:length(simCent_wNoise{i,1}); % for all locs

    if isinf(simCent_wNoise{i,1}(j,xCol))==1 | isinf(simCent_wNoise{i,1}(j,yCol))==1 | isinf(simCent_wNoise{i,1}(j,zCol))==1; 
    
    else
    
    simCent_wNoise_cleaned{i,1}(count,:) = simCent_wNoise{i,1}(j,1:end); 
    count = count+1;

    end
    
    end
    
clc;
fprintf(['\n ------------------------------- ' num2str(i) ' of ' num2str(length(simCent_wNoise)) ' cleaned ------------------------------- \n'])
    
end

%% Calculate volumes

[Volume_Cep57] = CreateVolumesFromCoordinates_1C(simCent_wNoise_cleaned,1,2,3,10,1.5,5.5); % (InputCells,xCol,yCol,zCol,pxsize,sigmaxy,sigmaz)

save('Cep57_LE08_volumes.mat','Volume_Cep57');

%% Save the volumes from VolChannel1 as stack into a folder

for j = 1:5;%size(simCent_wNoise,1);

cd('Z:\Christian-Sieben\Centriole\Cep57_simulation\volumes');

outvolume = Volume_Cep57(:,:,:,j);

imwrite(outvolume(:,:,1), ['Cep57_' num2str(j) '.tif'])

for k = 2:size(outvolume,3)
imwrite(outvolume(:,:,k), ['Cep57_' num2str(j) '.tif'], 'writemode', 'append');
end

end

clear, clc

%% Merging
tic
pos_list_new = {};

for j = 1:length(simCent_wNoise);

    pos_list      = [];
    pos_list(:,1) = simCent_wNoise{j,1}(:,1)+500; % get rid of negative values
    pos_list(:,2) = simCent_wNoise{j,1}(:,2)+500; % get rid of negative values
    pos_list(:,3) = simCent_wNoise{j,1}(:,3);
    pos_list(:,4) = simCent_wNoise{j,1}(:,4);
    pos_list = sortrows(pos_list,4);              % order by frames
    pos_list_new{j,1} = pos_list;             
    
end
    
simCent_wNoise{1,2} = merging(pos_list_new{1,1},15,50);

parfor i = 1:length(simCent_wNoise);
    

try
    
    simCent_wNoise{i,2} = merging(pos_list_new{i,1},15,50);
    
    catch
    
    simCent_wNoise{i,2} = [];

end
    
end


fprintf('\n -------------------------------    Data merged after %f  min ------------------------------- \n', toc/60)

%% Smart Merging
tic

simCent_wNoise{1,3} = smart_merging(pos_list_new{13,1},15,50);

parfor i = 1:length(simCent_wNoise);
    
try     
    simCent_wNoise{i,3} = smart_merging(pos_list_new{i,1},15,50);
catch
    simCent_wNoise{i,3} = [];
end

end

fprintf('\n -------------------------------    Data smart merged after %f  min ------------------------------- \n', toc/60)

%% Add Box around each Particle

data_column = 1; % locs =1 , merged =2;

% Define the bounding box 

xmin = -200;
ymin = -200;
xmax = 200;
ymax = 200;

interval = 10;

lowerLine = [];
lowerLine(:,1) = xmin:((max(xmax))/interval):max(xmax); 
lowerLine(1:end,2) = ymin; 

upperLine = [];
upperLine(:,1) = xmin:(max(xmax)/interval):max(xmax); 
upperLine(1:end,2) = max(ymax); 

leftLine = [];
leftLine(:,2) = ymin:((max(ymax))/interval):max(ymax); 
leftLine(1:end,1) = xmin; 

rightLine = [];
rightLine(:,2) = ymin:(max(ymax)/interval):max(ymax); 
rightLine(1:end,1) = max(xmax); 

addedBox = [lowerLine; upperLine; leftLine; rightLine];

figure
scatter(addedBox(:,1), addedBox(:,2));

% Add the box to each channel and separate the two channels

for i=1:length(simCent_wNoise);
    
     if isempty(simCent_wNoise{i,data_column});
     else
temp = [];         
temp(:,1) = simCent_wNoise{i,data_column}(:,1)-500;    
temp(:,2) = simCent_wNoise{i,data_column}(:,2)-500;
          
simCent_wNoise{i,data_column+1} = [temp; addedBox]; % Channel 1
     
     end
     
end


fprintf('-- Box added to each particle --');



%% Render each particle

data_column = 1; % locs =1 , merged =2;

pxlsize = 10;

Cent = simCent_wNoise;

current_dir = pwd;
[status, message, messageid] = rmdir('rendered', 's')
mkdir rendered
cd('rendered')

% Determine the box size form the largest particle

im_size = [];

for j=1:length(Cent);
    
    if isempty(Cent{j,data_column});
    else
        
idx = ~(isnan(Cent{j, data_column}(:,1))| isinf(Cent{j, data_column}(:,1))| isnan(Cent{j, data_column}(:,2))| isinf(Cent{j, data_column}(:,2)));

im_size(j,1) = round((max(Cent{j,data_column}(idx,1))-min(Cent{j,data_column}(idx,1)))/pxlsize);
im_size(j,2) = round((max(Cent{j,data_column}(idx,2))-min(Cent{j,data_column}(idx,2)))/pxlsize);
    
    end               
end

width  = max(max(im_size));
heigth = max(max(im_size));

for j = 1:length(Cent);
    
     if isempty(Cent{j,data_column});
     else
    
        idx = ~(isnan(Cent{j, data_column}(:,1))| isinf(Cent{j, data_column}(:,1))| isnan(Cent{j, data_column}(:,2))| isinf(Cent{j, data_column}(:,2)));

        rendered = hist3([Cent{j,data_column}(idx,2),Cent{j,data_column}(idx,1)],[max(max(im_size)) max(max(im_size))]);
        
        rendered_cropped = imcrop(rendered,[2 2 max(max(im_size))*0.9 max(max(im_size))*0.9]);
        
        empty  = zeros(round(max(max(im_size))*2),round(max(max(im_size))*2));
        
        size_DC     = size(empty);
        center_X    = round(size_DC(2)/2);
        center_Y    = round(size_DC(1)/2);

%         empty(round(center-heigth/2):(round(center-heigth/2))+heigth-1,round(center-width/2):(round(center-width/2))+width-1) = rendered_cropped;
        empty(round(center_Y-size(rendered_cropped,1)/2):(round(center_Y-size(rendered_cropped,1)/2))+size(rendered_cropped,1)-1,round(center_X-size(rendered_cropped,2)/2):(round(center_X-size(rendered_cropped,2)/2))+size(rendered_cropped,2)-1) = rendered_cropped;
        
%         emptyG = imgaussfilt(empty, 1);
   
name = ['image_10nm_per_pxl_' num2str(j) '.tiff'];

I32=[];
I32=uint32(empty);

t = Tiff(name,'w');

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
end

fprintf('\n -------------------------------    Images Exported   ------------------------------- \n')

cd ..

%% Render Image without using the box
clc

simCent_wNoise = simCent_wNoise_cleaned;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_column         = 1;
image_column        = 3;
data_smart_merged   = 0;

xCol = 1;
zCol = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

current_dir = ('Z:\Christian-Sieben\Centriole\Cep57_simulation');
[status, message, messageid] = rmdir('rendered', 's')
mkdir rendered
cd('rendered')

% Render each Particle

if data_smart_merged==1;
   image_column = data_column;
else
pxlsize = 10;

for i = 1:length(simCent_wNoise);
    
    if isempty(simCent_wNoise{i,data_column});
    else
    
    idx = ~(isnan(simCent_wNoise{i, data_column}(:,xCol))| isinf(simCent_wNoise{i, data_column}(:,xCol))| isnan(simCent_wNoise{i, data_column}(:,zCol))| isinf(simCent_wNoise{i, data_column}(:,zCol)));

heigth =  round((max(simCent_wNoise{i,data_column}(idx,xCol))-min(simCent_wNoise{i,data_column}(idx,xCol)))/pxlsize);
width  =  round((max(simCent_wNoise{i,data_column}(idx,zCol))-min(simCent_wNoise{i,data_column}(idx,zCol)))/pxlsize);

simCent_wNoise{i,image_column} = hist3([simCent_wNoise{i,data_column}(idx,zCol),simCent_wNoise{i,data_column}(idx,xCol)],[width heigth]); 
    
    end
end

end

% Insert each Particle into a black space

im_size = [];

for i = 1:length(simCent_wNoise);
    
im_size = vertcat(im_size,size(simCent_wNoise{i,image_column}));

end


for j = 1:length(simCent_wNoise);
    
       if isempty(simCent_wNoise{j,image_column});
       else

empty  = zeros(round(max(max(im_size))*2),round(max(max(im_size))*2));

heigth = size(simCent_wNoise{j,image_column},1);
width  = size(simCent_wNoise{j,image_column},2);
        
        size_DC     = size(empty);
        center      = round(size_DC(2)/2);
        

empty(round(center-heigth/2):(round(center-heigth/2))+heigth-1,round(center-width/2):(round(center-width/2))+width-1) = simCent_wNoise{j,image_column};

% empty(round(center_Y-size(rendered_cropped,1)/2):(round(center_Y-size(rendered_cropped,1)/2))+size(rendered_cropped,1)-1,round(center_X-size(rendered_cropped,2)/2):(round(center_X-size(rendered_cropped,2)/2))+size(rendered_cropped,2)-1) = rendered_cropped;
     

name = ['image_10nm_per_pxl_' num2str(j) '.tiff'];

I32=[];
I32=uint32(empty);

t = Tiff(name,'w');

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
end

fprintf('\n -------------------------------    Images Exported   ------------------------------- \n')

cd ..

%% Use ImageJ to create, blur and save the Montage

% javaaddpath 'C:\Program Files\MATLAB\R2016b\java\mij.jar'
% javaaddpath 'C:\Program Files\MATLAB\R2016b\java\ij-1.51g.jar'
% addpath('D:\fiji-win64\Fiji.app\scripts');
% Miji;

save_path = ('Z:\Christian-Sieben\Centriole\Cep57_simulation\rendered');

% cd('rendered');

string1 = ['Image Sequence...']; string2 = ['open=' num2str(save_path) ' file=image_10nm sort'];

MIJ.run(string1, string2);
MIJ.run('Gaussian Blur...','sigma=1 stack');

string1 = ['Make Montage...']; string2 = ['columns=' num2str(round(sqrt(length(simCent_wNoise)))) ' rows=' num2str(round(sqrt(length(simCent_wNoise))))  ' scale=1'];

MIJ.run(string1, string2);
MIJ.run('Enhance Contrast', 'saturated=0.35');
MIJ.run('Save', 'Tiff..., path=[Z:\\Christian-Sieben\\Centriole\\Cep57_simulation\\Montage_sim_Cep57_Sas6_TopView_LE80_woNoise_Particles.tif]');
MIJ.run('Close All')


% cd ..

fprintf('\n -------------------------------  Montage Saved  ------------------------------- \n')