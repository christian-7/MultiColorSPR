% Copyright (C) 2018 Laboratory of Experimental Biophysics
% Ecole Polytechnique Federale de Lausanne
%
% Author: Kyle M. Douglass
%

classdef PackageInterface < handle
    % The interface for wrapping calls to EM SPA workflows.
    
    properties (SetAccess = protected, GetAccess = public)
        % Determines whether a single protein workflow or a paired protein
        % workflow will be launched.
        pairedAnalysis;
        
        % The full path (including filename) to the montage of single
        % particle images for the reference protein.
        pathToRefMontage;
        
        % The full path (including filename) to the montage of single
        % particle images for the second protein of interest; this is
        % required if pairedAnalysis is set to true and ignored if it is
        % set to False.
        pathToPairMontage = '';
        
    end
    
    properties (SetAccess = protected, GetAccess = protected)
        % A copy of the Spartan environment variables.
        spartanEnv = utils.SpartanEnv.getEnvironment();
    
    end
    
    methods (Abstract)
        % Launches the EM analysis software.
        launchWorkflow(obj);
        
    end
    
    methods
        function set.pairedAnalysis(obj, paired)
            obj.pairedAnalysis = paired;
        end
        
        function pa = get.pairedAnalysis(obj)
            pa = obj.pairedAnalysis;
        end
        
        function m1 = get.pathToRefMontage(obj)
            m1 = obj.pathToRefMontage;
        end
        
        function m2 = get.pathToPairMontage(obj)
            m2 = obj.pathToPairMontage;
        end
        
    end
end