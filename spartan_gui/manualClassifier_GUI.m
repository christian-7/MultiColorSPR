function varargout = manualClassifier_GUI(varargin)
% MANUALCLASSIFIER_GUI MATLAB code for manualClassifier_GUI.fig
%      MANUALCLASSIFIER_GUI, by itself, creates a new MANUALCLASSIFIER_GUI or raises the existing
%      singleton*.
%
%      H = MANUALCLASSIFIER_GUI returns the handle to a new MANUALCLASSIFIER_GUI or the handle to
%      the existing singleton*.
%
%      MANUALCLASSIFIER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALCLASSIFIER_GUI.M with the given input arguments.
%
%      MANUALCLASSIFIER_GUI('Property','Value',...) creates a new MANUALCLASSIFIER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manualClassifier_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manualClassifier_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help manualClassifier_GUI

% Last Modified by GUIDE v2.5 05-Apr-2018 21:40:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @manualClassifier_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @manualClassifier_GUI_OutputFcn, ...
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


% --- Executes just before manualClassifier_GUI is made visible.
function manualClassifier_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manualClassifier_GUI (see VARARGIN)

% Choose default command line output for manualClassifier_GUI
handles.output = hObject;

handles.Class1 = {};
handles.Class2 = {};
handles.Class3 = {};
handles.response = [];

axes(handles.axes1);cla reset; box on;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes manualClassifier_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = manualClassifier_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadParticles.
function loadParticles_Callback(hObject, eventdata, handles)
% hObject    handle to loadParticles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName_Ch1,Path_Ch1] = uigetfile({'*.mat'},'Select Segmented Particles');
    
    % Read the selected file into the variable
    
    disp('Reading Particles ...');
    
    [path,Name_Ch1,ext_Ch1] = fileparts(FileName_Ch1);
    
    handles.Ext_Ch1     = ext_Ch1 ;
    handles.Path_Ch1    = Path_Ch1;
    handles.Name_Ch1    = Name_Ch1;
    
    cd(Path_Ch1);
    
    handles.Particles          = load([Name_Ch1 ext_Ch1]); 
    
    if isempty(handles.Particles)==0;
    
    set(handles.loadParticles,'BackgroundColor','green');
    
    else end
    
    disp('Particles loaded');

textLabel = ['Total particles = ', num2str(size(handles.Particles.toSave,1))];
set(handles.text1, 'String', textLabel);

handles.partID = 1;

axes(handles.axes1);cla reset;
scatter(handles.Particles.toSave{handles.partID,1}(:,1),handles.Particles.toSave{handles.partID,1}(:,2),'k.'); hold on;
scatter(handles.Particles.toSave{handles.partID,2}(:,1),handles.Particles.toSave{handles.partID,2}(:,2),'k.');
box on;

textLabel = ['Particle ' num2str(handles.partID) ' of ' num2str(size(handles.Particles.toSave,1))];set(handles.text2, 'String', textLabel);

guidata(hObject, handles); % Update handles structure

    


% --- Executes on button press in assignCl1.
function assignCl1_Callback(hObject, eventdata, handles)
% hObject    handle to assignCl1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;

handles.response(handles.partID,1) = 1;

handles.Class1 = vertcat(handles.Class1,handles.Particles.toSave(handles.partID,1:2));
textLabel = num2str(size(handles.Class1,1));
set(handles.textCl1, 'String', textLabel);

handles.partID = handles.partID+1;

if handles.partID <= size(handles.Particles.toSave,1) == 1;

axes(handles.axes1);cla reset;
scatter(handles.Particles.toSave{handles.partID,1}(:,1),handles.Particles.toSave{handles.partID,1}(:,2),'k.'); hold on;
scatter(handles.Particles.toSave{handles.partID,2}(:,1),handles.Particles.toSave{handles.partID,2}(:,2),'k.');

textLabel = ['Particle ' num2str(handles.partID) ' of ' num2str(size(handles.Particles.toSave,1))];
set(handles.text2, 'String', textLabel);

else
end

guidata(hObject, handles); % Update handles structure



% --- Executes on button press in assignCl2.
function assignCl2_Callback(hObject, eventdata, handles)
% hObject    handle to assignCl2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;

handles.response(handles.partID,1) = 2;

handles.Class2 = vertcat(handles.Class2,handles.Particles.toSave(handles.partID,1:2));
textLabel = num2str(size(handles.Class2,1));
set(handles.textCl2, 'String', textLabel);

handles.partID = handles.partID+1;

if handles.partID <= size(handles.Particles.toSave,1) == 1;

axes(handles.axes1);cla reset;
scatter(handles.Particles.toSave{handles.partID,1}(:,1),handles.Particles.toSave{handles.partID,1}(:,2),'k.'); hold on;
scatter(handles.Particles.toSave{handles.partID,2}(:,1),handles.Particles.toSave{handles.partID,2}(:,2),'k.');

textLabel = ['Particle ' num2str(handles.partID) ' of ' num2str(size(handles.Particles.toSave,1))];
set(handles.text2, 'String', textLabel);

else end

guidata(hObject, handles); % Update handles structure



% --- Executes on button press in assignCl3.
function assignCl3_Callback(hObject, eventdata, handles)
% hObject    handle to assignCl3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;

handles.response(handles.partID,1) = 3;

handles.Class3 = vertcat(handles.Class3,handles.Particles.toSave(handles.partID,1:2));
textLabel = num2str(size(handles.Class3,1));
set(handles.textCl3, 'String', textLabel);

handles.partID = handles.partID+1;

if handles.partID <= size(handles.Particles.toSave,1) == 1;

axes(handles.axes1);cla reset;
scatter(handles.Particles.toSave{handles.partID,1}(:,1),handles.Particles.toSave{handles.partID,1}(:,2),'k.'); hold on;
scatter(handles.Particles.toSave{handles.partID,2}(:,1),handles.Particles.toSave{handles.partID,2}(:,2),'k.');

textLabel = ['Particle ' num2str(handles.partID) ' of ' num2str(size(handles.Particles.toSave,1))];
set(handles.text2, 'String', textLabel);

else end

guidata(hObject, handles); % Update handles structure


% --- Executes on button press in saveResult.
function saveResult_Callback(hObject, eventdata, handles)
% hObject    handle to saveResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

training          = cell2mat(handles.Particles.toSave(:,3:end));
training(:,end+1) = handles.response;

cd(handles.Path_Ch1); 
filename1 = [handles.Name_Ch1 '_training.mat']; save(filename1,'training');

% Add table



