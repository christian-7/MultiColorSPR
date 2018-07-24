function varargout = basicGUI(varargin)

% BASICGUI MATLAB code for basicGUI.fig
%      BASICGUI, by itself, creates a new BASICGUI or raises the existing
%      singleton*.
%
%      H = BASICGUI returns the handle to a new BASICGUI or the handle to
%      the existing singleton*.
%
%      BASICGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BASICGUI.M with the given input arguments.
%
%      BASICGUI('Property','Value',...) creates a new BASICGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before basicGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to basicGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help basicGUI

% Last Modified by GUIDE v2.5 25-Feb-2018 16:12:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @basicGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @basicGUI_OutputFcn, ...
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


% --- Executes just before basicGUI is made visible.
function basicGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to basicGUI (see VARARGIN)
% Choose default command line output for basicGUI
% Update handles structure

addpath('functions');

% Store the default parameters 

handles.output = [];
handles.diameterCh1 = 3;
handles.diameterCh2 = 5;
handles.brigthCh1 = 100;
handles.brigthCh2 = 100;
handles.diamCh1 = 4;
handles.diamCh2 = 5;

handles.RgMinCh1 = 3;
handles.RgMinCh2 = 3.5;
handles.RgMaxCh1 = 3.8;
handles.RgMaxCh2 = 4.2;
handles.MaxIntCh1 = 3.5e5;
handles.MaxIntCh2 = 0.5e5;

guidata(hObject, handles);

% UIWAIT makes basicGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = basicGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure

varargout{1} = handles.output;


% --- Executes on button press in LoadImageCh1.
function LoadImageCh1_Callback(hObject, eventdata, handles)
% hObject    handle to LoadImageCh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

    disp('Load image button pressed ...')

% Create a file dialog for images

    [filename, user_cancelled] = imgetfile;
    if user_cancelled
            disp('User pressed cancel')
    else
            disp(['User selected ', filename])
    end

    % Read the selected image into the variable
    disp('Reading the image into variable X');
    handles.ImCh1 = imread(filename);
    
    guidata(hObject, handles); % Update handles structure
    
    axes(handles.pkfind_Ch1)
    imshow(imadjust(handles.ImCh1));

% --- Executes on button press in loadimagech2.
function LoadImageCh2_Callback(hObject, eventdata, handles)
% hObject    handle to loadimagech2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    disp('Load image button pressed ...')

% Create a file dialog for images

    [filename, user_cancelled] = imgetfile;
    if user_cancelled
            disp('User pressed cancel')
    else
            disp(['User selected ', filename])
    end

    % Read the selected image into the variable
    disp('Reading the image into variable X');
    handles.ImCh2 = imread(filename);
    axes(handles.pkfind_Ch2)
    imshow(imadjust(handles.ImCh2));
    guidata(hObject, handles); % Update handles structure


% --- Executes on button press in apply_bpass_CH1.
function apply_bpass_CH1_Callback(hObject, eventdata, handles)

% hObject    handle to apply_bpass_CH1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

% CH1

handles.imBpassCh1 = bpass(handles.ImCh1,1,handles.diameterCh1);  % fist number = 1; second = diameter
axes(handles.pkfind_Ch1)
imshow(imadjust(handles.imBpassCh1))

% CH2

handles.imBpassCh2 = bpass(handles.ImCh2,1,handles.diameterCh2);
axes(handles.pkfind_Ch2)
imshow(imadjust(handles.imBpassCh2))

guidata(hObject, handles); % Update handles structure



function var_diameter_Ch1_Callback(hObject, eventdata, handles)
% hObject    handle to var_diameter_Ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var_diameter_Ch1 as text
%        str2double(get(hObject,'String')) returns contents of var_diameter_Ch1 as a double
handles = guidata(hObject);
handles.diameterCh1 = str2double(get(hObject,'String'))

guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function var_diameter_Ch1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var_diameter_Ch1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function var_diamter_Ch2_Callback(hObject, eventdata, handles)
% hObject    handle to var_diamter_Ch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var_diamter_Ch2 as text
%        str2double(get(hObject,'String')) returns contents of var_diamter_Ch2 as a double
handles = guidata(hObject);
handles.diameterCh2 = str2double(get(hObject,'String'))

guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function var_diamter_Ch2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var_diamter_Ch2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function var_brigthCh1_Callback(hObject, eventdata, handles)
% hObject    handle to var_brigthCh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var_brigthCh1 as text
%        str2double(get(hObject,'String')) returns contents of var_brigthCh1 as a double

handles = guidata(hObject);
handles.brigthCh1 = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function var_brigthCh1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var_brigthCh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function var_brigthCh2_Callback(hObject, eventdata, handles)
% hObject    handle to var_brigthCh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var_brigthCh2 as text
%        str2double(get(hObject,'String')) returns contents of var_brigthCh2 as a double

handles = guidata(hObject);
handles.brigthCh2 = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function var_brigthCh2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var_brigthCh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pkfind.
function pkfind_Callback(hObject, eventdata, handles)
% hObject    handle to pkfind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

% pkfind

handles.pkCh1 = pkfnd(handles.imBpassCh1,handles.brigthCh1,handles.diamCh1);   % brigthness threshold, diameter
handles.pkCh2 = pkfnd(handles.imBpassCh2,handles.brigthCh2,handles.diamCh2); % brigthness threshold, diameter

% Cnt

handles.cntCh1 = cntrd(handles.imBpassCh1,handles.pkCh1,5); % image, position estimate, diameter of the window
handles.cntCh2 = cntrd(handles.imBpassCh2,handles.pkCh2,5);

axes(handles.pkfind_Ch1);cla reset;
imshow(imadjust(handles.ImCh1));hold on;
scatter(handles.cntCh1(:,1),handles.cntCh1(:,2),10,'r*');

axes(handles.pkfind_Ch2);cla reset;
imshow(imadjust(handles.ImCh2));hold on;
scatter(handles.cntCh2(:,1),handles.cntCh2(:,2),10,'r*');

% 
axes(handles.AffineInput)
cla reset;
scatter(handles.cntCh1(:,1),handles.cntCh1(:,2),10,'ro');box on; axis square; hold on;
scatter(handles.cntCh2(:,1),handles.cntCh2(:,2),10,'g*');box on; axis square; 
legend('Ch1','Ch2');
xlabel('pxl');ylabel('pxl')


guidata(hObject, handles); % Update handles structure



function var_diamCh1_Callback(hObject, eventdata, handles)
% hObject    handle to var_diamCh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var_diamCh1 as text
%        str2double(get(hObject,'String')) returns contents of var_diamCh1 as a double

handles = guidata(hObject);
handles.diamCh1 = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function var_diamCh1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var_diamCh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function var_diamCh2_Callback(hObject, eventdata, handles)
% hObject    handle to var_diamCh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var_diamCh2 as text
%        str2double(get(hObject,'String')) returns contents of var_diamCh2 as a double

handles = guidata(hObject);
handles.diamCh2 = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function var_diamCh2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var_diamCh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in affTrans.
function affTrans_Callback(hObject, eventdata, handles)
% hObject    handle to affTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

[handles.T_lwm, handles.TRE, corrected_moving, fixed, moving] = calculateAffineTrans(106,1,handles.cntCh1F,handles.cntCh2F);

axes(handles.transOutput)
cla reset;
scatter(fixed(:,1),fixed(:,2),'gx');hold on;
scatter(moving(:,1),moving(:,2),'ro');hold on;
scatter(corrected_moving(:,1),corrected_moving(:,2),'rx');hold on;
legend('Ch1','Ch2','Ch2 corr')
box on; axis equal;
xlabel('nm');ylabel('nm');

meanTRE = mean(handles.TRE);
textLabel = sprintf('TRE = %.2f nm', meanTRE);
set(handles.text1, 'String', textLabel);


guidata(hObject, handles); % Update handles structure


% --- Executes on button press in filterPkfnd.
function filterPkfnd_Callback(hObject, eventdata, handles)
% hObject    handle to filterPkfnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

filter_Ch1 = find(handles.cntCh1(:,3) <  handles.MaxIntCh1 & handles.cntCh1(:,4) <  handles.RgMaxCh1 & handles.cntCh1(:,4) >  handles.RgMinCh1);
filter_Ch2 = find(handles.cntCh2(:,3) <  handles.MaxIntCh2 & handles.cntCh2(:,4) <  handles.RgMaxCh2 & handles.cntCh2(:,4) >  handles.RgMinCh2);

% Plot the filtered peaks

axes(handles.pkfind_Ch1)
imshow(imadjust(handles.ImCh1));hold on;
scatter(handles.cntCh1(filter_Ch1,1),handles.cntCh1(filter_Ch1,2),10,'r*');

axes(handles.pkfind_Ch2)
imshow(imadjust(handles.ImCh2));hold on;
scatter(handles.cntCh2(filter_Ch2,1),handles.cntCh2(filter_Ch2,2),10,'r*');

% 
axes(handles.AffineInput)
cla reset;
scatter(handles.cntCh1(filter_Ch1,1),handles.cntCh1(filter_Ch1,2),10,'ro');box on; axis square; hold on;
scatter(handles.cntCh2(filter_Ch2,1),handles.cntCh2(filter_Ch2,2),10,'g*');box on; axis square; 
xlabel('pxl');ylabel('pxl');
legend('Ch1','Ch2');

% Create filtered Input for Affine Trans

handles.cntCh1F = handles.cntCh1(filter_Ch1,1:end);
handles.cntCh2F = handles.cntCh2(filter_Ch2,1:end);

guidata(hObject, handles); % Update handles structure




function RgMinCh1_Callback(hObject, eventdata, handles)
% hObject    handle to RgMinCh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RgMinCh1 as text
%        str2double(get(hObject,'String')) returns contents of RgMinCh1 as a double

handles = guidata(hObject);
handles.RgMinCh1 = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function RgMinCh1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RgMinCh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RgMinCh2_Callback(hObject, eventdata, handles)
% hObject    handle to RgMinCh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RgMinCh2 as text
%        str2double(get(hObject,'String')) returns contents of RgMinCh2 as a double

handles = guidata(hObject);
handles.RgMinCh2 = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function RgMinCh2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RgMinCh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RgMaxCh1_Callback(hObject, eventdata, handles)
% hObject    handle to RgMaxCh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RgMaxCh1 as text
%        str2double(get(hObject,'String')) returns contents of RgMaxCh1 as a double

handles = guidata(hObject);
handles.RgMaxCh1 = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function RgMaxCh1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RgMaxCh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RgMaxCh2_Callback(hObject, eventdata, handles)
% hObject    handle to RgMaxCh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RgMaxCh2 as text
%        str2double(get(hObject,'String')) returns contents of RgMaxCh2 as a double

handles = guidata(hObject);
handles.RgMaxCh2 = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function RgMaxCh2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RgMaxCh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxIntCh1_Callback(hObject, eventdata, handles)
% hObject    handle to MaxIntCh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxIntCh1 as text
%        str2double(get(hObject,'String')) returns contents of MaxIntCh1 as a double

handles = guidata(hObject);
handles.MaxIntCh1 = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function MaxIntCh1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxIntCh1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxIntCh2_Callback(hObject, eventdata, handles)
% hObject    handle to MaxIntCh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxIntCh2 as text
%        str2double(get(hObject,'String')) returns contents of MaxIntCh2 as a double

handles = guidata(hObject);
handles.MaxIntCh2 = str2double(get(hObject,'String'))
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function MaxIntCh2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxIntCh2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveAff.
function SaveAff_Callback(hObject, eventdata, handles)
% hObject    handle to SaveAff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

toSave = handles.T_lwm;

uisave('toSave','T_lwm_data.mat');


% --- Executes on button press in histForFilter.
function histForFilter_Callback(hObject, eventdata, handles)
% hObject    handle to histForFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Brightness

range = 0:max([handles.cntCh1(:,3);handles.cntCh2(:,3)])/20:max([handles.cntCh1(:,3);handles.cntCh2(:,3)]);

h1 = transpose(hist(handles.cntCh1(:,3),range));
h2 = transpose(hist(handles.cntCh2(:,3),range));

h3 = [h1/sum(h1) h2/sum(h2)];

figure('Position',[100 200 700 300]);
subplot(1,2,1)
bar(range,h3);
box on; axis square
xlabel('peak brightness'); ylabel('norm counts');
legend('Ch1','Ch2');

% Rg

range = 0:max([handles.cntCh1(:,4);handles.cntCh2(:,4)])/20:max([handles.cntCh1(:,4);handles.cntCh2(:,4)]);

h1 = transpose(hist(handles.cntCh1(:,4),range));
h2 = transpose(hist(handles.cntCh2(:,4),range));

h3 = [h1/sum(h1) h2/sum(h2)];

subplot(1,2,2)
bar(range,h3);
box on; axis square
xlabel('radius of gyration (Rg)'); ylabel('norm counts');
legend('Ch1','Ch2');
