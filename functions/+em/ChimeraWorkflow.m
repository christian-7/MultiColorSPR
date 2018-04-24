% Copyright (C) 2018 Laboratory of Experimental Biophysics
% Ecole Polytechnique Federale de Lausanne
%
% Author: Kyle M. Douglass
%

classdef ChimeraWorkflow < em.PackageInterface
    % CHIMERAWORKFLOW Launches a pre-specified Chimera workflow.
    %
    methods (Static)
        function fitInMap(map1Path, map2Path, varargin)
            % FITINMAP Fits one density map into another.
            %
            % Inputs
            % ------
            % map1Path : str
            %     Path to the first volume data file. This one will be
            %     transformed to fit into the second one.
            % map2Path : str
            %     Path to the second volume data file. This one will remain
            %     fixed.
            %         
            p = inputParser;
            addRequired(p, 'map1Path', @ischar);
            addRequired(p, 'map2Path', @ischar);
            parse(p, map1Path, map2Path, varargin{:});
            
            % Prepare the Chimera workflow.
            spartanEnv = utils.SpartanEnv.getEnvironment();
            chimeraBin = fullfile(spartanEnv.chimeraPath, ...
                                  'bin', 'chimera');
            fitInMapScript = fullfile(spartanEnv.chimeraScriptsDir, ...
                                      'fit_in_map.py');
            cmd = strcat(chimeraBin, {' --script "'}, fitInMapScript, ...
                         {' --map1 '}, map1Path, {' --map2 '}, ...
                         map2Path, '" & echo $!');
            cmd = cmd{1};
            
            % Launch Chimera.
            [status, cmdout] = system(cmd);
            disp(cmdout);
            
             if (status == 0)
                disp(['Chimera process launched with PID: ' cmdout]);
            else
                error(['Chimera process spawning failed with exit ' ...
                       'code %d'], status);
             end
        end
        
       
    end
end

