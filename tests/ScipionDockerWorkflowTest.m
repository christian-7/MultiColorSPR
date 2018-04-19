% Copyright (C) 2018 Laboratory of Experimental Biophysics
% Ecole Polytechnique Federale de Lausanne
%
% Author: Kyle M. Douglass
%

classdef ScipionDockerWorkflowTest < matlab.unittest.TestCase
    %SCIPIONDOCKERWORKFLOWTEST Unit tests for the ScipionWorkflow class.
    % 
    % These unit tests are for native Scipion installations only.
    %
    % To run this test, execute the command
    % 
    %   result = runtests('ScipionDockerWorkflowTest.m');
    %
    % This test requires Docker to be installed on your system.
    %
    properties
        tempFolderProj;
        tempFolderRef;
        tempFolderPair;
    end
    
    properties (Constant)
        PROJECTNAME = 'Scipion_Test_Project';
        REFLABEL = 'Test_Reference';
        POILABEL = 'Test_POI';
    end
    
    methods (TestMethodSetup)
        function setUp(testCase)     
            %SETUP Sets up the test environment
            %
            testCase.checkScipion();
            
            import matlab.unittest.fixtures.TemporaryFolderFixture;
            testCase.tempFolderProj = ...
                testCase.applyFixture(TemporaryFolderFixture).Folder;
            testCase.tempFolderRef = ...
                testCase.applyFixture(TemporaryFolderFixture).Folder;
            testCase.tempFolderPair = ...
                testCase.applyFixture(TemporaryFolderFixture).Folder;                   
        end
    end
    
    methods (TestMethodTeardown)
        function tearDown(testCase)
            env = utils.SpartanEnv.getEnvironment();
            
            cmd = strcat({['docker run -it --rm ' ...
                           '    --name Scipion ' ...
                           '    --mount type=bind,source=' ...
                           env.scipionUserDataPath ...
                           ',target=/home/scipion/ScipionUserData ' ...
                           '    --mount source=ScipionInputData,target=/home/scipion/inputs ' ...
                           '    epflbiophys/scipion:1.2 ' ...
                           '    rm -rf /home/scipion/ScipionUserData/projects/']}, ...
                          testCase.PROJECTNAME);
            cmd = cmd{1};
            [status, cmdout] = system(cmd);
            disp(cmdout);
            assert(status == 0, ...
                   'Error cleaning up test environment.');
        end
    end
    
    methods (Static)
        function checkScipion()
            %CHECKSCIPION Checks for Scipion.
            % This function verifies that Scipion's path is set in the
            % Spartan environment variables and that the scipion script is
            % callable.
            import utils.SpartanEnv;
            env = utils.SpartanEnv.getEnvironment();
            
            if isempty(env.scipionPath)
                error('ScipionWorkflowTest:emptyScipionPath',...
                      ['Error. \nThe path to the Scipion folder is ' ...
                       'empty. Please add it to the Spartan '...
                       'environment variables.']);
            end
            
            scipionScript = fullfile(env.scipionPath,'scipion');
            cmd = strcat(scipionScript, ' help');
            [status, cmdout] = system(cmd);
            
            if status == 0
                disp('Scipion detected on this system.');
            else
                disp(cmdout);
                error('ScipionWorkflowTest:ScipionNotCallable',...
                      'Error. \nCould not call Scipion start script.');
            end
        end
    end
    
    methods (Test)
        function launchPairedWorkflowTest(testCase)
            % LAUNCHPAIREDWORKFLOWTEST Unit test for Docker Scipion.
            % This unit test verifies that a new Scipion project may be
            % launched with a premade workflow for doing paired protein
            % analyses. It launches a native Scipion installation.
            import em.ScipionWorkflow;
            pairedAnalysis = true;
            swf = ScipionWorkflow(testCase.PROJECTNAME, ...
                                  pairedAnalysis, ...
                                  testCase.tempFolderRef, ...
                                  testCase.REFLABEL, ...
                                  testCase.tempFolderPair, ...
                                  testCase.POILABEL, ...
                                  'scipionSource', 'docker');
            swf.launchWorkflow();
            
            % Kill Scipion
            assert(~isempty(swf.PID), ...
                   'Error: Docker container not assigned.');
               
            [status, cmdout] = system(['docker container stop ' ...
                                        num2str(swf.PID)]);
            disp(cmdout);
            
            assert(status == 0);
        end
    end
end