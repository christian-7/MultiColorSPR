function [WFCh1,WFCh2,locsCh1,locsCh2,h] = openFiles(fileInfo);

    % Load WF images
    
    cd(fileInfo{1,3})
    WFCh1 = imread(fileInfo{1,4});
    
    cd(fileInfo{2,3})
    WFCh2 = imread(fileInfo{2,4});
    
    fprintf('\n -- Loaded WF images, loading locs now ... -- \n');

    
    % Load locs

    cd(fileInfo{1,1});
    locsCh1          = dlmread([fileInfo{1,2}],',',1,0); 
    
    cd(fileInfo{2,1});
    locsCh2          = dlmread([fileInfo{2,2}],',',1,0); 
    
    % Read the header
    
    cd(fileInfo{1,1});
    file            = fopen(fileInfo{1,2});
    handles.line    = fgetl(file);
    h               = regexp(handles.line, ',', 'split' );
    
end


