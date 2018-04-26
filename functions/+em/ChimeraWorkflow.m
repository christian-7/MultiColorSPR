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
                         {' --map1 '}, p.Results.map1Path, {' --map2 '},...
                         p.Results.map2Path, '" & echo $!');
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
        
        function transformCoordinates(mapPath, mapPathFixed, x, y, z)
            % TRANSFORMCOORDINATES Translates a map relative to another.
            %
            % transformCoordinates(...) translates the model in mapPath
            % relative to the one in mapPathFixed. The translation is
            % defined by the displacement in x, y, and z.
            %
            % Inputs
            % ------
            % mapPath : str
            %     Path to the first volume data file. This one will be
            %     translated.
            % mapPathFixed : str
            %     Path to the second volume data file. This one will remain
            %     fixed.
            % x : double
            %     The x-displacement.
            % y : double
            %     The y-displacement.
            % z : double
            %     The z-displacement.
            %
            
            p = inputParser;
            addRequired(p, 'mapPath', @ischar);
            addRequired(p, 'mapPathFixed', @ischar);
            addRequired(p, 'x', @isnumeric);
            addRequired(p, 'y', @isnumeric);
            addRequired(p, 'z', @isnumeric);
            parse(p, mapPath, mapPathFixed, x, y, z);
            
            % Prepare the Chimera workflow.
            spartanEnv = utils.SpartanEnv.getEnvironment();
            chimeraBin = fullfile(spartanEnv.chimeraPath, ...
                                  'bin', 'chimera');
            script = fullfile(spartanEnv.chimeraScriptsDir, ...
                              'transform_coordinates.py');
            cmd = strcat(chimeraBin, {' --script "'}, script, ...
                         {' --model_path '}, p.Results.mapPath, ...
                         {' --fixed_model_path '}, ...
                         p.Results.mapPathFixed, {' --x '}, ...
                         num2str(p.Results.x), {' --y '}, ...
                         num2str(p.Results.y), {' --z '}, ...
                         num2str(p.Results.z), '" & echo $!');
            cmd = cmd{1};
            disp(cmd)
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

