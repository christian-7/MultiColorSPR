% Copyright (C) 2018 Laboratory of Experimental Biophysics
% Ecole Polytechnique Federale de Lausanne
%
% Author: Kyle M. Douglass
%

classdef (Sealed) SpartanEnv < handle
    %SPARTANENV Environment variables for Spartan.
    % Please note that the SpartanEnv class is a singleton; only one
    % instance will ever exist at a time.
    
    methods (Access = private)
        function obj = SpartanEnv()
        end
    end
    
    methods (Static)
        function spartanEnv = getEnvironment()
            % Returns the Spartan environment variables.
            persistent localObj;
            if isempty(localObj) || ~isvalid(localObj)
                localObj = utils.SpartanEnv();
            end
            spartanEnv = localObj;
        end
    end
    
    properties
        scipionPath = '';
    end
end

