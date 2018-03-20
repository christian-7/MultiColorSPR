function varargout = simulator_GUI(varargin)
% SIMULATOR_GUI MATLAB code for simulator_GUI.fig
%      SIMULATOR_GUI, by itself, creates a new SIMULATOR_GUI or raises the existing
%      singleton*.
%
%      H = SIMULATOR_GUI returns the handle to a new SIMULATOR_GUI or the handle to
%      the existing singleton*.
%
%      SIMULATOR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMULATOR_GUI.M with the given input arguments.
%
%      SIMULATOR_GUI('Property','Value',...) creates a new SIMULATOR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simulator_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simulator_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simulator_GUI

% Last Modified by GUIDE v2.5 20-Mar-2018 22:14:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simulator_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @simulator_GUI_OutputFcn, ...
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


% --- Executes just before simulator_GUI is made visible.
function simulator_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simulator_GUI (see VARARGIN)

% Choose default command line output for simulator_GUI
handles.output = hObject;

handles.NbrStructures = 10;
handles.NbrFrames     = 10;
handles.NbrNoise      = 0;
handles.LE            = 0.2;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simulator_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simulator_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadGT.
function loadGT_Callback(hObject, eventdata, handles)
% hObject    handle to loadGT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

fprintf('\n -- Load GT csv -- \n')

% Create a file dialog for images

    [file,path] = uigetfile('*.csv');
    
    % Read the selected image into the variable
    
    cd(path)
    
    handles.GT = dlmread(file);
    
    if isempty(handles.GT)==0;
    
    set(handles.loadGT,'BackgroundColor','green');
    disp('Loaded GT ');
    
    else end
    
    
    guidata(hObject, handles); % Update handles structure




function NbrStructures_Callback(hObject, eventdata, handles)
% hObject    handle to NbrStructures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NbrStructures as text
%        str2double(get(hObject,'String')) returns contents of NbrStructures as a double

handles = guidata(hObject);

handles.NbrStructures = str2double(get(hObject,'String'))

guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function NbrStructures_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NbrStructures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NbrFrames_Callback(hObject, eventdata, handles)
% hObject    handle to NbrFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NbrFrames as text
%        str2double(get(hObject,'String')) returns contents of NbrFrames as a double

handles = guidata(hObject);

handles.NbrFrames = str2double(get(hObject,'String'))

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function NbrFrames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NbrFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NbrNoise_Callback(hObject, eventdata, handles)
% hObject    handle to NbrNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NbrNoise as text
%        str2double(get(hObject,'String')) returns contents of NbrNoise as a double

handles = guidata(hObject);

handles.NbrNoise = str2double(get(hObject,'String'))

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function NbrNoise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NbrNoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LE_Callback(hObject, eventdata, handles)
% hObject    handle to LE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LE as text
%        str2double(get(hObject,'String')) returns contents of LE as a double

handles = guidata(hObject);

handles.LE = str2double(get(hObject,'String'))

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function LE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in preview.
function preview_Callback(hObject, eventdata, handles)
% hObject    handle to preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

[handles.simParticles, sim_Noise] = initiateSimulator(handles);

ID = randi([1 handles.NbrStructures],1,1);

figure('Position',[200 400 700 300])
subplot(1,2,1)
scatter3(handles.simParticles{ID, 1}(:,1),handles.simParticles{ID, 1}(:,2),handles.simParticles{ID, 1}(:,3));hold on;
scatter3(sim_Noise{ID, 1}(:,1),sim_Noise{ID, 1}(:,2),sim_Noise{ID, 1}(:,3),'r*');hold on;
view([60,40])
axis equal

subplot(1,2,2)
scatter(handles.simParticles{ID, 1}(:,1),handles.simParticles{ID, 1}(:,2));hold on;
scatter(sim_Noise{ID, 1}(:,1),sim_Noise{ID, 1}(:,2),'r*');
axis([-300 300 -300 300]) 

guidata(hObject, handles); % Update handles structure

% --- Executes on button press in startSim.
function startSim_Callback(hObject, eventdata, handles)
% hObject    handle to startSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

[handles.simParticlesRes] = start_SMLM_simulator(handles.simParticles,handles.NbrFrames);

fprintf(' \n -- Done -- \n');

guidata(hObject, handles); % Update handles structure


% --- Executes on button press in SavePart.
function SavePart_Callback(hObject, eventdata, handles)
% hObject    handle to SavePart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toSave = handles.simParticles;

uisave('toSave','SimParticles.mat');


% --- Executes on button press in SimView.
function SimView_Callback(hObject, eventdata, handles)
% hObject    handle to SimView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

ID = randi([1 handles.NbrStructures],1,1);

figure
subplot(1,2,1)
scatter3(handles.simParticles{ID, 1}(:,1),handles.simParticles{ID, 1}(:,2),handles.simParticles{ID, 1}(:,3));hold on;
axis([-300 300 -300 300]);view([60,40]);axis equal

subplot(1,2,2)
scatter3(handles.simParticlesRes{ID, 1}(:,1),handles.simParticlesRes{ID, 1}(:,2),handles.simParticlesRes{ID, 1}(:,3),1);
axis([-300 300 -300 300]);view([60,40]);
axis equal

guidata(hObject, handles); % Update handles structure
