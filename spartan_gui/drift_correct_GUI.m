function varargout = drift_correct_GUI(varargin)
% DRIFT_CORRECT_GUI MATLAB code for drift_correct_GUI.fig
%      DRIFT_CORRECT_GUI, by itself, creates a new DRIFT_CORRECT_GUI or raises the existing
%      singleton*.
%
%      H = DRIFT_CORRECT_GUI returns the handle to a new DRIFT_CORRECT_GUI or the handle to
%      the existing singleton*.
%
%      DRIFT_CORRECT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRIFT_CORRECT_GUI.M with the given input arguments.
%
%      DRIFT_CORRECT_GUI('Property','Value',...) creates a new DRIFT_CORRECT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before drift_correct_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to drift_correct_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help drift_correct_GUI

% Last Modified by GUIDE v2.5 08-Mar-2018 22:43:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @drift_correct_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @drift_correct_GUI_OutputFcn, ...
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


% --- Executes just before drift_correct_GUI is made visible.
function drift_correct_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to drift_correct_GUI (see VARARGIN)

% Choose default command line output for drift_correct_GUI
handles.output = hObject;

% Set the default GUI Input

handles.locs_Ch1    = [];
handles.locs_Ch2    = [];
handles.Affine      = [];
handles.pxlSizeFid  = 600;
handles.selectedFid = 1;

handles.NbrBins 	= 100;
handles.FilterRad   = 200;
handles.smoothF     = 100;
handles.startFrame 	= 2000;

% Check if data is there

    if isempty(handles.Affine)==0;
    
    set(handles.loadAffine,'BackgroundColor','green');
    
    else end
    
    if isempty(handles.locs_Ch1)==0;
    
    set(handles.openLocCh1,'BackgroundColor','green');
    
    else end
    
    if isempty(handles.locs_Ch2)==0;
    
    set(handles.openLocCh2,'BackgroundColor','green');
    
    else end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes drift_correct_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = drift_correct_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in openLocCh1.
function openLocCh1_Callback(hObject, eventdata, handles)
% hObject    handle to openLocCh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    handles = guidata(hObject);

% Create a file dialog for images

    [FileName_Ch1,Path_Ch1] = uigetfile({'*.csv';'*.dat'},'Select Loc file Ch1');
    
    % Read the selected file into the variable
    
    disp('Reading Localization file ...');
    
    [path,Name_Ch1,ext_Ch1] = fileparts(FileName_Ch1);
    
    handles.Ext_Ch1     = ext_Ch1;
    handles.Path_Ch1    = Path_Ch1;
    handles.Name_Ch1    = Name_Ch1;
    
    cd(Path_Ch1);
    
    handles.locs_Ch1          = dlmread([Name_Ch1 ext_Ch1],',',1,0); 
    handles.locs_Ch1(:,end+1) = 1; % Channel ID

    
    % Read the header
    
    file = fopen([Name_Ch1 ext_Ch1]);
    line = fgetl(file);
    h    = regexp( line, ',', 'split' );

    handles.xCol      = strmatch('x [nm]',h);
    handles.yCol      = strmatch('y [nm]',h);
    handles.frameCol  = strmatch('frame',h);
    handles.RegionID  = size(handles.locs_Ch1,2)+1; 
    handles.deltaXCol = size(handles.locs_Ch1,2)+2;
    handles.deltaYCol = size(handles.locs_Ch1,2)+3;
    
    if isempty(handles.locs_Ch1)==0;
    
    set(handles.openLocCh1,'BackgroundColor','green');
    
    else end
    
    disp('Localization file loaded');

    guidata(hObject, handles); % Update handles structure



% --- Executes on button press in openLocCh2.
function openLocCh2_Callback(hObject, eventdata, handles)
% hObject    handle to openLocCh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    handles = guidata(hObject);

% Create a file dialog for images

    [FileName_Ch2,Path_Ch2] = uigetfile({'*.csv';'*.dat'},'Select Loc file Ch2');
    
    % Read the selected file into the variable
    
    disp('Reading Localization file ...');
    
    [path,Name_Ch2,ext_Ch2] = fileparts(FileName_Ch2);
    
    handles.Ext_Ch2     = ext_Ch2;
    handles.Path_Ch2    = Path_Ch2;
    handles.Name_Ch2    = Name_Ch2;
    
    cd(Path_Ch2);
    
    handles.locs_Ch2    = dlmread([Name_Ch2 ext_Ch2],',',1,0); 
    handles.locs_Ch2(:,end+1) = 2; % Channel ID
    
    if isempty(handles.locs_Ch2)==0;
    
    set(handles.openLocCh2,'BackgroundColor','green');
    
    else end
    
    disp('Localization file loaded');
    
    guidata(hObject, handles) % Update handles structure


% --- Executes on button press in loadAffine.
function loadAffine_Callback(hObject, eventdata, handles)
% hObject    handle to loadAffine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    handles = guidata(hObject);

% Create a file dialog for images

    [FileName_Aff,Path_Aff] = uigetfile({'*.mat'},'Select Affine Transformation')
    
    % Read the selected file into the variable
   
    cd(Path_Aff);
    
    handles.Affine    = load(FileName_Aff); 
    
    if isempty(handles.Affine)==0;
    
    set(handles.loadAffine,'BackgroundColor','green');
    
    else end
    
    disp('Affine T loaded');
    
    guidata(hObject, handles) % Update handles structure


% --- Executes on button press in applyAffine.
function applyAffine_Callback(hObject, eventdata, handles)
% hObject    handle to applyAffine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

moving = []; moving = handles.locs_Ch2(:,handles.xCol:handles.yCol);

corrected_moving = transformPointsInverse(handles.Affine.T_lwm,moving);

handles.locs_Ch2(:,handles.xCol) = corrected_moving(:,1);
handles.locs_Ch2(:,handles.yCol) = corrected_moving(:,2);

% Filter out of bound points

locs_Ch2_filtered           = [];
locs_Ch2_filtered           = handles.locs_Ch2(handles.locs_Ch2(:,handles.xCol)<1e5,1:end);
handles.locs_Ch2            = locs_Ch2_filtered;

set(handles.applyAffine,'BackgroundColor','green');

guidata(hObject, handles) % Update handles structure
    


% --- Executes on button press in selectFid.
function selectFid_Callback(hObject, eventdata, handles)
% hObject    handle to selectFid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

[handles.Fid_Ch1,handles.Fid_Ch2] = selectFiducial(handles.locs_Ch1,handles.locs_Ch2,handles);

guidata(hObject, handles) % Update handles structure





function pxlSizeFid_Callback(hObject, eventdata, handles)
% hObject    handle to pxlSizeFid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pxlSizeFid as text
%        str2double(get(hObject,'String')) returns contents of pxlSizeFid as a double


handles = guidata(hObject);
handles.pxlSizeFid = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function pxlSizeFid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pxlSizeFid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in averageFid.
function averageFid_Callback(hObject, eventdata, handles)
% hObject    handle to averageFid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

[handles.Avg_Ch1_new, handles.Avg_Ch2_new] = averageFiducials(handles.selectedFid, handles);

fprintf('\n -- Fiducial Tracks Averaged --\n')

guidata(hObject, handles); % Update handles structure


function UserselectedFid_Callback(hObject, eventdata, handles)
% hObject    handle to UserselectedFid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UserselectedFid as text
%        str2double(get(hObject,'String')) returns contents of UserselectedFid as a double

handles = guidata(hObject);
j = regexp(get(hObject,'String'), ',', 'split' );

m = zeros(size(j,1),size(j,2));
handles.selectedFid = str2double(j);

guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function UserselectedFid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UserselectedFid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in whatToSave.
function whatToSave_Callback(hObject, eventdata, handles)
% hObject    handle to whatToSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns whatToSave contents as cell array
%        contents{get(hObject,'Value')} returns selected item from whatToSave


% --- Executes during object creation, after setting all properties.
function whatToSave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whatToSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in splineFiduc.
function splineFiduc_Callback(hObject, eventdata, handles)
% hObject    handle to splineFiduc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

[locs_Ch1, Fid_Ch1,locs_Ch2, Fid_Ch2] = splineFit_Fiducials(handles.Avg_Ch1_new,handles.Avg_Ch2_new,handles.NbrBins,handles.FilterRad,handles.smoothF, handles.startFrame,handles);

handles.locs_Ch1    = locs_Ch1;
handles.Fid_Ch1     = Fid_Ch1;
handles.locs_Ch2    = locs_Ch2;
handles.Fid_Ch2     = Fid_Ch2;

fprintf('\n -- Data Drift Corrected --\n')

guidata(hObject, handles); % Update handles structure

function NbrBins_Callback(hObject, eventdata, handles)
% hObject    handle to NbrBins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NbrBins as text
%        str2double(get(hObject,'String')) returns contents of NbrBins as a double

handles = guidata(hObject);
handles.NbrBins = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function NbrBins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NbrBins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FilterRad_Callback(hObject, eventdata, handles)
% hObject    handle to FilterRad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FilterRad as text
%        str2double(get(hObject,'String')) returns contents of FilterRad as a double

handles = guidata(hObject);
handles.FilterRad = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function FilterRad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterRad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function smoothF_Callback(hObject, eventdata, handles)
% hObject    handle to smoothF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smoothF as text
%        str2double(get(hObject,'String')) returns contents of smoothF as a double

handles = guidata(hObject);
handles.smoothF = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function smoothF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startFrame_Callback(hObject, eventdata, handles)
% hObject    handle to startFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startFrame as text
%        str2double(get(hObject,'String')) returns contents of startFrame as a double
handles = guidata(hObject);
handles.startFrame = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function startFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rigidTrans.
function rigidTrans_Callback(hObject, eventdata, handles)
% hObject    handle to rigidTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles

handles = guidata(hObject);

RigidTrans(handles.Fid_Ch1,handles.Fid_Ch2,handles)

guidata(hObject, handles); % Update handles structure
