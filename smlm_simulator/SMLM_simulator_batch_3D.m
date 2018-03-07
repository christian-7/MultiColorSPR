function [sim_line] = SMLM_simulator_batch(mol_list2, nframes);


% INPUT  :   mol_list2 - list of x and y coordinates 
%            nframes   - number of frames

% OUTPUT :   sim_line  - x, y, z, photons, frame  


%% Generate a uniform distribution of random numbers between 0 and 1

uni_dis  = makedist('Uniform','lower',0,'upper',1);

% Compute the cdfs between 0 and 1, 
% cdf1 = list of 1e6 random numbers between 0and 1

x = 0:1e-6:1; 
y = pdf(uni_dis,x);
cdf1 = cdf(uni_dis,x); % generate 1e6 random numbers between 0 and 1, this is later used to find random points on the experimental icdf

%% Simulate localizations around each molecule

% 1. On Time
% load('D:\Christian\GitHub\SMLMS_vis\exp_dist\locs_per_mol_1.mat')
load('locs_per_mol_1.mat');
dist_locs = fitdist(nbr_of_locs, 'lognormal');

% 2. Position x, y, z
% load('Z:\Christian-Sieben\data_HTP\2017-07-24_TCI_Calibration_Bob\allClusters_XYZ_scatter.mat')
load('allClusters_XYZ_scatter.mat');
dist_xpos = fitdist(allclustersCx, 'Normal');
dist_ypos = fitdist(allclustersCy, 'Normal');
dist_zpos = fitdist(allclustersCz, 'Normal');

% 2. Photons
% load('D:\Christian\GitHub\SMLMS_vis\exp_dist\photons1.mat')
load('photons1.mat');
dist_pho  = fitdist(pho,'Kernel','Width',100);
% x = 100:10:8000;
% y = pdf(dist_pho,x);
% scatter(x,y)

% 2. Dark Time
% load('D:\Christian\GitHub\SMLMS_vis\exp_dist\dt1_in_frames.mat')
load('dt1_in_frames.mat');
dist_dT  = fitdist(allgaps,'Kernel','Width',100);
% x = 100:10:8000;
% y = pdf(dist_dT,x);
% scatter(x,y)

%% Start Simulator

% 1. How many locs per molecule

% for each true molecule, it picks a random number 
% between 0 and 1 from the uniform CDF

rando_N_of_locs = [];

for i = 1:length(mol_list2);
        
    r = [];
    r = randi([1,1e6],1,1);
    rando_N_of_locs(i,1) = cdf1(r);
    
end

% tic

rng('shuffle')

all_sim_x = [];
all_sim_y = [];
all_sim_z = [];
all_sim_photons = [];
all_sim_frame = [];

% 2. Simulate localizations for each true molecule 

for i = 1:length(mol_list2);           % for all molecules
    
    % x,y,z,photons,frame
    
    sim_locs = zeros(round(icdf(dist_locs,rando_N_of_locs(i,1))),5);            % generate an empty container for each molecule
    startFrame = randi([1,nframes],1,1);                                        % appearance of the first loc for the respective molecule, between 1- frames
    
                        rando_N = [];                                           % generate random numbers to pick the parameters for each localization
     
                        for k = 1:length(sim_locs(:,1));
        
                        r = [];
                        r = randi([1,1e6],1,5);
                        rando_N(k,1:5) = cdf1(r);

                        end
    
 for j = 1:length(sim_locs(:,1));                                          % for all locs     
    
    sim_locs(j,1) = mol_list2(i,1) + (icdf(dist_xpos,rando_N(j,1)));       % x coordinate = true molecule position plus x loc precision
    sim_locs(j,2) = mol_list2(i,2) + (icdf(dist_ypos,rando_N(j,2)));       % y coordinate = true molecule position plus y loc precision
    sim_locs(j,3) = mol_list2(i,3) + (icdf(dist_zpos,rando_N(j,3)));       % z coordinate = true molecule position plus z loc precision
    sim_locs(j,4) = icdf(dist_pho,rando_N(j,4));                           % photons
    sim_locs(j,5) = startFrame + round(icdf(dist_dT,rando_N(j,5)));        % start frame plus dT
    
 end         
    
            all_sim_x       = vertcat(all_sim_x,sim_locs(:,1));
            all_sim_y       = vertcat(all_sim_y,sim_locs(:,2));
            all_sim_z       = vertcat(all_sim_z,sim_locs(:,3));
            all_sim_photons = vertcat(all_sim_photons, sim_locs(:,4));
            all_sim_frame   = vertcat(all_sim_frame, sim_locs(:,5));
 
end

sim_line(:,1) = all_sim_x;
sim_line(:,2) = all_sim_y;
sim_line(:,3) = all_sim_z;
sim_line(:,4) = all_sim_photons;
sim_line(:,5) = all_sim_frame;

% fprintf(' -- Simulation done after %f sec -- \n',toc)

end

