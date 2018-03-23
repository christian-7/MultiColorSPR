function varargout = particleFilter_GUI(varargin)
% PARTICLEFILTER_GUI MATLAB code for particleFilter_GUI.fig
%      PARTICLEFILTER_GUI, by itself, creates a new PARTICLEFILTER_GUI or raises the existing
%      singleton*.
%
%      H = PARTICLEFILTER_GUI returns the handle to a new PARTICLEFILTER_GUI or the handle to
%      the existing singleton*.
%
%      PARTICLEFILTER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARTICLEFILTER_GUI.M with the given input arguments.
%
%      PARTICLEFILTER_GUI('Property','Value',...) creates a new PARTICLEFILTER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before particleFilter_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to particleFilter_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help particleFilter_GUI

% Last Modified by GUIDE v2.5 23-Mar-2018 20:10:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @particleFilter_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @particleFilter_GUI_OutputFcn, ...
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


% --- Executes just before particleFilter_GUI is made visible.
function particleFilter_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to particleFilter_GUI (see VARARGIN)

% Choose default command line output for particleFilter_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes particleFilter_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = particleFilter_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadPart.
function loadPart_Callback(hObject, eventdata, handles)
% hObject    handle to loadPart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [FileName_Ch1,Path_Ch1] = uigetfile({'*.mat'},'Select Segmented Particles');
    
    % Read the selected file into the variable
    
    disp('Reading Particles ...');
    
    [path,Name_Ch1,ext_Ch1] = fileparts(FileName_Ch1);
    
    handles.Ext_Ch1     = ext_Ch1;
    handles.Path_Ch1    = Path_Ch1;
    handles.Name_Ch1    = Name_Ch1;
    
    cd(Path_Ch1);
    
    handles.Particles          = load([Name_Ch1 ext_Ch1]); 
    
    if isempty(handles.Particles)==0;
    
    set(handles.loadPart,'BackgroundColor','green');
    
    else end
    
    disp('Particles loaded');

    guidata(hObject, handles); % Update handles structure


% --- Executes on button press in filter1.
function filter1_Callback(hObject, eventdata, handles)
% hObject    handle to filter1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in defineDBSCAN.
function defineDBSCAN_Callback(hObject, eventdata, handles)
% hObject    handle to defineDBSCAN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in calculateShape.
function calculateShape_Callback(hObject, eventdata, handles)
% hObject    handle to calculateShape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in filter2.
function filter2_Callback(hObject, eventdata, handles)
% hObject    handle to filter2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in renderParticles.
function renderParticles_Callback(hObject, eventdata, handles)
% hObject    handle to renderParticles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
