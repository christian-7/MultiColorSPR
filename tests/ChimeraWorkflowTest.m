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
    properties (SetAccess = private)
        env = [];
    end
    
    methods (TestMethodSetup)
        function setUp(testCase)     
            import utils.SpartanEnv;
            testCase.env = utils.SpartanEnv.getEnvironment();                  
        end   
    end
    
    methods (Static)
        function checkChimera()
            % CHECKCHIMERA Checks for Chimera.
            % This function verifies that Chimera's path is set in the
            % Spartan environment variables and that the Chimera launch
            % script is callable.
            env = testCase.env;
            
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
        function testCheckChimera(testCase)
            % TESTCHECKCHIMERA Checks for Chimera.
            % This function verifies that Chimera's path is set in the
            % Spartan environment variables and that the Chimera launch
            % script is callable.            
            if isempty(testCase.env.chimeraPath)
                error('ChimeraWorkflowTest:emptyChimeraPath',...
                      ['Error. \nThe path to the Chimera folder is ' ...
                       'empty. Please add it to the Spartan '...
                       'environment variables.']);
            end
            
            chimeraScript = fullfile(testCase.env.chimeraPath, 'bin', ...
                                     'chimera');
            cmd = strcat(chimeraScript, ' --version');
            [status, cmdout] = system(cmd);
            
            if status == 0
                disp('Chimera detected on this system.');
                disp(':)')
            else
                disp(cmdout);
                error('ChimeraWorkflowTest:ChimeraNotCallable',...
                      'Error. \nCould not call Chimera start script.');
            end
        end
 
        function testFitInMap(testCase)
            % TESTFITINMAP Verifies the Chimera script works.
            %
            t1 = fullfile(testCase.env.spartanPath, 'tests', ...
                          'resources', ...
                          'reconstruction_filtered_Ref3D_001.vol');
            t2 = fullfile(testCase.env.spartanPath, 'tests', ...
                          'resources', 'volume.hdf');
                      
            % Function to test
            pid = em.ChimeraWorkflow.fitInMap(t1, t2);
            
            % Wait for program to open.
            pause(15)
            
            % Kill Chimera
            [status, ~] = system(['kill ' num2str(pid)]);
            assert(status == 0);
        end
        
        function testTransformCoordinates(testCase)
            % TESTTRANSFORMCOORDINATES Verifies the Chimera script works.
            %                
            t1 = fullfile(testCase.env.spartanPath, 'tests', ...
                          'resources', ...
                          'reconstruction_filtered_Ref3D_001.vol');
            t2 = fullfile(testCase.env.spartanPath, 'tests', ...
                          'resources', 'volume.hdf');
            
            % Function to test
            pid = em.ChimeraWorkflow.transformCoordinates(t1, t2, 5, 5, 5);
            
            % Wait for program to open.
            pause(10)
            
            % Kill Chimera
            [status, ~] = system(['kill ' num2str(pid)]);
            assert(status == 0);
        end
    end
end