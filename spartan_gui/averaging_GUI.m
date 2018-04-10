function varargout = averaging_GUI(varargin)
% AVERAGING_GUI MATLAB code for averaging_GUI.fig
%      AVERAGING_GUI, by itself, creates a new AVERAGING_GUI or raises the existing
%      singleton*.
%
%      H = AVERAGING_GUI returns the handle to a new AVERAGING_GUI or the handle to
%      the existing singleton*.
%
%      AVERAGING_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AVERAGING_GUI.M with the given input arguments.
%
%      AVERAGING_GUI('Property','Value',...) creates a new AVERAGING_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before averaging_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to averaging_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help averaging_GUI

% Last Modified by GUIDE v2.5 10-Apr-2018 15:03:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @averaging_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @averaging_GUI_OutputFcn, ...
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


% --- Executes just before averaging_GUI is made visible.
function averaging_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to averaging_GUI (see VARARGIN)

% Choose default command line output for averaging_GUI
handles.output = hObject;

handles.PartNum = 20;
handles.Iter    = 5;
hanldes.Mode    = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes averaging_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = averaging_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadData.
function loadData_Callback(hObject, eventdata, handles)
% hObject    handle to loadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [FileName_Ch1,Path_Ch1] = uigetfile({'*.tif'},'Select first image');
    
    % Read the selected file into the variable
    
    disp('Reading Particles ...');
    
    [path,Name_Ch1,ext_Ch1] = fileparts(FileName_Ch1);
    
    handles.Ext_Particle          = ext_Ch1 ;
    handles.Path_Particle         = Path_Ch1;
    handles.Name_Particle         = Name_Ch1;
    
    cd(handles.Path_Particle);
    
    handles.ReferenceIm = imread('reference_Im.tif');
    
    NameBase = regexp(handles.Name_Particle, '_', 'split' );
    handles.PartNum = size(dir([NameBase{1,1} '*' handles.Ext_Particle]),1);
    
    textLabel = ['Total particles = ', num2str(handles.PartNum)];
    set(handles.particleNumber, 'String', textLabel);
    
    % Load reference image
    
    axes(handles.axes1);cla reset;box on;
    imagesc(handles.ReferenceIm); 
    axis square
    colormap hot
   
    if isempty(handles.Path_Particle)==0;
    
    set(handles.loadData,'BackgroundColor','green');
    
    else end
    
    disp('Path information set');

    guidata(hObject, handles); % Update handles structure



function fieldMode_Callback(hObject, eventdata, handles)
% hObject    handle to fieldMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fieldMode as text
%        str2double(get(hObject,'String')) returns contents of fieldMode as a double

handles         = guidata(hObject);

handles.Mode = str2double(get(hObject,'String')); % Format [1,2,3,4], call handles.length(3)

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function fieldMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fieldMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fieldIter_Callback(hObject, eventdata, handles)
% hObject    handle to fieldIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fieldIter as text
%        str2double(get(hObject,'String')) returns contents of fieldIter as a double

handles         = guidata(hObject);

handles.Iter = str2double(get(hObject,'String')); % Format [1,2,3,4], call handles.length(3)

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function fieldIter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fieldIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fieldPartNum_Callback(hObject, eventdata, handles)
% hObject    handle to fieldPartNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fieldPartNum as text
%        str2double(get(hObject,'String')) returns contents of fieldPartNum as a double

handles         = guidata(hObject);

handles.PartNum = str2double(get(hObject,'String')); % Format [1,2,3,4], call handles.length(3)

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function fieldPartNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fieldPartNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startAveraging.
function startAveraging_Callback(hObject, eventdata, handles)
% hObject    handle to startAveraging (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles         = guidata(hObject);

[Image_CC] = imageAlignment_CC(handles);

AveragedIm = Image_CC{1,handles.Iter};
 
 for k=2:size(Image_CC,1)
     
     AveragedIm = imadd(AveragedIm,Image_CC{k,handles.Iter});
     
 end
 
axes(handles.axes2);cla reset;box on;
imagesc(AveragedIm); 
axis square
colormap hot

guidata(hObject, handles); % Update handles structure
