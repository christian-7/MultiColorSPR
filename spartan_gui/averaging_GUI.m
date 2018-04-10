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

% Last Modified by GUIDE v2.5 10-Apr-2018 12:08:07

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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
