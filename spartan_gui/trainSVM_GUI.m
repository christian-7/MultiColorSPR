function varargout = trainSVM_GUI(varargin)
% TRAINSVM MATLAB code for trainSVM.fig
%      TRAINSVM, by itself, creates a new TRAINSVM or raises the existing
%      singleton*.
%
%      H = TRAINSVM returns the handle to a new TRAINSVM or the handle to
%      the existing singleton*.
%
%      TRAINSVM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRAINSVM.M with the given input arguments.
%
%      TRAINSVM('Property','Value',...) creates a new TRAINSVM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before trainSVM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to trainSVM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help trainSVM

% Last Modified by GUIDE v2.5 29-May-2018 21:03:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @trainSVM_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @trainSVM_GUI_OutputFcn, ...
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


% --- Executes just before trainSVM is made visible.
function trainSVM_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to trainSVM (see VARARGIN)

% Choose default command line output for trainSVM
handles.output = hObject;

clc;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes trainSVM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = trainSVM_GUI_OutputFcn(hObject, eventdata, handles) 
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

[FileName_Ch1,Path_Ch1] = uigetfile({'*.mat'},'Load Training Data');
    
    % Read the selected file into the variable
    
    disp('Reading Training Data ...');
    
    [path,Name_Ch1,ext_Ch1] = fileparts(FileName_Ch1);
    
    handles.Ext_Ch1     = ext_Ch1 ;
    handles.Path_Ch1    = Path_Ch1;
    handles.Name_Ch1    = Name_Ch1;
    
    cd(Path_Ch1);
    
    % Extract variable name
    
    temp = load([Name_Ch1 ext_Ch1]);
    name = fieldnames(temp);
    exp = ['temp.' name{1,1}];
        
    %
    
    handles.Particles          = eval(exp); 
    
    if isempty(handles.Particles)==0;
    
    set(handles.loadData,'BackgroundColor','green');
    
    else end
    
    disp('Training Data loaded.');

% textLabel = ['Total particles = ', num2str(size(handles.Particles.toSave,1))];
% set(handles.text1, 'String', textLabel);

% handles.partID = 1;

guidata(hObject, handles); % Update handles structure

    


% --- Executes on button press in loadRespo.
function loadRespo_Callback(hObject, eventdata, handles)
% hObject    handle to loadRespo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName_Ch1,Path_Ch1] = uigetfile({'*.mat'},'Load Response');
    
    % Read the selected file into the variable
    
    disp('Reading Response ...');
    
    [path,Name_Ch1,ext_Ch1] = fileparts(FileName_Ch1);
    
    handles.Ext_Ch1     = ext_Ch1 ;
    handles.Path_Ch1    = Path_Ch1;
    handles.Name_Ch1    = Name_Ch1;
    
    cd(Path_Ch1);
    
    % Extract variable name
    
    temp = load([Name_Ch1 ext_Ch1]);
    name = fieldnames(temp);
    exp = ['temp.' name{1,1}];
        
    %
    handles.response          = eval(exp); 
    
    if isempty(handles.Particles)==0;
    
    set(handles.loadRespo,'BackgroundColor','green');
    
    else end
    
    disp('Response loaded.');
      
% Generate Table    
        
handles.predictorNames = {'Rg', 'Ecc', 'FRC', 'MeanH', 'StdH', 'MinH', 'MaxH', 'CircRatio','RectRatio','FA','Sym','Circ'};

Rg          = cell2mat(handles.Particles(:,2));
Ecc         = cell2mat(handles.Particles(:,3));
FRC         = cell2mat(handles.Particles(:,4));
MeanH       = cell2mat(handles.Particles(:,5));
StdH        = cell2mat(handles.Particles(:,6));
MinH        = cell2mat(handles.Particles(:,7));
MaxH        = cell2mat(handles.Particles(:,8));
CircRatio   = cell2mat(handles.Particles(:,9));
RectRatio   = cell2mat(handles.Particles(:,10));
FA          = cell2mat(handles.Particles(:,11));
Sym         = cell2mat(handles.Particles(:,12));
Circ        = cell2mat(handles.Particles(:,13));

handles.test_data = table(Rg,Ecc,FRC,MeanH,StdH,MinH,MaxH,CircRatio,RectRatio,FA,Sym,Circ,...
    'VariableNames',handles.predictorNames);

disp('Generated Table of Test Data.');

guidata(hObject, handles); % Update handles structure


% --- Executes on button press in trainSVM.
function trainSVM_Callback(hObject, eventdata, handles)
% hObject    handle to trainSVM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;

inputTable      = handles.test_data;
predictors      = inputTable(:, handles.predictorNames);
response        = handles.response;

% response        = inputTable.response;
% response        = response-1;
L               = logical(response);
response        = L;

% Train the model

    mdlSVM = fitcsvm(...
    predictors, ...
    response, ...
    'KernelFunction', 'polynomial', ...
    'PolynomialOrder', 2, ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true);

mdlSVM = fitPosterior(mdlSVM);
[~,score_svm] = resubPredict(mdlSVM);

handles.model = mdlSVM;

disp('Model trained.');

% Display ROC

[Xsvm,Ysvm,Tsvm,AUCsvm,OPTROCPT] = perfcurve(response,score_svm(:,mdlSVM.ClassNames),'true');

axes(handles.axes1);cla reset;box on;
plot(Xsvm,Ysvm,'LineWidth',2,'Color','b');hold on;
plot(OPTROCPT(1),OPTROCPT(2),'ro')

text(0.5,0.6, ['FPR    = ', num2str(round(OPTROCPT(1),2))],'FontSize',12);
text(0.5,0.7, ['TPR    = ', num2str(round(OPTROCPT(2),2))],'FontSize',12);
text(0.5,0.8, ['Thresh = ', num2str(round(Tsvm((Xsvm==OPTROCPT(1))&(Ysvm==OPTROCPT(2))),2))],'FontSize',12);
text(0.5,0.5, ['AUC    = ', num2str(round((AUCsvm),2))],'FontSize',12);


xlabel('False positive rate')
ylabel('True positive rate')
title('ROC Curve for SVM Classification')
hold off

guidata(hObject, handles); % Update handles structure


% --- Executes on button press in saveSVM.
function saveSVM_Callback(hObject, eventdata, handles)
% hObject    handle to saveSVM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;

mdlSVM = handles.model;

cd(handles.Path_Ch1); 
save(['TrainedSVM.mat'],'mdlSVM');

guidata(hObject, handles); % Update handles structure


% --- Executes on button press in loadData.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to loadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in loadRespo.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to loadRespo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in testOnTraining.
function testOnTraining_Callback(hObject, eventdata, handles)
% hObject    handle to testOnTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;

Class_Result = predict(handles.model,handles.test_data);

% Class_Result = trainedClassifier.predictFcn(test_data);

disp([' -- Test Data Classified -- ']);

Predicted = {};

count = 1;

for i = 1:length(Class_Result);

    if Class_Result(i,1)==1;

    Predicted{count,1} = handles.Particles{i,1}; % Channel 1

    count = count+1;

    else end

end

disp([' -- ' num2str(count) '/' num2str(size(handles.test_data,1)) ' particles predicted -- ']);
%

% Show overview of selection

close all;

pxlsize = 10; xCol = 1; yCol = 2;

for i = 1:length(Predicted);

        heigth      = round((max(Predicted{i,1}(:,yCol)) - min(Predicted{i,1}(:,yCol)))/pxlsize);
        width       = round((max(Predicted{i,1}(:,xCol)) - min(Predicted{i,1}(:,xCol)))/pxlsize);

        rendered    = hist3([Predicted{i,1}(:,yCol),Predicted{i,1}(:,xCol)],[heigth width]);

        Predicted{i,2} = hist3([Predicted{i,1}(:,yCol),Predicted{i,1}(:,xCol)],[heigth width]);

end

% Make a Gallery of both channels

NbrOfSubplots = round(sqrt(length(Predicted)))+1;

figure%('Position',[100 100 800 800]);

for i = 1:length(Predicted);

    subplot(NbrOfSubplots,NbrOfSubplots,i);
    imagesc(imgaussfilt(Predicted{i,2},1));
    title(['ID = ' num2str(i)]);
    set(gca,'YTickLabel',[],'XTickLabel',[]);
    colormap hot
    axis equal

end

% guidata(hObject, handles); % Update handles structure

% --- Executes on button press in useSVM.
function useSVM_Callback(hObject, eventdata, handles)
% hObject    handle to useSVM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = hObject;

% Load Data

[FileName_Ch1,Path_Ch1] = uigetfile({'*.mat'},'Load Data');
    
    % Read the selected file into the variable
    
    disp('Reading Data ...');
    
    [path,Name_Ch1,ext_Ch1] = fileparts(FileName_Ch1);
    
    handles.Ext_Ch1     = ext_Ch1 ;
    handles.Path_Ch1    = Path_Ch1;
    handles.Name_Ch1    = Name_Ch1;
    
    cd(Path_Ch1);
    
    % Extract variable name
    
    temp = load([Name_Ch1 ext_Ch1]);
    name = fieldnames(temp);
    exp = ['temp.' name{1,1}];

    handles.DataforClass          = eval(exp); 
    
    disp('Data loaded.');

% Transform into table

handles.predictorNames = {'Rg', 'Ecc', 'FRC', 'MeanH', 'StdH', 'MinH', 'MaxH', 'CircRatio','RectRatio','FA','Sym','Circ'};

Rg          = cell2mat(handles.DataforClass(:,2));
Ecc         = cell2mat(handles.DataforClass(:,3));
FRC         = cell2mat(handles.DataforClass(:,4));
MeanH       = cell2mat(handles.DataforClass(:,5));
StdH        = cell2mat(handles.DataforClass(:,6));
MinH        = cell2mat(handles.DataforClass(:,7));
MaxH        = cell2mat(handles.DataforClass(:,8));
CircRatio   = cell2mat(handles.DataforClass(:,9));
RectRatio   = cell2mat(handles.DataforClass(:,10));
FA          = cell2mat(handles.DataforClass(:,11));
Sym         = cell2mat(handles.DataforClass(:,12));
Circ        = cell2mat(handles.DataforClass(:,13));

handles.DataTable = table(Rg,Ecc,FRC,MeanH,StdH,MinH,MaxH,CircRatio,RectRatio,FA,Sym,Circ,...
    'VariableNames',handles.predictorNames);

disp('Generated Table of Test Data.');

% Classify

Class_Result = predict(handles.model,handles.DataTable);

% Class_Result = trainedClassifier.predictFcn(test_data);

disp([' -- Data Classified -- ']);

Predicted = {};

count = 1;

for i = 1:length(Class_Result);

    if Class_Result(i,1)==1;

    Predicted{count,1} = handles.DataforClass{i,1}; % Channel 1
    Predicted{count,2} = handles.DataforClass{i,2}; % Channel 1

    count = count+1;

    else end

end

disp([' -- ' num2str(count) '/' num2str(size(handles.test_data,1)) ' particles predicted -- ']);

% Save predicted particles

disp([' -- Saving predicted particles -- ']);

cd(handles.Path_Ch1); 
save(['Predicted_Particles.mat'],'Predicted');

guidata(hObject, handles); % Update handles structure


