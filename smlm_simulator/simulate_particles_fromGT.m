%% Generate library of rotated centrioles

clear; clc; close all; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_of_structures   = 10;
                                                                            % Set simulation parameters                                                           
labelling_eff       = 0.4;
nframes             = 20e3;
minNoise            = -200; 
maxNoise            = 200;
noise_mol           = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('GT_Cep152_Sas6.mat'); % cd ..

ptCloud = ptCloud_Cep152_Sas6;

rng('shuffle');

a = -pi; b = pi;
sim_cent = {};

rand_ang(:,1) = (b-a).*rand(num_of_structures,1) + a;
rand_ang(:,2) = (b-a).*rand(num_of_structures,1) + a;
rand_ang(:,3) = (b-a).*rand(num_of_structures,1) + a;

for i = 1:num_of_structures;

Rx = [1 0 0 0; ...
     0 cos(rand_ang(i,1)) -sin(rand_ang(i,1)) 0; ...
     0 sin(rand_ang(i,1)) cos(rand_ang(i,1)) 0; ...
     0 0 0 1];

tform = affine3d(Rx);
ptCloudOutx = pctransform(ptCloud,tform);
 
Ry = [cos(rand_ang(i,2)) 0 sin(rand_ang(i,2)) 0; ...
     0 1 0 0; ...
     -sin(rand_ang(i,2)) 0 cos(rand_ang(i,2)) 0; ...
     0 0 0 1];
 
tform = affine3d(Ry);
ptCloudOuty = pctransform(ptCloudOutx,tform);

Rz = [cos(rand_ang(i,3)) sin(rand_ang(i,3)) 0 0; ...
     -sin(rand_ang(i,3)) cos(rand_ang(i,3)) 0 0; ...
     0 0 1 0; ...
     0 0 0 1];

tform = affine3d(Rz);
ptCloudOut_final = pctransform(ptCloudOuty,tform);

% Substact the center of mass

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

sim_cent(:,1) = []; % delete first column

% Save the list (optional)

% cd('Z:\Christian-Sieben\Centriole\Cep57_simulation\cluster'); 
% save('GT_Cep152_Sas6_LE04_newHeigth.mat','sim_cent');

fprintf('\n -------------------------------    Ready to start simulation ------------------------------- \n')

%% Plot a random example

close all
ID = randi([1 num_of_structures],1,1)
figure
scatter3(sim_cent{ID, 1}(:,1),sim_cent{ID, 1}(:,2),sim_cent{ID, 1}(:,3));
axis([-300 300 -300 300])
view([60,40])
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

save('sim_Cep57_LE80_woNoise.mat','simCent_wNoise');


%% Plot a random example along with GT

close all

ID = randi([1 num_of_structures],1,1)
figure('Position',[200 200 1000 400])
subplot(1,2,1)
scatter3(sim_cent{ID, 1}(:,1),sim_cent{ID, 1}(:,2),sim_cent{ID, 1}(:,3),1,'k');
axis([-300 300 -300 300]);view([60,40]);axis square
box on
title('Ground truth');
xlabel('x [nm]');ylabel('y [nm]');zlabel('z [nm]');

subplot(1,2,2)
scatter3(simCent_wNoise{ID, 1}(:,1),simCent_wNoise{ID, 1}(:,2),simCent_wNoise{ID, 1}(:,3),1,'k');
axis([-300 300 -300 300]);view([60,40]);
axis square
box on
title('simulated localizations');
xlabel('x [nm]');ylabel('y [nm]');zlabel('z [nm]');



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

%% Render Image 

clc

simCent_wNoise = simCent_wNoise_cleaned;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data_column         = 1;
image_column        = 3;
data_smart_merged   = 0;

xCol = 1;
zCol = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% current_dir = ('Z:\Christian-Sieben\Centriole\Cep57_simulation');
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

% This step requires the installation of Miji, see:
% https://ch.mathworks.com/matlabcentral/fileexchange/47545-mij--running-imagej-and-fiji-within-matlab

% javaaddpath 'C:\Program Files\MATLAB\R2016b\java\mij.jar'
% javaaddpath 'C:\Program Files\MATLAB\R2016b\java\ij-1.51g.jar'
% addpath('D:\fiji-win64\Fiji.app\scripts');
% Miji;

savename = 'Cep152_Sas6_3D.tif'

string1 = ['Image Sequence...']; string2 = ['open=' num2str('rendered') ' file=image_10nm sort'];

MIJ.run(string1, string2);
MIJ.run('Gaussian Blur...','sigma=1 stack');
string1 = ['Make Montage...']; string2 = ['columns=' num2str(round(sqrt(length(simCent_wNoise)))) ' rows=' num2str(round(sqrt(length(simCent_wNoise))))  ' scale=1'];

MIJ.run(string1, string2);
MIJ.run('Enhance Contrast', 'saturated=0.35');

string1 = ['Save']; 
string2 = ['Tiff..., path=[' strrep(pwd,'\','\\') '\\' savename ']'];

MIJ.run(string1, string2);

MIJ.run('Close All')


% cd ..

fprintf('\n -------------------------------  Montage Saved  ------------------------------- \n')