function varargout = locs_viewer(varargin)
% LOCS_VIEWER MATLAB code for locs_viewer.fig
%      LOCS_VIEWER, by itself, creates a new LOCS_VIEWER or raises the existing
%      singleton*.
%
%      H = LOCS_VIEWER returns the handle to a new LOCS_VIEWER or the handle to
%      the existing singleton*.
%
%      LOCS_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOCS_VIEWER.M with the given input arguments.
%
%      LOCS_VIEWER('Property','Value',...) creates a new LOCS_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before locs_viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to locs_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help locs_viewer

% Last Modified by GUIDE v2.5 03-Aug-2018 21:37:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @locs_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @locs_viewer_OutputFcn, ...
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


% --- Executes just before locs_viewer is made visible.
function locs_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to locs_viewer (see VARARGIN)

% Choose default command line output for locs_viewer
handles.output = hObject;


handles.pxlsize     = 106;
handles.binsize     = 15;
handles.imsize      = 512;
handles.segparam    = 500;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes locs_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = locs_viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in inputFormat.
function inputFormat_Callback(hObject, eventdata, handles)
% hObject    handle to inputFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns inputFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from inputFormat

handles.output = hObject;
contents = cellstr(get(hObject,'String'));
handles.format = contents{get(hObject,'Value')};
handles.format
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function inputFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadLocs.
function loadLocs_Callback(hObject, eventdata, handles)
% hObject    handle to loadLocs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    handles = guidata(hObject);

    [FileName_Ch1,Path_Ch1] = uigetfile({'*.csv';'*.dat'},'Select Loc file');
    
    % Read the selected file into the variable
    
    disp('Reading Localization file ...');
    
    [path,Name_Ch1,ext_Ch1] = fileparts(FileName_Ch1);
    
    handles.Ext_Ch1     = ext_Ch1;
    handles.Path_Ch1    = Path_Ch1;
    handles.Name_Ch1    = Name_Ch1;
    
    cd(Path_Ch1);
    
    handles.locs          = dlmread([Name_Ch1 ext_Ch1],',',1,0); 
    
    % Read the header
    
    file         = fopen([Name_Ch1 ext_Ch1]);
    handles.line = fgetl(file);
    h            = regexp(handles.line, ',', 'split' );
    
    if contains(string,'Thunder')==1;

    handles.xCol      = strmatch('x [nm]',h);
    handles.yCol      = strmatch('y [nm]',h);
    handles.framesCol  = strmatch('frame',h);
    
    else 
     
handles.xCol            = strmatch('x_nm',header);
handles.yCol            = strmatch('y_nm',header);
handles.framesCol       = strmatch('frame',header);
handles.LLCol           = strmatch('logLikelyhood',header);
handles.photonsCol      = strmatch('photons',header);
    end   

    if isempty(handles.locs_Ch1)==0;
    
    set(handles.openLocCh1,'BackgroundColor','green');
    
    else end
    
    disp('Localization file loaded');

    guidata(hObject, handles); % Update handles structure



function segparam_Callback(hObject, eventdata, handles)
% hObject    handle to segparam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of segparam as text
%        str2double(get(hObject,'String')) returns contents of segparam as a double

handles = guidata(hObject);
handles.segparam = str2double(get(hObject,'String'));
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function segparam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segparam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imsize_Callback(hObject, eventdata, handles)
% hObject    handle to imsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imsize as text
%        str2double(get(hObject,'String')) returns contents of imsize as a double

handles = guidata(hObject);
handles.imsize = str2double(get(hObject,'String'));
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function imsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imsize (see GCBO)
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

handles = guidata(hObject);
handles.pxlsize = str2double(get(hObject,'String'));
guidata(hObject, handles); % Update handles structure



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



function binsize_Callback(hObject, eventdata, handles)
% hObject    handle to binsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of binsize as text
%        str2double(get(hObject,'String')) returns contents of binsize as a double

handles = guidata(hObject);
handles.binsize = str2double(get(hObject,'String'));
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function binsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to binsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in startRCC.
function startRCC_Callback(hObject, eventdata, handles)
% hObject    handle to startRCC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

coords(:,1) = handles.locs(:,handles.xCol)/handles.pxlsize;
coords(:,2) = handles.locs(:,handles.yCol)/handles.pxlsize;
coords(:,3) = handles.locs(:,handles.framesCol);

fprintf('\n -- Starting RCC ... \n');

[coordscorr, finaldrift] = RCC(coords, handles.segpara, handles.imsize, handles.pixelsize, handles.binsize, 0.2);

figure('Position',[100 100 900 400])
subplot(2,1,1)
plot(finaldrift(:,1))
title('x Drift')
subplot(2,1,2)
plot(finaldrift(:,2))
title('y Drift')

locsDC = handles.locs;
locsDC(:,xCol) = coordscorr(:,1);
locsDC(:,yCol) = coordscorr(:,2);
