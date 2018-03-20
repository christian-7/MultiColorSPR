function [simCent_wNoise] = start_SMLM_simulator(simParticles,nframes);
tic
addpath('smlm_simulator');

% fprintf('Progress:\n');
% fprintf(['\n' repmat('.',1,num_of_structures) '\n\n']);

hbar = parfor_progressbar(length(simParticles),'Computing...');  %create the progress bar

parfor i = 1:length(simParticles);
   
simCent_wNoise{i,1} = SMLM_simulator_batch_3D(simParticles{i,1}, nframes);

hbar.iterate(1);   % update progress by one iteration

% fprintf('\b|\n');

end

fprintf('\n --    All Simulations Finished after %f  min -- \n', toc/60)

end