% Copyright (C) 2018 Laboratory of Experimental Biophysics
% Ecole Polytechnique Federale de Lausanne
%
% Author: Kyle M. Douglass
%

classdef ScipionWorkflow < em.PackageInterface
    %SCIPIONWORKFLOW Launches a pre-specified Scipion workflow.
    
    properties (SetAccess = private, GetAccess = public)
        projectName;
        workflow = '';
        refLabel;
        poiLabel = 'poi';
    end
    
    properties (SetAccess = private, GetAccess = private)
        scipionPID;
    end
    
    properties (Constant, GetAccess = private)
        % The patterns to be replaced in the workflow templates.
        REF_PATTERN = 'REFERENCE_PROTEIN';
        PAIR_PATTERN = 'PAIRED_PROTEIN';
        LABEL_PATTERN = '_LABEL';
        PATH_PATTERN = '_PATH';
        PATTERN_PATTERN = '_PATTERN';
    end
    
    methods
        function obj = ScipionWorkflow( ...
            projectName, pairedAnalysis, pathToRefMontage, refLabel, ...
            varargin ...
        )
            % SCIPIONWORKFLOW Create the Scipion package wrapper.
            %
            % Inputs
            % ------
            % projectName : str
            %     A descriptive name to give to the project.
            % pairedAnalysis : boolean
            %     If true, the paired analysis workflow for two protein
            %     reconstructions will be launched. If false, a single
            %     protein reconstruction workflow will be launched.
            % pathToMontage1 : str
            %     The full path (including filename) to the montage for
            %     the reference protein.
            % refLabel : str
            %     The text label for the reference protein.
            % vargin{1} : str
            %     The full path (including filename) to the montage for
            %     the second protein of interest. This must be supplied
            %     if pairedAnalysis is set to true.
            % varargin{2} : str (Default: 'poi')
            %     The text label for the protein of interest
            
            obj.projectName = projectName;
            obj.pairedAnalysis = pairedAnalysis;
            obj.pathToRefMontage = pathToRefMontage;
            obj.refLabel = refLabel;
            
            if (pairedAnalysis) && (nargin < 4)
                error('ScipionWorkflow:NotEnoughInputs', ...
                    ['Error! \nTwo montages must be supplied if '...
                     'pairedAnalysis is set to true.']);
            else
                obj.pathToPairMontage = varargin{1};
            end
            
            if (length(varargin) == 2)
                obj.poiLabel = varargin{2};
            end
            
            generateWorkflow(obj);
        end
        
        function launchWorkflow(obj)
            % LAUNCHWORKFLOW Launches the Scipion session.
            assert(~isempty(obj.workflow), ...
                ['Assertion failed: workflow file was not generated ' ...
                 'from template.']);
            
            % Creates the Scipion workflow .json file.
            jsonFilename = strcat(tempname, '.json');
            fid = fopen(jsonFilename, 'w');
            fprintf(fid, '%s', obj.workflow);
            fclose(fid);
            
            % Creates the Scipion project.
            sp = obj.spartanEnv.scipionPath;
            scipionScript = fullfile(sp, 'scipion');
            projectScript = fullfile(sp, 'scripts', 'create_project.py');
            cmd = strcat(scipionScript, {' run python '}, projectScript,...
                         {' '}, obj.projectName, {' '}, jsonFilename);
            cmd = cmd{1};
            disp('Creating new Scipion project...')
            [status, cmdout] = system(cmd);
            disp(cmdout);
            
            if (status ~= 0)
                error(['Scipion project creation failed with exit ' ...
                       'code %d'], status);
                   
            end
            
            % Spawns the Scipion subprocess. We can assume a Linux system
            % because Scipion does not work on Windows.
            disp('Launching Scipion...');
            cmd = strcat(scipionScript, {' project '}, obj.projectName, ...
                         ' & echo $!');
            cmd = cmd{1};
            [status, cmdout] = system(cmd);
            
            if (status == 0)
                obj.scipionPID = str2double(cmdout);
                disp(['Scipion process launched with PID: ' cmdout]);
            else
                error(['Scipion process spawning failed with exit ' ...
                       'code %d'], status);
            end
            
        end
    end
    
    methods (Access = private)
        function generateWorkflow(obj)
            % GENERATEWORKFLOW Creates the workflow from the JSON template.
            filename = obj.spartanEnv.scipionPairedTemplate;
            template = fileread(filename);
            
            % Split montage paths into path and pattern
            [filepath, name, ext] = fileparts(obj.pathToRefMontage);
            refPath = filepath;
            refPattern = strcat(name, ext);
            
            if ~isempty(obj.pathToPairMontage)
                [filepath, name, ext] = fileparts(obj.pathToPairMontage);
                pairPath = filepath;
                pairPattern = strcat(name, ext);
            end
            
            % Search the workflow for the pattern strings and replace them
            % with the relevant information for a fully functional
            % workflow.
            
            % The name given to the protein in the protocols
            template = strrep( ...
                template, ...
                strcat(obj.REF_PATTERN, obj.LABEL_PATTERN), ...
                obj.refLabel);
            % The path to the montage, without the filename
            template = strrep( ...
                template, ...
                strcat(obj.REF_PATTERN, obj.PATH_PATTERN), ...
                refPath);
            % The filename of the montage
            template = strrep( ...
                template, ...
                strcat(obj.REF_PATTERN, obj.PATTERN_PATTERN), ...
                refPattern);
            
            if obj.pairedAnalysis
                % The name given to the protein in the protocols
                template = strrep( ...
                    template, ...
                    strcat(obj.PAIR_PATTERN, obj.LABEL_PATTERN), ...
                    obj.poiLabel);
                % The path to the montage, without the filename
                template = strrep( ...
                    template, ...
                    strcat(obj.PAIR_PATTERN, obj.PATH_PATTERN), ...
                    pairPath);
                % The filename of the montage
                template = strrep( ...
                    template, ...
                    strcat(obj.PAIR_PATTERN, obj.PATTERN_PATTERN), ...
                    pairPattern);
            end
            
            obj.workflow = template;
        end
    end
end

