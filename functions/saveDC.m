function saveDC(locs_Ch1_DC, locs_Ch2_corr, handles);

locs_Ch1_toSave       = locs_Ch1_DC(:,1:8);
locs_Ch1_toSave(:,9)  = locs_Ch1_DC(:,handles.deltaXCol);
locs_Ch1_toSave(:,10) = locs_Ch1_DC(:,handles.deltaYCol);

NameCorrected = [handles.Name_Ch1 '_DC.csv'];

cd(handles.Path_Ch1);

fileID = fopen(NameCorrected,'w');
fprintf(fileID,[[handles.line,',dx [nm],dy [nm]'] ' \n']);
dlmwrite(NameCorrected,locs_Ch1_toSave,'-append');
fclose('all');

fprintf('\n -- Saved Ch1 --\n');

locs_Ch2_toSave       = locs_Ch2_corr(:,1:8);
locs_Ch2_toSave(:,9)  = locs_Ch2_corr(:,handles.deltaXCol);
locs_Ch3_toSave(:,10) = locs_Ch2_corr(:,handles.deltaYCol);

NameCorrected = [handles.Name_Ch2 '_DC_transformed.csv'];

cd(handles.Path_Ch2);

fileID = fopen(NameCorrected,'w');
fprintf(fileID,[[handles.line,',dx [nm],dy [nm]'] ' \n']);
dlmwrite(NameCorrected,locs_Ch2_toSave,'-append');
fclose('all');

fprintf('\n -- Saved Ch2 --\n');

end