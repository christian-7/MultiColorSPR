function varargout = defineDBSCAN_GUI(varargin)
% DEFINEDBSCAN_GUI MATLAB code for defineDBSCAN_GUI.fig
%      DEFINEDBSCAN_GUI, by itself, creates a new DEFINEDBSCAN_GUI or raises the existing
%      singleton*.
%
%      H = DEFINEDBSCAN_GUI returns the handle to a new DEFINEDBSCAN_GUI or the handle to
%      the existing singleton*.
%
%      DEFINEDBSCAN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFINEDBSCAN_GUI.M with the given input arguments.
%
%      DEFINEDBSCAN_GUI('Property','Value',...) creates a new DEFINEDBSCAN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before defineDBSCAN_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to defineDBSCAN_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help defineDBSCAN_GUI

% Last Modified by GUIDE v2.5 27-Mar-2018 22:20:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @defineDBSCAN_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @defineDBSCAN_GUI_OutputFcn, ...
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


% --- Executes just before defineDBSCAN_GUI is made visible.
function defineDBSCAN_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to defineDBSCAN_GUI (see VARARGIN)

% Choose default command line output for defineDBSCAN_GUI
handles.output = hObject;


handles.PartID    = 1;
handles.Eps       = 20;
handles.K         = 10;
handles.minLength = 100;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes defineDBSCAN_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = defineDBSCAN_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function PartID_Callback(hObject, eventdata, handles)
% hObject    handle to PartID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PartID as text
%        str2double(get(hObject,'String')) returns contents of PartID as a double

handles = guidata(hObject);

string = get(hObject,'String');

handles.PartID = str2double(string);

guidata(hObject, handles); % Update handles structure




% --- Executes during object creation, after setting all properties.
function PartID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PartID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function KEps_Callback(hObject, eventdata, handles)
% hObject    handle to KEps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KEps as text
%        str2double(get(hObject,'String')) returns contents of KEps as a double

handles = guidata(hObject);

string2 = regexp(get(hObject,'String'), ',', 'split' );

handles.K = str2double(string2{1,1});
handles.Eps = str2double(string2{1,2});

guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function KEps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KEps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minLength_Callback(hObject, eventdata, handles)
% hObject    handle to minLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minLength as text
%        str2double(get(hObject,'String')) returns contents of minLength as a double

handles = guidata(hObject);

string = get(hObject,'String');

handles.minLength = str2double(string);

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function minLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runDBSCAN.
function runDBSCAN_Callback(hObject, eventdata, handles)
% hObject    handle to runDBSCAN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

 h = findobj('Tag','particleFilter');

 if ~isempty(h);
    g1data = guidata(h);
 end

% Show Histogram of the length

Cent_filt_2C  = g1data.Particles_filt_2C;

%  Test DBSCAN particle size Filter

m = handles.PartID; % Cent ID

fprintf(['\n -- DBSCAN started for Particle ' num2str(m) ' --\n'])
DBSCAN_filtered = {}; tic;

% Find out if the data was processed in bstore or TS

dataDBS      = [];
dataDBS(:,1) = Cent_filt_2C{m,1}(:,1); % x in mum
dataDBS(:,2) = Cent_filt_2C{m,1}(:,2); % y in mum

% Run DBSCAN                                                   % minimum distance between points, nm

[class,type] 	= DBSCAN(dataDBS,handles.K,handles.Eps);                         % uses parameters specified at input
class2          = transpose(class);                                    % class - vector specifying assignment of the i-th object to certain cluster (m,1)
type2           = transpose(type);                                      % (core: 1, border: 0, outlier: -1)

coreBorder      = [];
coreBorder      = find(type2 >= 0);

subset          = [];
subset          = Cent_filt_2C{m,1}(coreBorder,1:end);
subset(:,end+1) = class2(coreBorder);

subsetP = [];
subsetP(:,1)    = dataDBS(coreBorder,1);
subsetP(:,2)    = dataDBS(coreBorder,2);
subsetP(:,3)    = class2(coreBorder);


axes(handles.axes1);cla reset;
scatter(Cent_filt_2C{m,1}(Cent_filt_2C{m,1}(:,end)==1,1),Cent_filt_2C{m,1}(Cent_filt_2C{m,1}(:,end)==1,2),1,'black'); hold on;
scatter(Cent_filt_2C{m,1}(Cent_filt_2C{m,1}(:,end)==2,1),Cent_filt_2C{m,1}(Cent_filt_2C{m,1}(:,end)==2,2),1,'red'); hold on;
title('Raw Data')
axis on
box on

axes(handles.axes2);cla reset;
scatter(subsetP(:,1),subsetP(:,2),1,mod(subsetP(:,3),10))
title('identified Clusters')
axis on
axis([min(dataDBS(:,1)) max(dataDBS(:,1)) min(dataDBS(:,2)) max(dataDBS(:,2))])
box on

% Select only the largest cluster(s)

if isempty(subset);
else

ClusterLength = [];

for i = 1:max(subset(:,end));                                               % find the i-th cluster
    
    vx = find(subset(:,end)==i);
    
    if length(vx) > handles.minLength;
        
    DBSCAN_filtered{length(DBSCAN_filtered)+1,1} = subset(vx,1:end);        % Put the cluster ID in the last column 
    
    axes(handles.axes3);cla reset;
    scatter(DBSCAN_filtered{length(DBSCAN_filtered),1}(:,1),DBSCAN_filtered{length(DBSCAN_filtered),1}(:,2),1);hold on;
    title('selected Clusters')
    axis on
    axis([min(dataDBS(:,1)) max(dataDBS(:,1)) min(dataDBS(:,2)) max(dataDBS(:,2))])
    box on
    
    else end
   
end
end

axes(handles.axes4);cla reset;

for i = 1:length(DBSCAN_filtered);
    
scatter(DBSCAN_filtered{i,1}(DBSCAN_filtered{i,1}(:,end-1)==1,1),DBSCAN_filtered{i,1}(DBSCAN_filtered{i,1}(:,end-1)==1,2),1,'black');hold on;
scatter(DBSCAN_filtered{i,1}(DBSCAN_filtered{i,1}(:,end-1)==2,1),DBSCAN_filtered{i,1}(DBSCAN_filtered{i,1}(:,end-1)==2,2),1,'red');hold on;

title('Found Particles');
legend('Channel 1', 'Channel 2');
box on; axis square;

end

fprintf(' -- DBSCAN computed in %f sec -- \n',toc)



% --- Executes on button press in saveParams.
function saveParams_Callback(hObject, eventdata, handles)
% hObject    handle to saveParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global global_struct;

global_struct.K         = handles.K;
global_struct.Eps       = handles.Eps;
global_struct.minLength = handles.minLength;

particleFilter_GUI

fprintf('\n -- Filter defined -- \n');

close(findobj('Name','defineDBSCAN_GUI'));
