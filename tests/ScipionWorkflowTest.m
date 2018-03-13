% Copyright (C) 2018 Laboratory of Experimental Biophysics
% Ecole Polytechnique Federale de Lausanne
%
% Author: Kyle M. Douglass
%

classdef ScipionWorkflowTest < matlab.unittest.TestCase
    %SCIPIONWORKFLOWTEST Unit tests for the ScipionWorkflow class.
    % To run this test, execute the command
    % 
    %   result = runtests('ScipionWorkflowTest.m');
    %
    % This must be executed after a basic Spartan environment has been
    % setup with Scipion environment variables.
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
            %TEARDOWN Cleans up the test environment.
            
            % Find the Scipion user data path
            import utils.SpartanEnv;
            env = utils.SpartanEnv.getEnvironment();
            
            if isempty(env.scipionPath)
                error('ScipionWorkflowTest:emptyScipionPath',...
                      ['Error. \nThe path to the Scipion folder is ' ...
                       'empty. Please add it to the Spartan '...
                       'environment variables.']);
            end
            
            scipionScript = fullfile(env.scipionPath,'scipion');
            cmd = strcat(scipionScript, ' printenv');
            [status, cmdout] = system(cmd);
            assert(status == 0, ['Error: Failure to use Scipion to '...
                                 'retreive environment variables.']);
            pattern = 'SCIPION_USER_DATA="(.*?)"';
            [start, stop] = regexp(cmdout, pattern);
            line = cmdout(start:stop);
            q = strfind(line, '"'); % Extract data between quotes
            userDataDir = line(q(1) + 1:q(2) - 1);
            
            % Remove the test project folder
            projectDir = fullfile(userDataDir, 'projects', testCase.PROJECTNAME);
            cmd = strcat({'rm -rf '}, projectDir);
            cmd = cmd{1};
            [status, ~] = system(cmd);
            
            assert(status == 0, 'Error: Failure to cleanup test project.');
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
            % LAUNCHPAIREDWORKFLOWTEST Unit test for Scipion.
            % This unit test verifies that a new Scipion project may be
            % launched with a premade workflow for doing paired protein
            % analyses.
            import em.ScipionWorkflow;
            pairedAnalysis = true;
            swf = ScipionWorkflow(testCase.PROJECTNAME, pairedAnalysis, ...
                                  testCase.tempFolderRef, ...
                                  testCase.REFLABEL, ...
                                  testCase.tempFolderPair, ...
                                  testCase.POILABEL);
            swf.launchWorkflow();
            
            % Kill Scipion
            assert(~isempty(swf.PID), 'Error: Scipion PID not assigned.');
            
            [status, cmdout] = system(['kill ' num2str(swf.PID)]);
            
            assert(status == 0);
        end
    end
end