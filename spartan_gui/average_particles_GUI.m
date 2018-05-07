function varargout = average_particles_GUI(varargin)
% AVERAGE_PARTICLES_GUI MATLAB code for average_particles_GUI.fig
%      AVERAGE_PARTICLES_GUI, by itself, creates a new AVERAGE_PARTICLES_GUI or raises the existing
%      singleton*.
%
%      H = AVERAGE_PARTICLES_GUI returns the handle to a new AVERAGE_PARTICLES_GUI or the handle to
%      the existing singleton*.
%
%      AVERAGE_PARTICLES_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AVERAGE_PARTICLES_GUI.M with the given input arguments.
%
%      AVERAGE_PARTICLES_GUI('Property','Value',...) creates a new AVERAGE_PARTICLES_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before average_particles_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to average_particles_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help average_particles_GUI

% Last Modified by GUIDE v2.5 07-May-2018 21:35:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @average_particles_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @average_particles_GUI_OutputFcn, ...
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


% --- Executes just before average_particles_GUI is made visible.
function average_particles_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to average_particles_GUI (see VARARGIN)

% Choose default command line output for average_particles_GUI
handles.output = hObject;

% Set default parameters

handles.input       = 1;
handles.Conversion  = 0.4;
handles.imsize      = 10;
handles.PxlSize     = 106;
handles.zoomFactor  = 5;

handles.usfac       = 100;
handles.angrange     = 360;
handles.angstep     = 3;
handles.iterations  = 10;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes average_particles_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = average_particles_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in channel_mode.
function channel_mode_Callback(hObject, eventdata, handles)
% hObject    handle to channel_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns channel_mode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channel_mode

handles.output = hObject;

contents = cellstr(get(hObject,'String'));

handles.input = contents{get(hObject,'Value')}; 

if  isempty(strmatch('Single color',handles.input));
    display('-- two-color selected --'); 
    handles.input = 2;

else 
    display('-- single-color selected --'); 
    handles.input = 1;

end    
    
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function channel_mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadParticles.
function loadParticles_Callback(hObject, eventdata, handles)
% hObject    handle to loadParticles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [handles.FileName,handles.FilePath] = uigetfile({'*.mat'},'Select Particles (.m file)');
    
    % Read the selected file into the variable
    
    cd(handles.FilePath);handles.FileName
    temp         = load(handles.FileName);
    handles.locsParticles         = temp.Particles_Selected; 
    
    disp('Reading Particles ...');
    
    if isempty(handles.locsParticles)==0;
    
    set(handles.loadParticles,'BackgroundColor','green');
    
    else end
    
    disp('Particles loaded');
    
    disp('Coverting particles ...');
    
    [handles.MList,handles.data0] = convertInputAlignment(handles.locsParticles,handles.PxlSize);
   
    disp('Done coverting particles ...');

    guidata(hObject, handles); % Update handles structure




function imsize_Callback(hObject, eventdata, handles)
% hObject    handle to imsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imsize as text
%        str2double(get(hObject,'String')) returns contents of imsize as a double


handles                  = guidata(hObject);
handles.imsize       = str2double(get(hObject,'String'))
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



function zoomFactor_Callback(hObject, eventdata, handles)
% hObject    handle to zoomFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zoomFactor as text
%        str2double(get(hObject,'String')) returns contents of zoomFactor as a double

handles                  = guidata(hObject);
handles.zoomFactor       = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function zoomFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zoomFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PxlSize_Callback(hObject, eventdata, handles)
% hObject    handle to PxlSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PxlSize as text
%        str2double(get(hObject,'String')) returns contents of PxlSize as a double

handles                  = guidata(hObject);
handles.PxlSize       = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function PxlSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PxlSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function conversion_Callback(hObject, eventdata, handles)
% hObject    handle to conversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conversion as text
%        str2double(get(hObject,'String')) returns contents of conversion as a double

handles                  = guidata(hObject);
handles.Conversion       = str2double(get(hObject,'String'))
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



function usfac_Callback(hObject, eventdata, handles)
% hObject    handle to editdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editdd as text
%        str2double(get(hObject,'String')) returns contents of editdd as a double

handles                  = guidata(hObject);
handles.usfac       = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function usfac_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function angrange_Callback(hObject, eventdata, handles)
% hObject    handle to ddsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ddsd as text
%        str2double(get(hObject,'String')) returns contents of ddsd as a double

handles                  = guidata(hObject);
handles.angrange       = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure




% --- Executes during object creation, after setting all properties.
function angrange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ddsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function angstep_Callback(hObject, eventdata, handles)
% hObject    handle to sdsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sdsd as text
%        str2double(get(hObject,'String')) returns contents of sdsd as a double

handles                  = guidata(hObject);
handles.angstep       = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function angstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sdsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function iterations_Callback(hObject, eventdata, handles)
% hObject    handle to iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iterations as text
%        str2double(get(hObject,'String')) returns contents of iterations as a double

handles                  = guidata(hObject);
handles.iterations       = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function iterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runAlign.
function runAlign_Callback(hObject, eventdata, handles)
% hObject    handle to runAlign (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles                  = guidata(hObject);

[aligniter,iterIm,s,n_frame,allIm,data,images0,ParticlesAligned] = runAlignmentXS(handles.MList,handles.data0,handles.imsize,handles.zoomFactor,... 
                                                                                  handles.PxlSize, handles.Conversion, handles.usfac,... 
                                                                                  handles.angrange,handles.angstep,handles.iterations);
                                                                                                                                                            
% display iterations

sumim = zeros(s,s);

for index = 1:n_frame
    sumim = sumim + images0(:,:,index);
end

NofSubplots = ceil(sqrt(handles.iterations));

figure;
subplot(NofSubplots,NofSubplots,1);imshow(autocontrast(sumim));title('to be registered'); hold on;

for i = 1:handles.iterations;

regi=iterIm(:,:,i);
    
subplot(NofSubplots,NofSubplots,1+i);imshow(autocontrast(regi));title(['Iteration ',num2str(i)]); hold on;

end

handles.locsParticles(:,2) = ParticlesAligned;
