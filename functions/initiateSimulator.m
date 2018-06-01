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
