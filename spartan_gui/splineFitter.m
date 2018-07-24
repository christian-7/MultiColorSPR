function varargout = splineFitter(varargin)
% SPLINEFITTER MATLAB code for splineFitter.fig
%      SPLINEFITTER, by itself, creates a new SPLINEFITTER or raises the existing
%      singleton*.
%
%      H = SPLINEFITTER returns the handle to a new SPLINEFITTER or the handle to
%      the existing singleton*.
%
%      SPLINEFITTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPLINEFITTER.M with the given input arguments.
%
%      SPLINEFITTER('Property','Value',...) creates a new SPLINEFITTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before splineFitter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to splineFitter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help splineFitter

% Last Modified by GUIDE v2.5 24-Jul-2018 20:58:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @splineFitter_OpeningFcn, ...
                   'gui_OutputFcn',  @splineFitter_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before splineFitter is made visible.
function splineFitter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to splineFitter (see VARARGIN)

% Choose default command line output for splineFitter
handles.output = hObject;


% Store the default parameters 

handles.conversion = 0.48;
handles.offset     = 163.65;
handles.filter     = 1.2;
handles.cutoff     = 5;
handles.ROIsize    = 15;
handles.pxl_size   = 106;



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes splineFitter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = splineFitter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cutoff_Callback(hObject, eventdata, handles)
% hObject    handle to cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cutoff as text
%        str2double(get(hObject,'String')) returns contents of cutoff as a double

handles = guidata(hObject);

handles.cutoff = str2double(get(hObject,'String'))

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function cutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ROIsize_Callback(hObject, eventdata, handles)
% hObject    handle to ROIsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ROIsize as text
%        str2double(get(hObject,'String')) returns contents of ROIsize as a double

handles = guidata(hObject);

handles.ROI_size = str2double(get(hObject,'String'))

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function ROIsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROIsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pxl_size_Callback(hObject, eventdata, handles)
% hObject    handle to pxl_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pxl_size as text
%        str2double(get(hObject,'String')) returns contents of pxl_size as a double

handles = guidata(hObject);

handles.pxl_size = str2double(get(hObject,'String'))

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function pxl_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pxl_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function offset_Callback(hObject, eventdata, handles)
% hObject    handle to offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offset as text
%        str2double(get(hObject,'String')) returns contents of offset as a double

handles = guidata(hObject);

handles.offset = str2double(get(hObject,'String'))

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filtersize_Callback(hObject, eventdata, handles)
% hObject    handle to filtersize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filtersize as text
%        str2double(get(hObject,'String')) returns contents of filtersize as a double


% --- Executes during object creation, after setting all properties.
function filtersize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtersize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in inputPath.
function inputPath_Callback(hObject, eventdata, handles)
% hObject    handle to inputPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

handles.inputPath = uigetdir;

set(handles.statusText, 'String', ['Input Path = ' handles.inputPath]);

guidata(hObject, handles);

% --- Executes on button press in outputPath.
function outputPath_Callback(hObject, eventdata, handles)
% hObject    handle to outputPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

handles.outputPath = uigetdir;

set(handles.statusText, 'String', ['Output Path = ' handles.outputPath]);

guidata(hObject, handles);

% --- Executes on button press in calibPath.
function calibPath_Callback(hObject, eventdata, handles)
% hObject    handle to calibPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

[file,path] = uigetfile('*.mat');
if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected Calibration File', fullfile(path,file)]);
end

handles.calibFile = fullfile(path,file);

set(handles.statusText, 'String', ['User selected Calibration File = ' fullfile(path,file)]);

guidata(hObject, handles);


% --- Executes on button press in VarmapPath.
function VarmapPath_Callback(hObject, eventdata, handles)
% hObject    handle to VarmapPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

[file,path] = uigetfile('*.mat');

if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected Variance Map', fullfile(path,file)]);
end

handles.Varmap = load(fullfile(path,file));

set(handles.statusText, 'String', ['User selected Variance Map = ' fullfile(path,file)]);


guidata(hObject, handles);



function conversion_Callback(hObject, eventdata, handles)
% hObject    handle to conversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conversion as text
%        str2double(get(hObject,'String')) returns contents of conversion as a double

handles = guidata(hObject);

handles.conversion = str2double(get(hObject,'String'))

guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function conversion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startLoc.
function startLoc_Callback(hObject, eventdata, handles)
% hObject    handle to startLoc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);
handles
for i = 1%:size(image_files,1);
    
image_name  = handles.image_files(i).name;
base        = regexp(image_name,'\.','split');

% input_file  = ['path=[' input_folder '\' image_name ']']; % if using normal stack import
input_file  = ['open=[' handles.inputPath '\' image_name ']'];   % if using virtual stack import
output_file = [handles.temp_folder '\' base{1} '_LocalizationsPC4.csv'];

image_files(i).output = output_file; % Save the output path

% MIJ.run('Open...', input_file); % Open tiff stack

MIJ.run('TIFF Virtual Stack...', input_file); % Open virtual tiff stack

tic

p                   = {};
p.imagefile         = '';
p.calfile           = handles.calibFile;
p.offset            = handles.offset;  % in ADU
p.conversion        = handles.conversion;    % e/ADU
p.previewframe      = false;
p.peakfilter        = handles.filter;  % filter size (pixel)
p.peakcutoff        = handles.cutoff;    % photons
p.roifit            = handles.ROIsize;   % ROI size (pixel)
p.bidirectional     = false; % 2D
p.mirror            = false;
p.status            = '';
p.outputfile        = output_file;
p.outputformat      = 'csv';
p.pixelsize         = handles.pxl_size;
p.loader            = 3; % {'simple tif','ome loader','ImageJ'}
p.mij               = MIJ;
p.backgroundmode    = 'Difference of Gaussians (fast)';
p.preview           = false;
p.isscmos           = false;
p.scmosfile         = handles.var_map;
p.mirror            = false;

textLabel = sprintf('Starting localization ...');
set(handles.statusText, 'String', textLabel);

simplefitter_cspline(p);

textLabel = sprintf(['\n -- Finished processing substack ' num2str(i) ' of ' num2str(size(image_files,1)) ' in ' num2str(toc/60) ' min -- \n']);
set(handles.statusText, 'String', textLabel);


MIJ.run('Close All');

end

% Combine files and save as single localization file

cd(handles.temp_folder); all_locs = [];

% Load Header

file = fopen(image_files(1).output);
line = fgetl(file);
h    = regexp( line, ',', 'split' );

for i = 1:size(image_files,1);

    locs     = [];
    locs     = dlmread(image_files(i).output,',',1,0);
    all_locs = vertcat(all_locs,locs);
    
end

delete .csv
new_name_temp   = regexp(base{1},'_','split');
new_name        = [new_name_temp{1,1} '_' new_name_temp{1,2} '_' new_name_temp{1,3} '_Localizations.csv'];

cd(output_folder);

fileID = fopen([base{1} '_Localizations.csv'],'w');
fprintf(fileID,[[line] ' \n']);
dlmwrite([base{1} '_Localizations.csv'],all_locs,'-append');
fclose('all');

guidata(hObject, handles); % Update handles structure



% --- Executes on button press in initSpline.
function initSpline_Callback(hObject, eventdata, handles)

% hObject    handle to initSpline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

[handles.var_map,handles.image_files,handles.temp_folder] = initializeSpline(handles.outputPath,handles.inputPath,handles.Varmap.varOffset);

textLabel = sprintf('Initialized');
set(handles.statusText, 'String', textLabel);

guidata(hObject, handles); % Update handles structure
