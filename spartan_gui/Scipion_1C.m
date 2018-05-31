function varargout = Scipion_1C(varargin)
% SCIPION_1C MATLAB code for Scipion_1C.fig
%      SCIPION_1C, by itself, creates a new SCIPION_1C or raises the existing
%      singleton*.
%
%      H = SCIPION_1C returns the handle to a new SCIPION_1C or the handle to
%      the existing singleton*.
%
%      SCIPION_1C('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCIPION_1C.M with the given input arguments.
%
%      SCIPION_1C('Property','Value',...) creates a new SCIPION_1C or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Scipion_1C_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Scipion_1C_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Scipion_1C

% Last Modified by GUIDE v2.5 30-May-2018 10:04:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Scipion_1C_OpeningFcn, ...
                   'gui_OutputFcn',  @Scipion_1C_OutputFcn, ...
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


% --- Executes just before Scipion_1C is made visible.
function Scipion_1C_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Scipion_1C (see VARARGIN)

% Choose default command line output for Scipion_1C
handles.output = hObject;

handles.projectName = 'Single-Project';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Scipion_1C wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Scipion_1C_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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
    
disp('Ref Data loaded.');

guidata(hObject, handles);

%        str2double(get(hObject,'String')) returns contents of projectName as a double




function projectName_Callback(hObject, eventdata, handles)
% hObject    handle to projectName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of projectName as text
%        str2double(get(hObject,'String')) returns contents of projectName as a double

handles.output = hObject;

handles.projectName =  get(hObject,'String');  

guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function projectName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectName (see GCBO)
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

pairedAnalysis = false;

swf = em.ScipionWorkflow('docker', handles.projectName, pairedAnalysis, handles.Path_Ref, ...
                         handles.Name_Ref);
                     
swf.launchWorkflow();
