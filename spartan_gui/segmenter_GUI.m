function varargout = segmenter_GUI(varargin)
% SEGMENTER_GUI MATLAB code for segmenter_GUI.fig
%      SEGMENTER_GUI, by itself, creates a new SEGMENTER_GUI or raises the existing
%      singleton*.
%
%      H = SEGMENTER_GUI returns the handle to a new SEGMENTER_GUI or the handle to
%      the existing singleton*.
%
%      SEGMENTER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGMENTER_GUI.M with the given input arguments.
%
%      SEGMENTER_GUI('Property','Value',...) creates a new SEGMENTER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segmenter_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segmenter_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segmenter_GUI

% Last Modified by GUIDE v2.5 11-Mar-2018 20:05:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @segmenter_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @segmenter_GUI_OutputFcn, ...
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


% --- Executes just before segmenter_GUI is made visible.
function segmenter_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segmenter_GUI (see VARARGIN)

% Choose default command line output for segmenter_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes segmenter_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = segmenter_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popChannel.
function popChannel_Callback(hObject, eventdata, handles)
% hObject    handle to popChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popChannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popChannel
% Choose default command line output for segmenter_GUI
handles.output = hObject;

contents = cellstr(get(hObject,'String'));

h = contents{get(hObject,'Value')}; 

if isempty(strmatch('Single color',h));
    display('-- two-color selected --');   
    set(handles.locsCh2, 'Enable', 'on')
    set(handles.WF2, 'Enable', 'on')
else 
    display('-- single-color selected --');  
    set(handles.locsCh2, 'Enable', 'off')
    set(handles.WF2, 'Enable', 'off')
end    
    

% Update handles structure
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function popChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in WF1.
function WF1_Callback(hObject, eventdata, handles)
% hObject    handle to WF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function fovID_Callback(hObject, eventdata, handles)
% hObject    handle to fovID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fovID as text
%        str2double(get(hObject,'String')) returns contents of fovID as a double


% --- Executes during object creation, after setting all properties.
function fovID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fovID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in WF2.
function WF2_Callback(hObject, eventdata, handles)
% hObject    handle to WF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in saveOverlay.
function saveOverlay_Callback(hObject, eventdata, handles)
% hObject    handle to saveOverlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveOverlay


% --- Executes on button press in saveCorr.
function saveCorr_Callback(hObject, eventdata, handles)
% hObject    handle to saveCorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveCorr



function savePath_Callback(hObject, eventdata, handles)
% hObject    handle to savePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of savePath as text
%        str2double(get(hObject,'String')) returns contents of savePath as a double


% --- Executes during object creation, after setting all properties.
function savePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to savePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pxlsize_Callback(hObject, eventdata, handles)
% hObject    handle to pxlsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pxlsize as text
%        str2double(get(hObject,'String')) returns contents of pxlsize as a double


% --- Executes during object creation, after setting all properties.
function pxlsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pxlsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in locsCh1.
function locsCh1_Callback(hObject, eventdata, handles)
% hObject    handle to locsCh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    [FileName_Ch1,Path_Ch1] = uigetfile({'*.csv';'*.dat'},'Select Loc file Ch1');
    
    % Read the selected file into the variable
    
    disp('Reading Localization file for channel 1 ...');
    
    [path,Name_Ch1,ext_Ch1] = fileparts(FileName_Ch1);
    
    handles.Ext_Ch1     = ext_Ch1;
    handles.Path_Ch1    = Path_Ch1;
    handles.Name_Ch1    = Name_Ch1;
    
    cd(Path_Ch1);
    
    handles.locs_Ch1          = dlmread([Name_Ch1 ext_Ch1],',',1,0); 
    handles.locs_Ch1(:,end+1) = 1; % Channel ID, column 9

    
    % Read the header
    
    file = fopen([Name_Ch1 ext_Ch1]);
    handles.line = fgetl(file);
    h    = regexp(handles.line, ',', 'split' );

    handles.xCol      = strmatch('x [nm]',h);
    handles.yCol      = strmatch('y [nm]',h);
    handles.frameCol  = strmatch('frame',h);
    
    if isempty(handles.locs_Ch1)==0;
    
    set(handles.openLocCh1,'BackgroundColor','green');
    
    else end
    
    disp('Localization file loaded');

    guidata(hObject, handles); % Update handles structure


% --- Executes on button press in locsCh2.
function locsCh2_Callback(hObject, eventdata, handles)
% hObject    handle to locsCh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
