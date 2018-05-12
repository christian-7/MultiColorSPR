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

% Last Modified by GUIDE v2.5 11-May-2018 14:03:29

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

handles.save_IM     = 1;
handles.save_locs   = 1;
handles.refCh       = 2;
handles.poi         = 1;

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
    
    [path,handles.SaveName,ext] = fileparts(handles.FileName);
    
    % Read the selected file into the variable
    
    cd(handles.FilePath);
    temp                            = load(handles.FileName);
    name_temp                       = fieldnames(temp);
    handles.locsParticles           = eval(['temp.' name_temp{1,1}]);
    
    disp('Reading Particles ...');
    
    if isempty(handles.locsParticles)==0;
    
    set(handles.loadParticles,'BackgroundColor','green');
    
    else end
    
    disp('Particles loaded');
    
    disp('Coverting particles ...');
    
    handles.locsParticles
    
    if handles.input == 1;
    
    [handles.MList,handles.data0] = convertInputAlignment(handles.locsParticles,handles.PxlSize);
    
    else
    
    [handles.MList_C1,handles.data0_C1,handles.MList_C2,handles.data0_C2] = convertInputAlignment2C(handles.locsParticles(:,handles.refCh),handles.locsParticles(:,handles.poi),handles.PxlSize);% (refCh,poICh,pxlsize)
    
    end
   
    disp('Done coverting particles ...');
    
    if handles.input == 1;
    
    textLabel = sprintf([num2str(max(handles.data0(:,7))) ' Particles Loaded']);
    set(handles.NbrOfParticles, 'String', textLabel);
    
    else
    
    textLabel = sprintf([num2str(max(handles.data0_C1(:,7))) ' Particles Loaded']);
    set(handles.NbrOfParticles, 'String', textLabel);
    
    end
    
    
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

if handles.input == 1; 

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

handles.ParticlesAligned = ParticlesAligned;
handles.imAligned = regi;

% 2C input data

else 

[aligniter,iterIm,s,n_frame,allIm,data,images0,ParticlesAligned] = runAlignmentXS_2C(handles.MList_C1,handles.data0_C1,handles.data0_C2,...
                                                                                     handles.imsize,handles.zoomFactor,... 
                                                                                     handles.PxlSize, handles.Conversion, handles.usfac,... 
                                                                                     handles.angrange,handles.angstep,handles.iterations);                                                                                                                                                            
% display iterations for channel 1 and final overlay

sumim = zeros(s,s);

for index = 1:n_frame
    sumim = sumim + images0(:,:,index);
end

NofSubplots = ceil(sqrt(handles.iterations));

figure;
subplot(NofSubplots,NofSubplots,1);imshow(autocontrast(sumim));title('to be registered'); hold on;

for i = 1:handles.iterations;

regi = iterIm(:,:,i);
    
subplot(NofSubplots,NofSubplots,1+i);imshow(autocontrast(regi));title(['Iteration ',num2str(i)]); hold on;

end

handles.ParticlesAligned = ParticlesAligned;

% Load both images and make overlay

sum_Ch1x = []; sum_Ch2x = []; sum_Ch1y = []; sum_Ch2y = [];

for i = 1:size(ParticlesAligned,1);
    
    sum_Ch1x  = vertcat(sum_Ch1x, ParticlesAligned{i,1}(:,2)-mean(ParticlesAligned{i,1}(:,2)));
    sum_Ch1y  = vertcat(sum_Ch1y, ParticlesAligned{i,1}(:,3)-mean(ParticlesAligned{i,1}(:,3)));
    sum_Ch2x  = vertcat(sum_Ch2x, ParticlesAligned{i,2}(:,2)-mean(ParticlesAligned{i,1}(:,2)));
    sum_Ch2y  = vertcat(sum_Ch2y, ParticlesAligned{i,2}(:,3)-mean(ParticlesAligned{i,1}(:,3)));

end

SRpxlsize = 10;
    
width  = round(max(max(sum_Ch1x)-min(sum_Ch1x), max(sum_Ch2x)-min(sum_Ch2x))*SRpxlsize);
heigth = round(max(max(sum_Ch1y)-min(sum_Ch1y), max(sum_Ch2y)-min(sum_Ch2y))*SRpxlsize);

im_Ch1 = hist3([sum_Ch1x, sum_Ch1y],[width heigth]);
im_Ch2 = hist3([sum_Ch2x, sum_Ch2y],[width heigth]);

figure
imshow(imfuse(imgaussfilt(im_Ch1,1),imgaussfilt(im_Ch2,1)));

handles.im_Ch1 = im_Ch1;
handles.im_Ch2 = im_Ch2;

end

guidata(hObject, handles); % Update handles structure
    


% --- Executes on button press in saveResults.
function saveResults_Callback(hObject, eventdata, handles)
% hObject    handle to saveResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

[name,path] = uiputfile([handles.SaveName '_aligned.mat']);
cd(path);

handles
    
if handles.save_IM == 1;
    
    if handles.input == 1; 
    
    toSave = autocontrast(handles.imAligned);
    imwrite(toSave,[handles.SaveName '_aligned.tiff']);
    
    else
        
    locsCH1_Aligned = handles.im_Ch1;
    imwrite(autocontrast(locsCH1_Aligned),[handles.SaveName '_Ch1_aligned.tiff']);
    
    locsCH2_Aligned = handles.im_Ch2;
    imwrite(autocontrast(locsCH2_Aligned),[handles.SaveName '_Ch2_aligned.tiff']);
    
    end
    
else
end

if handles.save_locs == 1;
    
    locsAligned = handles.ParticlesAligned;
    save([handles.SaveName '_aligned.mat'],'locsAligned');
    
else
end







% --- Executes on button press in save_IM.
function save_IM_Callback(hObject, eventdata, handles)
% hObject    handle to save_IM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_IM

handles                  = guidata(hObject);
handles.save_IM          = get(hObject,'Value');
guidata(hObject, handles); % Update handles structure





% --- Executes on button press in save_Locs.
function save_Locs_Callback(hObject, eventdata, handles)
% hObject    handle to save_Locs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_Locs

handles                  = guidata(hObject);
handles.save_locs          = get(hObject,'Value');
guidata(hObject, handles); % Update handles structure


% --- Executes on selection change in refCh_Input.
function refCh_Input_Callback(hObject, eventdata, handles)
% hObject    handle to refCh_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns refCh_Input contents as cell array
%        contents{get(hObject,'Value')} returns selected item from refCh_Input

handles.output = hObject;

contents = cellstr(get(hObject,'String'));

handles.input = contents{get(hObject,'Value')}; 

if  isempty(strmatch('2',handles.input));
    display('-- Reference Channel 1 --'); 
    handles.refCh = 1;
    handles.poi   = 2;

else 
    display('-- Reference Channel 2 --'); 
    handles.refCh = 2;
    handles.poi   = 1;

end    
    
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function refCh_Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to refCh_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
