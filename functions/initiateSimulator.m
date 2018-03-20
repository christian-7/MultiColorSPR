function [simParticles, sim_Noise] = initiateSimulator(handles);

%% Generate library of rotated centrioles

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_of_structures   = handles.NbrStructures;                                                                          % Set simulation parameters                                                           
labelling_eff       = handles.LE ;
nframes             = handles.NbrFrames;
noise_mol           = handles.NbrNoise;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ptCloud = pointCloud([handles.GT(:,1),handles.GT(:,2),handles.GT(:,3)]);

maxNoise            = max(max(handles.GT(:,1:3)));
minNoise            = -maxNoise; %min(min(handles.GT(:,1:3))); 


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

 ptCloudOut_final = ptCloud;

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

NoiseMol = [];
NoiseMol(:,1) = NoiseX(randi([1 length(NoiseX)],noise_mol,1));
NoiseMol(:,2) = NoiseY(randi([1 length(NoiseY)],noise_mol,1));
NoiseMol(:,3) = NoiseY(randi([1 length(NoiseZ)],noise_mol,1));

sim_cent{i,2}  = vertcat(sim_cent{i,1}(r,1:3),NoiseMol);             % this adds 10 noise molecules to mol_list
sim_Noise{i,1} = NoiseMol;

end

sim_cent(:,1) = []; % delete first column

simParticles = sim_cent;

fprintf('\n -------------------------------    Ready to start simulation ------------------------------- \n')
