% Copyright (C) 2018 Laboratory of Experimental Biophysics
% Ecole Polytechnique Federale de Lausanne
%
% Author: Kyle M. Douglass
%

classdef ChimeraWorkflowTest < matlab.unittest.TestCase
    % CHIMERAWORKFLOWTEST Unit tests for the ChimeraWorkflow class.
    %
    % To run this test, execute the command
    % 
    %   result = runtests('ChimeraWorkflowTest.m');
    %
    
    methods (TestMethodSetup)
        function setUp(testCase)     
             testCase.checkChimera();                 
        end   
    end
    
    methods (Static)
        function checkChimera()
            % CHECKCHIMERA Checks for Chimera.
            % This function verifies that Chimera's path is set in the
            % Spartan environment variables and that the Chimera launch
            % script is callable.
            import utils.SpartanEnv;
            env = utils.SpartanEnv.getEnvironment();
            
            if isempty(env.chimeraPath)
                error('ChimeraWorkflowTest:emptyChimeraPath',...
                      ['Error. \nThe path to the Chimera folder is ' ...
                       'empty. Please add it to the Spartan '...
                       'environment variables.']);
            end
            
            chimeraScript = fullfile(env.chimeraPath, 'bin', 'chimera');
            cmd = strcat(chimeraScript, ' --version');
            [status, cmdout] = system(cmd);
            
            if status == 0
                disp('Chimera detected on this system.');
            else
                disp(cmdout);
                error('ChimeraWorkflowTest:ChimeraNotCallable',...
                      'Error. \nCould not call Chimera start script.');
            end
        end
    end
    
    methods (Test)
        function testTest(testCase)
            % TESTTEST Unit test for launching Chimera.
            %
            disp(':)')
        end
    end
end