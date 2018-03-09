% Copyright (C) 2018 Laboratory of Experimental Biophysics
% Ecole Polytechnique Federale de Lausanne
%
% Author: Kyle M. Douglass
%

classdef PackageInterface < handle
    % The interface for wrapping calls to EM SPA workflows.
    
    properties (SetAccess = protected, GetAccess = public)
        pairedAnalysis;
        % Determines whether a single protein workflow or a paired protein
        % workflow will be launched.
        
        pathToMontage1;
        % The full path to the montage of single particle images for the
        % first protein.
        
        pathToMontage2 = '';
        % The full path to the montage of single particle images for the
        % second protein; this is required if pairedAnalysis is set to
        % true and ignored if it is set to False.
    end
    
    properties (SetAccess = protected, GetAccess = protected)
        spartanEnv = utils.SpartanEnv.getEnvironment();
        % A copy of the Spartan environment variables.
    end
    
    methods (Abstract)
        launchWorkflow(obj);
        % Launches the EM analysis software.
    end
    
    methods
        function set.pairedAnalysis(obj, paired)
            obj.pairedAnalysis = paired;
        end
        
        function pa = get.pairedAnalysis(obj)
            pa = obj.pairedAnalysis;
        end
        
        function m1 = get.pathToMontage1(obj)
            m1 = obj.pathToMontage1;
        end
        
        function m2 = get.pathToMontage2(obj)
            m2 = obj.pathToMontage2;
        end
    end
end