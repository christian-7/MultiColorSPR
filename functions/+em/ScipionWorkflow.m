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
        
        % Will Scipion be run natively or in Docker?
        scipionSource;
    end
    
    properties (Constant, GetAccess = private)
        % The patterns to be replaced in the workflow templates.
        REF_PATTERN = 'REFERENCE_PROTEIN';
        PAIR_PATTERN = 'PAIRED_PROTEIN';
        LABEL_PATTERN = '_LABEL';
        PATH_PATTERN = '_PATH';
        PATTERN_PATTERN = '_PATTERN';
        DOCKER_INPUT_VOLUME='ScipionInputData';
        CONTAINER_INPUT_PATH='/home/scipion/inputs';
    end
    
    methods (Static)
        function launchDockerManager()
            %LAUNCHDOCKERMANAGER Launches the Scipion manager in Docker.
            %
            % Launches the Scipion manager through Docker.
            env = utils.SpartanEnv.getEnvironment();
            disp('Launching the Scipion Manager...')
            cmd = ['docker run -it --rm -d' ...
                   '    --name Scipion ' ...
                   '    --mount type=bind,source=' ...
                   env.scipionUserDataPath ...
                   ',target=/home/scipion/ScipionUserData ' ...
                   '    --mount source=ScipionInputData,target=/home/scipion/inputs ' ...
                   '    -e DISPLAY=$DISPLAY ' ...
                   '    -v /tmp/.X11-unix:/tmp/.X11-unix ' ...
                   '    epflbiophys/scipion:1.2'];
               
            [status, cmdout] = system(cmd);
            if (status == 0)
                disp(['Scipion process launched in Docker container: ' cmdout]);
            end
        end
        
        function launchNativeManager()
            %LAUNCHNATIVEMANAGER Launches the Scipion manager natively.
            %
            % Launches the Scipion manager through Docker.
            disp('Launching the Scipion Manager...')
            env = utils.SpartanEnv.getEnvironment();
            scipionScript = fullfile(env.scipionPath, 'scipion');
            
            % Spawns the Scipion subprocess. We can assume a Linux system
            % because Scipion does not work on Windows.
            disp('Launching Scipion...');
            cmd = [scipionScript ' manager & echo $!'];              
            [status, cmdout] = system(cmd);
            
            if (status == 0)
                disp(['Scipion process launched with PID: ' cmdout]);
            else
                error(['Scipion process spawning failed with exit ' ...
                       'code %d'], status);
            end
        end
        
        function filename = getVolume(projectName, proteinType, id)
            % GETVOLUME Gets protein volume data from a file.
            %
            % Inputs
            % ------
            % project name : str
            %     The name of the project containing the data.
            % protein_type : str
            %     Are we extracting the reference protein 'ref' or the
            %     protein of interest 'poi'?
            % id : int
            %     The Scipion run ID that generated the volume data.
            %
            env = utils.SpartanEnv.getEnvironment();
            root = fullfile(env.scipionUserDataPath, 'projects', ...
                            projectName, 'Runs');
            if strcmp(proteinType, 'ref')
                token = fullfile('_XmippProtProjMatch', 'extra', ...
                                 'iter_004', ...
                                 'reconstruction_filtered_Ref3D_001.vol');
            elseif strcmp(proteinType, 'poi')
                token = fullfile('_EmanProtReconstruct', 'extra', ...
                                 'volume.hdf');
            else
                error(['Error: proteinType must be either ''ref'' or '...
                      '''poi'' but got ' proteinType ' instead.']);
            end
            
            filename = strcat(sprintf('%06d', id), token);
            filename = fullfile(root, filename);                   
        end
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
            % scipionSource : str (optional)
            %     A name/value pair that determines the Scipion source.
            %     Current options are 'native' and 'docker'. The default is
            %     'native'.
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
            addParameter(p, 'scipionSource', 'native', @ischar);
            
            parse(p, projectName, pairedAnalysis, pathToRefMontage, ...
                  varargin{:});
            
            obj.projectName = p.Results.projectName;
            obj.pairedAnalysis = p.Results.pairedAnalysis;
            obj.pathToRefMontage = p.Results.pathToRefMontage;
            obj.refLabel = p.Results.refLabel;
            obj.poiLabel = p.Results.poiLabel;
            obj.scipionSource = p.Results.scipionSource;
            
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
        
        function launchWorkflow(obj)
            % LAUNCHWORKFLOW Launches the Scipion session.
            %          
            src = obj.scipionSource;
            switch lower(src)
                case {'native'}
                    obj.launchNativeWorkflow();
                case {'docker'}
                    obj.launchDockerWorkflow();
                otherwise
                    error(['Error: argument' src ' not recognized. ' ... 
                           'Must be either ''native'' or ''docker''']);
            end
        end
        
        function launchManager(obj)
            % LAUNCHMANAGER Launches the Scipion manager window.
            %
            src = obj.scipionSource;
            switch lower(src)
                case {'native'}
                    obj.launchNativeManager();
                case {'docker'}
                    obj.launchDockerManager();
                otherwise
                    error('Error: Unable to launch Scipion''s manager.');
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
            
            % Change the path to the Docker container file system if using
            % the Scipion Docker container.
            if strcmp('docker', obj.scipionSource)
                refPath = obj.CONTAINER_INPUT_PATH;
                pairPath = obj.CONTAINER_INPUT_PATH;
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
        
        function launchDockerWorkflow(obj)
            % LAUNCHDOCKERWORKFLOW Launches a Docker-based Scipion session.
            assert(~isempty(obj.workflow), ...
                ['Assertion failed: workflow file was not generated ' ...
                 'from template.']);
            
            % Creates the Scipion workflow .json file.
            jsonFilename = strcat(tempname, '.json');
            fid = fopen(jsonFilename, 'w');
            fprintf(fid, '%s', obj.workflow);
            fclose(fid);

            try
                % Clean the input volume
                cmd = strcat({'docker volume rm '}, obj.DOCKER_INPUT_VOLUME);
                cmd = cmd{1};
                system(cmd);
                
                % Creates the dummy container.
                cmd = strcat({'docker container create --name dummy -v '}, ...
                             obj.DOCKER_INPUT_VOLUME, {':/home/scipion/inputs hello-world'});
                cmd = cmd{1};
                disp('Creating dummy data container...');
                [status, ~] = system(cmd);
                assert(status == 0, ...
                       'Error: Failed to create the dummy container.')
                
                % Copies the data into the Scipion input Docker volume.
                disp('Copying data into Docker volume...');
                cmd = strcat({'docker cp '}, jsonFilename, {' dummy:/home/scipion/inputs'});
                cmd = cmd{1};
                [status, ~] = system(cmd);
                assert(status == 0, ...
                       'Error: Failed to copy .json workflow into the volume.')
                   
                cmd = strcat({'docker cp '}, obj.pathToRefMontage, {' dummy:/home/scipion/inputs'});
                cmd = cmd{1};
                [status, ~] = system(cmd);
                assert(status == 0, ...
                       'Error: Failed to copy reference montage into the volume.')
                
                cmd = strcat({'docker cp '}, obj.pathToPoiMontage, {' dummy:/home/scipion/inputs'});
                cmd = cmd{1};
                [status, ~] = system(cmd);
                assert(status == 0, ...
                       'Error: Failed to copy protein of interest montage into the volume.')   
                   
                % Remove the dummy container.
                cmd = 'docker container rm dummy';
                disp('Removing dummy container...');
                system(cmd);
            catch ME
                % Remove the dummy container.
                cmd = 'docker container rm dummy';
                disp('Removing dummy container...');
                system(cmd);
                
                rethrow(ME);
            end
            
            % Get just the json filename.
            [~, name, ext] = fileparts(jsonFilename);
            jsonDockerFilename = strcat('/home/scipion/inputs/', name, ext);
            
            disp('Creating the Scipion project...');
            cmd = strcat({['docker run -it --rm ' ...
                           '    --name Scipion ' ...
                           '    --mount type=bind,source=' ...
                           obj.spartanEnv.scipionUserDataPath ...
                           ',target=/home/scipion/ScipionUserData ' ...
                           '    --mount source=ScipionInputData,target=/home/scipion/inputs ' ...
                           '    epflbiophys/scipion:1.2 ' ...
                           '    ./scipion run python scripts/create_project.py']}, ...
                         {' '}, obj.projectName, {' '}, jsonDockerFilename, ...
                         {' '}, obj.pathToProject);
            cmd = cmd{1};
            [status, cmdout] = system(cmd);
            if (status ~= 0); disp(cmdout); end
            assert(status == 0, ...
                   'Error: Failed to create a new Scipion project.');
                        
            % Launch Scipion
            disp('Launching Scipion...')
            cmd = ['docker run -it --rm -d' ...
                   '    --name Scipion ' ...
                   '    --mount type=bind,source=' ...
                   obj.spartanEnv.scipionUserDataPath ...
                   ',target=/home/scipion/ScipionUserData ' ...
                   '    --mount source=ScipionInputData,target=/home/scipion/inputs ' ...
                   '    -e DISPLAY=$DISPLAY ' ...
                   '    -v /tmp/.X11-unix:/tmp/.X11-unix ' ...
                   '    epflbiophys/scipion:1.2'];
               
            [status, cmdout] = system(cmd);
            if (status == 0)
                obj.PID = cmdout;
                disp(['Scipion process launched in Docker container: ' cmdout]);
            end

        end
        
        function launchNativeWorkflow(obj)
            % LAUNCHNATIVEWORKFLOW Launches a native Scipion session.
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

