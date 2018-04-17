% Copyright (C) 2018 Laboratory of Experimental Biophysics
% Ecole Polytechnique Federale de Lausanne
%
% Author: Kyle M. Douglass
%

classdef ScipionWorkflow < em.PackageInterface
    %SCIPIONWORKFLOW Launches a pre-specified Scipion workflow.
    
    properties (SetAccess = private, GetAccess = public)
        % The name of the project inside Scipion.
        projectName;
        
        % JSON string defining the Scipion workflow. This is assigned only
        % when the workflow has been successfully generated from the
        % template.
        workflow = '';
        
        % The label to assign to the reference protein inside Scipion.
        refLabel;
        
        % The label to assign to the protein of interest inside Scipion.
        poiLabel;
        
        % Scipion's process ID number. This is only assigned once the
        % Scipion process is spawned.
        PID;
        
        % The full path to the folder for this Scipion project.
        pathToProject;
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
            projectName, pairedAnalysis, pathToRefMontage, varargin ...
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
            % pathToRefMontage : str
            %     The full path (including filename) to the montage for
            %     the reference protein.
            % refLabel : str
            %     The text label for the reference protein.
            % pathToPoiMontage : str (optional)
            %     The full path (including filename) to the montage for
            %     the second protein of interest. This must be supplied
            %     if pairedAnalysis is set to true.
            % poiLabel : str (optional)
            %     The text label for the protein of interest.
            %
            % Parameters
            % ----------
            % pathToProject : str (optional)
            %     The location of the Scipion project. If this is empty,
            %     Scipion will use the default location, which is typically
            %     the ScipionUserData/projects folder. Specify this
            %     parameter as a name/value pair.
            
            p = inputParser;
            
            defaultRefLabel = 'Reference_Protein';
            defaultPoiLabel = 'Paired_Protein';
            
            addRequired(p, 'projectName', @ischar);
            addRequired(p, 'pairedAnalysis', @islogical);
            addRequired(p, 'pathToRefMontage', @ischar);
            addOptional(p, 'refLabel', defaultRefLabel, @ischar);
            addOptional(p, 'pathToPoiMontage', '', @ischar);
            addOptional(p, 'poiLabel', defaultPoiLabel, @ischar);
            addParameter(p, 'pathToProject', '', @ischar);
            
            parse(p, projectName, pairedAnalysis, pathToRefMontage, ...
                  varargin{:});
            
            obj.projectName = p.Results.projectName;
            obj.pairedAnalysis = p.Results.pairedAnalysis;
            obj.pathToRefMontage = p.Results.pathToRefMontage;
            obj.refLabel = p.Results.refLabel;
            obj.poiLabel = p.Results.poiLabel;
            
            % TODO: ADD CODE FOR SINGLE POI ANALYSIS
            
            if (obj.pairedAnalysis) && ( isempty(p.Results.pathToPoiMontage) )
                error('ScipionWorkflow:NotEnoughInputs', ...
                    ['Error! \nTwo montages must be supplied if '...
                     'pairedAnalysis is set to true.']);
            else
                obj.pathToPoiMontage = p.Results.pathToPoiMontage;
            end
            
            obj.pathToProject = p.Results.pathToProject;
            
            generateWorkflow(obj);
        end
        
        function launchWorkflow(obj, varargin)
            % LAUNCHWORKFLOW Launches the Scipion session.
            %
            % Parameters
            % ----------
            % scipionSource : str (optional)
            %     A name/value pair that determines the Scipion source.
            %     Current options are 'native' and 'docker'. The default is
            %     'native'.
            %
            p = inputParser;
            addParameter(p, 'scipionSource', 'native', @ischar);
            parse(p, varargin{:});
            
            src = p.Results.scipionSource;
            switch lower(src)
                case {'native'}
                    obj.launchNativeWorkflow();
                case {'docker'}
                    error('Error: Not implemented.')
                otherwise
                    error(['Error: argument' src ' not recognized. ' ... 
                           'Must be either ''native'' or ''docker''']);
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
            
            if ~isempty(obj.pathToPoiMontage)
                [filepath, name, ext] = fileparts(obj.pathToPoiMontage);
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
        
        function launchNativeWorkflow(obj)
            % LAUNCHWORKFLOW Launches a native Scipion session.
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
                         {' '}, obj.projectName, {' '}, jsonFilename, ...
                         {' '}, obj.pathToProject);
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
                obj.PID = str2double(cmdout);
                disp(['Scipion process launched with PID: ' cmdout]);
            else
                error(['Scipion process spawning failed with exit ' ...
                       'code %d'], status);
            end
        end
    end
end

