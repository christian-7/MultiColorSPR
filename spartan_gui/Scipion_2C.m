function varargout = Scipion_2C(varargin)
% SCIPION_2C MATLAB code for Scipion_2C.fig
%      SCIPION_2C, by itself, creates a new SCIPION_2C or raises the existing
%      singleton*.
%
%      H = SCIPION_2C returns the handle to a new SCIPION_2C or the handle to
%      the existing singleton*.
%
%      SCIPION_2C('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCIPION_2C.M with the given input arguments.
%
%      SCIPION_2C('Property','Value',...) creates a new SCIPION_2C or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Scipion_2C_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Scipion_2C_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Scipion_2C

% Last Modified by GUIDE v2.5 30-May-2018 10:11:24

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Scipion_2C_OpeningFcn, ...
                   'gui_OutputFcn',  @Scipion_2C_OutputFcn, ...
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


% --- Executes just before Scipion_2C is made visible.
function Scipion_2C_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Scipion_2C (see VARARGIN)

% Choose default command line output for Scipion_2C
handles.output = hObject;

handles.projectName = 'Paired-Project';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Scipion_2C wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Scipion_2C_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in loadRef.
function loadRef_Callback(hObject, eventdata, handles)
% hObject    handle to loadRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;

[FileName_Ref,Path_Ref] = uigetfile({'*.tif'},'Load Ref Data');
    
    % Read the selected file into the variable
    
  [path,Name_Ref,ext_Ref] = fileparts(FileName_Ref);
    
    handles.Ext_Ref     = ext_Ref ;
    handles.Path_Ref    = Path_Ref;
    handles.Name_Ref    = Name_Ref;
    
    
    if isempty(handles.loadRef)==0;
    
    set(handles.loadRef,'BackgroundColor','green');
    
    else end
    
disp('Reference Data loaded.');

guidata(hObject, handles);



% --- Executes on button press in loadPOI.
function loadPOI_Callback(hObject, eventdata, handles)
% hObject    handle to loadPOI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;

[FileName_POI,Path_POI] = uigetfile({'*.tif'},'Load POI Data');
    
    % Read the selected file into the variable
    
    [path,Name_POI,ext_POI] = fileparts(FileName_POI);
    
    handles.Ext_POI     = ext_POI ;
    handles.Path_POI    = Path_POI;
    handles.Name_POI    = Name_POI;
    
    
    if isempty(handles.loadPOI)==0;
    
    set(handles.loadPOI,'BackgroundColor','green');
    
    else end
    
disp('POI Data loaded.');

guidata(hObject, handles);




function projName_Callback(hObject, eventdata, handles)
% hObject    handle to projName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of projName as text
%        str2double(get(hObject,'String')) returns contents of projName as a double

handles.output = hObject;

handles.projectName =  get(hObject,'String');  

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function projName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startScipion.
function startScipion_Callback(hObject, eventdata, handles)
% hObject    handle to startScipion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pairedAnalysis = true;

swf = em.ScipionWorkflow('docker',handles.projectName, pairedAnalysis, handles.Path_Ref, ...
                         handles.Name_Ref, handles.Path_POI, handles.Name_POI);
                  
% Launch Scipion with the two-protein workflow
%
swf.launchWorkflow();
