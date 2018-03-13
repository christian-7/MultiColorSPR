function varargout = manualSegment(varargin)
% MANUALSEGMENT MATLAB code for manualSegment.fig
%      MANUALSEGMENT, by itself, creates a new MANUALSEGMENT or raises the existing
%      singleton*.
%
%      H = MANUALSEGMENT returns the handle to a new MANUALSEGMENT or the handle to
%      the existing singleton*.
%
%      MANUALSEGMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALSEGMENT.M with the given input arguments.
%
%      MANUALSEGMENT('Property','Value',...) creates a new MANUALSEGMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manualSegment_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manualSegment_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help manualSegment

% Last Modified by GUIDE v2.5 13-Mar-2018 21:32:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @manualSegment_OpeningFcn, ...
                   'gui_OutputFcn',  @manualSegment_OutputFcn, ...
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


% --- Executes just before manualSegment is made visible.
function manualSegment_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manualSegment (see VARARGIN)

% Choose default command line output for manualSegment
handles.output = hObject;


handles.WFmin = 250;
handles.WFmax = 1000;
handles.ThreshMin = 3e-3;
handles.ThreshMax = 2e-2;


 h = findobj('Tag','segmenterHead');

 if ~isempty(h);
    g1data = guidata(h);
 end
 
 
axes(handles.figDisplay)
imshow(imadjust(g1data.PrimaryWF));
 
 
%     % maybe you want to set the text in Gui2 with that from Gui1
%     set(handles.text1,'String',get(g1data.wfInt,'String'));
%     
%     % maybe you want to get some data that was saved to the Gui1 app
%     x = getappdata(h,'x');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes manualSegment wait for user response (see UIRESUME)
% uiwait(handles.manSeg);


% --- Outputs from this function are returned to the command line.
function varargout = manualSegment_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function wfInt_Callback(hObject, eventdata, handles)
% hObject    handle to wfInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wfInt as text
%        str2double(get(hObject,'String')) returns contents of wfInt as a double

handles = guidata(hObject);

string2 = regexp(get(hObject,'String'), ',', 'split' )

handles.WFmin = str2double(string2{1,1});
handles.WFmax = str2double(string2{1,2});

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function wfInt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wfInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Thresh_Callback(hObject, eventdata, handles)
% hObject    handle to Thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Thresh as text
%        str2double(get(hObject,'String')) returns contents of Thresh as a double

handles = guidata(hObject);

string2 = regexp(get(hObject,'String'), ',', 'split' )

handles.ThreshMin = str2double(string2{1,1});
handles.ThreshMax = str2double(string2{1,2});

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function Thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updateWF.
function updateWF_Callback(hObject, eventdata, handles)
% hObject    handle to updateWF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','segmenterHead');

 if ~isempty(h);
    g1data = guidata(h);
 end
 
 
axes(handles.figDisplay);
imshow(g1data.PrimaryWF,[handles.WFmin handles.WFmax]);



% --- Executes on button press in segment.
function segment_Callback(hObject, eventdata, handles)
% hObject    handle to segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj('Tag','segmenterHead');

 if ~isempty(h);
    g1data = guidata(h);
 end
 

% adjust the contrast of the raw image

I2  = imadjust(g1data.PrimaryWF,[handles.ThreshMin handles.ThreshMax],[]);
I3  = imgaussfilt(I2, 5);
I4  = imadjust(I3,[0.2 0.5],[]);
bin = im2bw(I4,0.3);

axes(handles.figDisplay);
imshow(bin);

handles.binary = bin;
guidata(hObject, handles); % Update handles structure



% --- Executes on button press in saveParam.
function saveParam_Callback(hObject, eventdata, handles)
% hObject    handle to saveParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    h = findobj('Tag','segmenterHead');

    if ~isempty(h);
    g1data = guidata(h);
    end
 
    HandleMainGUI = getappdata(0,'segmenterHead');
    %write a local variable called MyData to SharedData, any type of data
    setappdata(h,'FOV',[1:53]); 
   
    

segmenter_GUI
close(findobj('Name','manualSegment'));

