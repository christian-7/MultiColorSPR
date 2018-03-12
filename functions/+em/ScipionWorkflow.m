% Copyright (C) 2018 Laboratory of Experimental Biophysics
% Ecole Polytechnique Federale de Lausanne
%
% Author: Kyle M. Douglass
%

classdef ScipionWorkflow < em.PackageInterface
    %SCIPIONWORKFLOW Launches a pre-specified Scipion workflow.
    
    properties (SetAccess = private, GetAccess = public)
        workflow = '';
        refLabel;
        poiLabel = 'poi';
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
                pairedAnalysis, pathToRefMontage, refLabel, varargin ...
        )
            % SCIPIONWORKFLOW Create the Scipion package wrapper.
            %
            % Inputs
            % ------
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
                'Assertion failed: workflow was not generated.');
            
            % Creates the Scipion workflow .json file.
            filename = strcat(tempname, '.json');
            fid = fopen(filename, 'w');
            fprintf(fid, '%s', obj.workflow);
            fclose(fid);
            
            % Create the Scipion project derived from the workflow.
            disp('Todo.');
            
            % Launch the Scipion subprocess.
            disp('Todo.');
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

