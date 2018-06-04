function varargout = FirstParticleFilter(varargin)
% FIRSTPARTICLEFILTER MATLAB code for FirstParticleFilter.fig
%      FIRSTPARTICLEFILTER, by itself, creates a new FIRSTPARTICLEFILTER or raises the existing
%      singleton*.
%
%      H = FIRSTPARTICLEFILTER returns the handle to a new FIRSTPARTICLEFILTER or the handle to
%      the existing singleton*.
%
%      FIRSTPARTICLEFILTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIRSTPARTICLEFILTER.M with the given input arguments.
%
%      FIRSTPARTICLEFILTER('Property','Value',...) creates a new FIRSTPARTICLEFILTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FirstParticleFilter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FirstParticleFilter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FirstParticleFilter

% Last Modified by GUIDE v2.5 27-Mar-2018 21:32:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FirstParticleFilter_OpeningFcn, ...
                   'gui_OutputFcn',  @FirstParticleFilter_OutputFcn, ...
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


% --- Executes just before FirstParticleFilter is made visible.
function FirstParticleFilter_OpeningFcn(hObject, eventdata, handles, varargin)

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FirstParticleFilter (see VARARGIN)

% Choose default command line output for FirstParticleFilter

handles.output = hObject;

handles.maxInt_Ch1 = 2e4;
handles.maxInt_Ch2 = 2e4;
handles.minInt_Ch1 = 10;
handles.minInt_Ch2 = 100;

handles.minPhot_Ch1 = 500;
handles.minPhot_Ch2 = 200;

handles.minFrame_Ch1 = 100;
handles.minFrame_Ch2 = 500;

handles.maxSigma_Ch1 = 200;
handles.maxSigma_Ch2 = 200;

handles.minSigma_Ch1 = 100;
handles.minSigma_Ch2 = 100;

handles.maxUnc_Ch1 = 25;
handles.maxUnc_Ch2 = 30;



%  h = findobj('Tag','particleFilter');
 h = particleFilter_GUI;

 if ~isempty(h);
    g1data = guidata(h);
 end

% Show Histogram of the length

Cent        = g1data.Particles;
count       = 0;
Cent_filt   = {};

for i = 1:length(Cent.particles);
    
    if isempty(Cent.particles{i,1}) | isempty(Cent.particles{i,5});
    
    else
        
NbrOfLocs(i,1) = length(Cent.particles{i,1}); % Channel 1
NbrOfLocs(i,2) = length(Cent.particles{i,5}); % Channel 2

    end
end

axes(handles.figDisplay);
hist(NbrOfLocs,50);
xlabel('Number of localizations');
ylabel('Count');
title(['Median = ' num2str(median(NbrOfLocs))])
legend('Channel 1','Channel 2');

Cent_filt = Cent.particles;

ID = 1; photonsCol = 5; uncertaintyCol = 4; sigmaCol = 8;

bins = min(min(Cent_filt{ID,1}(:,photonsCol)),min(Cent_filt{ID,5}(:,photonsCol))) : (max(max(Cent_filt{ID,1}(:,photonsCol)),min(Cent_filt{ID,5}(:,photonsCol)))-min(min(Cent_filt{ID,1}(:,photonsCol)),min(Cent_filt{ID,5}(:,photonsCol))))/20 : max(max(Cent_filt{ID,1}(:,photonsCol)),min(Cent_filt{ID,5}(:,photonsCol)));

h1 = transpose(hist(Cent_filt{ID,1}(:,photonsCol),bins));
h2 = transpose(hist(Cent_filt{ID,5}(:,photonsCol),bins));
h3 = [h1/sum(h1) h2/sum(h2)];
axes(handles.axes2);
bar(bins, h3);
xlabel('Photon Count');
ylabel('Count');
legend('Channel 1','Channel 2');


bins = min(min(Cent_filt{ID,1}(:,uncertaintyCol)),min(Cent_filt{ID,5}(:,uncertaintyCol))) : (max(max(Cent_filt{ID,1}(:,uncertaintyCol)),min(Cent_filt{ID,5}(:,uncertaintyCol)))-min(min(Cent_filt{ID,1}(:,uncertaintyCol)),min(Cent_filt{ID,5}(:,uncertaintyCol))))/20 : max(max(Cent_filt{ID,1}(:,uncertaintyCol)),min(Cent_filt{ID,5}(:,uncertaintyCol)));

h1 = transpose(hist(Cent_filt{ID,1}(:,uncertaintyCol),bins));
h2 = transpose(hist(Cent_filt{ID,5}(:,uncertaintyCol),bins));
h3 = [h1/sum(h1) h2/sum(h2)];
axes(handles.axes3);
bar(bins, h3);
xlabel('Loc uncertainty');
ylabel('Count');
legend('Channel 1','Channel 2');


bins = min(min(Cent_filt{ID,1}(:,sigmaCol)),min(Cent_filt{ID,5}(:,sigmaCol))) : (max(max(Cent_filt{ID,1}(:,sigmaCol)),min(Cent_filt{ID,5}(:,sigmaCol)))-min(min(Cent_filt{ID,1}(:,sigmaCol)),min(Cent_filt{ID,5}(:,sigmaCol))))/20 : max(max(Cent_filt{ID,1}(:,sigmaCol)),min(Cent_filt{ID,5}(:,sigmaCol)));

h1 = transpose(hist(Cent_filt{ID,1}(:,sigmaCol),bins));
h2 = transpose(hist(Cent_filt{ID,5}(:,sigmaCol),bins));
h3 = [h1/sum(h1) h2/sum(h2)];
axes(handles.axes4);
bar(bins, h3);
xlabel('sigma');
ylabel('Count');
legend('Channel 1','Channel 2');



guidata(hObject, handles);

% UIWAIT makes FirstParticleFilter wait for user response (see UIRESUME)
% uiwait(handles.FirstFilter);


% --- Outputs from this function are returned to the command line.
function varargout = FirstParticleFilter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function minInt_Callback(hObject, eventdata, handles)
% hObject    handle to minInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minInt as text
%        str2double(get(hObject,'String')) returns contents of minInt as a double

handles = guidata(hObject);

string2 = regexp(get(hObject,'String'), ',', 'split' )

handles.minInt_Ch1 = str2double(string2{1,1});
handles.minInt_Ch2 = str2double(string2{1,2});

guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function minInt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minPhot_Callback(hObject, eventdata, handles)
% hObject    handle to minPhot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minPhot as text
%        str2double(get(hObject,'String')) returns contents of minPhot as a double

handles = guidata(hObject);

string2 = regexp(get(hObject,'String'), ',', 'split' )

handles.minPhot_Ch1 = str2double(string2{1,1});
handles.minPhot_Ch2 = str2double(string2{1,2});

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function minPhot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minPhot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updateLocs.
function updateLocs_Callback(hObject, eventdata, handles)
% hObject    handle to updateLocs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% h = findobj('Tag','particleFilter');
% 
%  if ~isempty(h);
%     g1data = guidata(h);
%  end
%  
% % Filter for length
% 
% Cent        = g1data.Particles;
% count       = 0;
% Cent_filt   = {};
%  
% for i = 1:length(Cent.particles);
%     
%     if isempty(Cent.particles{i,1}) | isempty(Cent.particles{i,5});
%     
%     else
%         
% NbrOfLocs(i,1) = length(Cent.particles{i,1}); % Channel 1
% NbrOfLocs(i,2) = length(Cent.particles{i,5}); % Channel 2
% 
% if length(Cent.particles{i,1})>handles.minInt_Ch1 & length(Cent.particles{i,1})<handles.maxInt_Ch1 & length(Cent.particles{i,5})>handles.minInt_Ch2 & length(Cent.particles{i,5})<handles.maxInt_Ch2;
%    
% count = count+1;    
%     
% Cent_filt{count,1} = Cent.particles{i,1}; 
% Cent_filt{count,2} = Cent.particles{i,2};
% Cent_filt{count,3} = Cent.particles{i,3};
% Cent_filt{count,4} = Cent.particles{i,4};
% Cent_filt{count,5} = Cent.particles{i,5};
% Cent_filt{count,6} = Cent.particles{i,6};
% Cent_filt{count,7} = Cent.particles{i,7};
% Cent_filt{count,8} = Cent.particles{i,8};
% 
% else end
% 
%     end
% end
% 
% % Filter locs
% 
% minFrame            = [handles.minFrame_Ch1,handles.minFrame_Ch2];
% MinPhotons          = [handles.minPhot_Ch1, handles.minPhot_Ch2];
% Maxuncertainty      = [handles.maxUnc_Ch1, handles.maxUnc_Ch2];
% 
% xCol = 1; yCol = 2; frameCol = 3; uncCol = 4; photonCol = 5; LLCol = 7; sigmaCol = 8; zCol = 12;
% 
% Cent_filt_2C = {}; % New variable combining both datasets for each ROI
% 
% for i = 1:length(Cent_filt)
%         
% Cent_filt{i,1}(:,size(Cent.particles{1,1},2)+1) = 1; % new channel ID variable
% filter_Ch1              = [];
% filter_Ch1              = find(Cent_filt{i,1}(:,photonCol) > MinPhotons(1) & Cent_filt{i,1}(:,uncCol) < Maxuncertainty(1) & Cent_filt{i,1}(:,frameCol) > minFrame(1));
% 
% Cent_filt{i,5}(:,size(Cent.particles{1,1},2)+1) = 2; % new channel ID variable
% filter_Ch2              = [];
% filter_Ch2              = find(Cent_filt{i,5}(:,photonCol) > MinPhotons(2) & Cent_filt{i,5}(:,uncCol) < Maxuncertainty(2) & Cent_filt{i,5}(:,frameCol) > minFrame(2));
% 
% Cent_filt_2C{i,1}       = vertcat(Cent_filt{i,1}(filter_Ch1,1:end),Cent_filt{i,5}(filter_Ch2,1:end));
% 
% end
%  
% % Update the plots





% --- Executes on button press in segment.
function segment_Callback(hObject, eventdata, handles)
% hObject    handle to segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles); % Update handles structure



% --- Executes on button press in saveParam.
function saveParam_Callback(hObject, eventdata, handles)
% hObject    handle to saveParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global global_struct;

global_struct.maxInt_Ch1 = handles.maxInt_Ch1;
global_struct.maxInt_Ch2 = handles.maxInt_Ch2;

global_struct.minInt_Ch1 = handles.minInt_Ch1;
global_struct.minInt_Ch2 = handles.minInt_Ch2;

global_struct.minPhot_Ch1 = handles.minPhot_Ch1;
global_struct.minPhot_Ch2 = handles.minPhot_Ch2;

global_struct.minFrame_Ch1 = handles.minFrame_Ch1;
global_struct.minFrame_Ch2 = handles.minFrame_Ch2;

global_struct.maxSigma_Ch1 = handles.maxSigma_Ch1;
global_struct.maxSigma_Ch2 = handles.maxSigma_Ch2;

global_struct.minSigma_Ch1 = handles.minSigma_Ch1;
global_struct.minSigma_Ch2 = handles.minSigma_Ch2;

global_struct.maxUnc_Ch1 = handles.maxUnc_Ch1;
global_struct.maxUnc_Ch2 = handles.maxUnc_Ch2;

particleFilter_GUI

fprintf('\n -- Filter defined -- \n');

close(findobj('Name','FirstParticleFilter'));



function maxInt_Callback(hObject, eventdata, handles)
% hObject    handle to maxInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxInt as text
%        str2double(get(hObject,'String')) returns contents of maxInt as a double

handles = guidata(hObject);

string2 = regexp(get(hObject,'String'), ',', 'split' );

handles.maxInt_Ch1 = str2double(string2{1,1});
handles.maxInt_Ch2 = str2double(string2{1,2});

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function maxInt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minFrame_Callback(hObject, eventdata, handles)
% hObject    handle to minFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minFrame as text
%        str2double(get(hObject,'String')) returns contents of minFrame as a double

handles = guidata(hObject);

string2 = regexp(get(hObject,'String'), ',', 'split' );

handles.minFrame_Ch1 = str2double(string2{1,1});
handles.minFrame_Ch2 = str2double(string2{1,2});

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function minFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minSigma_Callback(hObject, eventdata, handles)
% hObject    handle to minSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minSigma as text
%        str2double(get(hObject,'String')) returns contents of minSigma as a double


handles = guidata(hObject);

string2 = regexp(get(hObject,'String'), ',', 'split' );

handles.minSigma_Ch1 = str2double(string2{1,1});
handles.minSigma_Ch2 = str2double(string2{1,2});

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function minSigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxSigma_Callback(hObject, eventdata, handles)
% hObject    handle to maxSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxSigma as text
%        str2double(get(hObject,'String')) returns contents of maxSigma as a double

handles = guidata(hObject);

string2 = regexp(get(hObject,'String'), ',', 'split' );

handles.maxSigma_Ch1 = str2double(string2{1,1});
handles.maxSigma_Ch2 = str2double(string2{1,2});

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function maxSigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxUncer_Callback(hObject, eventdata, handles)
% hObject    handle to text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text as text
%        str2double(get(hObject,'String')) returns contents of text as a double

handles = guidata(hObject);

string2 = regexp(get(hObject,'String'), ',', 'split' );

handles.maxUnc_Ch1 = str2double(string2{1,1});
handles.maxUnc_Ch2 = str2double(string2{1,2});

guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function maxUncer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxUncer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
