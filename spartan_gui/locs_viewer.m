function varargout = locs_viewer(varargin)
% LOCS_VIEWER MATLAB code for locs_viewer.fig
%      LOCS_VIEWER, by itself, creates a new LOCS_VIEWER or raises the existing
%      singleton*.
%
%      H = LOCS_VIEWER returns the handle to a new LOCS_VIEWER or the handle to
%      the existing singleton*.
%
%      LOCS_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOCS_VIEWER.M with the given input arguments.
%
%      LOCS_VIEWER('Property','Value',...) creates a new LOCS_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before locs_viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to locs_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help locs_viewer

% Last Modified by GUIDE v2.5 07-Aug-2018 22:11:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @locs_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @locs_viewer_OutputFcn, ...
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


% --- Executes just before locs_viewer is made visible.
function locs_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to locs_viewer (see VARARGIN)

% Choose default command line output for locs_viewer
handles.output = hObject;


handles.pxlsize     = 106;
handles.binsize     = 15;
handles.imsize      = 512;
handles.segpara     = 500;
handles.format      = 'ThunderStorm';
handles.method      = 'RCC';
handles.pxlsizeVis  = 10;
handles.locsFilt    = [];
handles.locsDC      = [];
handles.filtSig     = [100,250];
handles.filtPhot    = 500;
handles.filtUnc     = 25;
handles.filtFrame   = 100;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes locs_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = locs_viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in inputFormat.
function inputFormat_Callback(hObject, eventdata, handles)
% hObject    handle to inputFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns inputFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from inputFormat

handles.output = hObject;
contents = cellstr(get(hObject,'String'));
handles.format = contents{get(hObject,'Value')};
fprintf(['\n ' handles.format ' format selected \n']);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function inputFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadLocs.
function loadLocs_Callback(hObject, eventdata, handles)
% hObject    handle to loadLocs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    handles = guidata(hObject);

    [FileName_Ch1,Path_Ch1] = uigetfile({'*.csv';'*.dat'},'Select Loc file');
    
    % Read the selected file into the variable
    
    fprintf('\n -- Reading Localization file, please wait ... -- \n ');
    
    [path,Name_Ch1,ext_Ch1] = fileparts(FileName_Ch1);
    
    handles.Ext_Ch1     = ext_Ch1;
    handles.Path_Ch1    = Path_Ch1;
    handles.Name_Ch1    = Name_Ch1;
    
    cd(Path_Ch1);
    
    handles.locs          = dlmread([Name_Ch1 ext_Ch1],',',1,0); 
    
    % Read the header
    
    file         = fopen([Name_Ch1 ext_Ch1]);
    handles.line = fgetl(file);
    header            = regexp(handles.line, ',', 'split' );
    
    if contains(handles.format,'Thunder')==1;

    handles.xCol            = strmatch('"x [nm]"',header);
    handles.yCol            = strmatch('"y [nm]"',header);
    handles.framesCol       = strmatch('"frame"',header);
    handles.sigmaCol        = strmatch('"sigma [nm]"',header);
    handles.uncertaintyCol  = strmatch('"uncertainty_xy [nm]"',header);
    handles.photonsCol      = strmatch('"intensity [photon]"',header);
    
    else 
     
handles.xCol            = strmatch('x_nm',header);
handles.yCol            = strmatch('y_nm',header);
handles.framesCol       = strmatch('frame',header);
handles.LLCol           = strmatch('logLikelyhood',header);
handles.photonsCol      = strmatch('photons',header);
    end   

    if isempty(handles.locs)==0;
    
    set(handles.loadLocs,'BackgroundColor','green');
    
    set(handles.locCount, 'String', [num2str(length(handles.locs)) ' localizations ']);
    
    else end
    
    fprintf('\n -- Localization file loaded -- \n');

    guidata(hObject, handles); % Update handles structure



function segparam_Callback(hObject, eventdata, handles)
% hObject    handle to segparam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of segparam as text
%        str2double(get(hObject,'String')) returns contents of segparam as a double

handles = guidata(hObject);
handles.segparam = str2double(get(hObject,'String'));
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function segparam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segparam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imsize_Callback(hObject, eventdata, handles)
% hObject    handle to imsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imsize as text
%        str2double(get(hObject,'String')) returns contents of imsize as a double

handles = guidata(hObject);
handles.imsize = str2double(get(hObject,'String'));
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



function pxlsize_Callback(hObject, eventdata, handles)
% hObject    handle to pxlsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pxlsize as text
%        str2double(get(hObject,'String')) returns contents of pxlsize as a double

handles = guidata(hObject);
handles.pxlsize = str2double(get(hObject,'String'));
guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function pxlsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pxlsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function binsize_Callback(hObject, eventdata, handles)
% hObject    handle to binsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of binsize as text
%        str2double(get(hObject,'String')) returns contents of binsize as a double

handles = guidata(hObject);
handles.binsize = str2double(get(hObject,'String'));
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function binsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to binsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showFilter.
function showFilter_Callback(hObject, eventdata, handles)
% hObject    handle to showFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

if isempty(handles.locsDC)==1;
   
     locs = handles.locs;
    
else locs = handles.locsDC;

end

figure('Position',[200 200 1000 300],'Name','Filter parameters');

subplot(1,3,1);
bins = [0:20:500];
h = hist(locs(:,handles.sigmaCol),bins);
bar(bins,h/sum(h)); 
title(['Median = ' num2str(median(locs(:,handles.sigmaCol)))]);
xlabel('sigma (nm)');
ylabel('norm. counts');
axis square; box on;
axis([0 500 0 max(h/sum(h))]);

subplot(1,3,2);
bins = [0:2:50];
h = hist(locs(:,handles.uncertaintyCol),bins);
bar(bins,h/sum(h)); 
title(['Median = ' num2str(median(locs(:,handles.uncertaintyCol)))]);
xlabel('uncertainty (nm)');
ylabel('norm. counts');
axis square; box on;
axis([0 50 0 max(h/sum(h))]);

subplot(1,3,3);
bins = [0:5e2:1e4];
h = hist(locs(:,handles.photonsCol),bins);
bar(bins,h/sum(h)); 
title(['Median = ' num2str(median(locs(:,handles.photonsCol)))]);
xlabel('photons (nm)');
ylabel('norm. counts');
axis square; box on;
axis([0 1e4 0 max(h/sum(h))]);

guidata(hObject, handles); % Update handles structure


% --- Executes on button press in filterLocs.
function filterLocs_Callback(hObject, eventdata, handles)
% hObject    handle to filterLocs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

if   isempty(handles.locsDC)==1;
   
     locs = handles.locs;
    
else locs = handles.locsDC;

end

filter              = [];
filter              = find(locs(:,handles.photonsCol) > handles.filtPhot & ... 
                           locs(:,handles.uncertaintyCol) < handles.filtUnc & ... 
                           locs(:,handles.framesCol) > handles.filtUnc & ... 
                           locs(:,handles.sigmaCol) > handles.filtSig(1,1) & ... 
                           locs(:,handles.sigmaCol) < handles.filtSig(1,2));
                       
locsFilt            = locs(filter,1:end);

set(handles.locCount, 'String', ['Localizations filtered (' num2str(length(locsFilt)/length(locs)) ' left)']);

handles.locsFilt = locsFilt;

guidata(hObject, handles); % Update handles structure

% --- Executes on button press in startRCC.
function startRCC_Callback(hObject, eventdata, handles)
% hObject    handle to startRCC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

coords = [];
coords(:,1) = handles.locs(:,handles.xCol)/handles.pxlsize;
coords(:,2) = handles.locs(:,handles.yCol)/handles.pxlsize;
coords(:,3) = handles.locs(:,handles.framesCol);

if contains(handles.method,'DCC')==1;
    
fprintf('\n -- Starting DCC ... \n');

[coordscorr, finaldrift] = DCC(coords, handles.segpara, handles.imsize, handles.pxlsize, handles.binsize);
    
elseif contains(handles.method,'MCC')==1;
    
fprintf('\n -- Starting MCC ... \n');

[coordscorr, finaldrift] = MCC(coords, handles.segpara, handles.imsize, handles.pxlsize, handles.binsize);
   
else

fprintf('\n -- Starting RCC ... \n');

[coordscorr, finaldrift] = RCC(coords, handles.segpara, handles.imsize, handles.pxlsize, handles.binsize, 0.2);

end

figure('Position',[100 100 600 400],'Name', 'RCC dirft correction');
subplot(2,1,1)
plot(finaldrift(:,1)*handles.pxlsize)
title('x Drift')
xlabel('frame');
ylabel('drift (nm)');

subplot(2,1,2)
plot(finaldrift(:,2)*handles.pxlsize)
title('y Drift');
xlabel('frame');
ylabel('drift (nm)');

handles.locsDC = handles.locs;
handles.locsDC(:,handles.xCol) = coordscorr(:,1) * handles.pxlsize;
handles.locsDC(:,handles.yCol) = coordscorr(:,2) * handles.pxlsize;

figure
scatter(coordscorr(:,1),coordscorr(:,2),'.');
scatter(handles.locsDC(:,handles.xCol),handles.locsDC(:,handles.yCol),'.');


guidata(hObject, handles); % Update handles structure



function pxlsizeVis_Callback(hObject, eventdata, handles)
% hObject    handle to pxlsizeVis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pxlsizeVis as text
%        str2double(get(hObject,'String')) returns contents of pxlsizeVis as a double

handles = guidata(hObject);
handles.pxlsizeVis = str2double(get(hObject,'String'));
guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function pxlsizeVis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pxlsizeVis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Visualize.
function Visualize_Callback(hObject, eventdata, handles)
% hObject    handle to Visualize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

if isempty(handles.locsFilt)==1;

heigth = round((max(handles.locsDC(:,handles.yCol)) - min((handles.locsDC(:,handles.yCol))))/handles.pxlsizeVis);
width  = round((max(handles.locsDC(:,handles.xCol)) - min((handles.locsDC(:,handles.xCol))))/handles.pxlsizeVis);
        
rendered = hist3([handles.locsDC(:,handles.yCol),handles.locsDC(:,handles.xCol)],[heigth width]);

else 
 
heigth = round((max(handles.locsFilt(:,handles.yCol)) - min((handles.locsFilt(:,handles.yCol))))/handles.pxlsizeVis);
width  = round((max(handles.locsFilt(:,handles.xCol)) - min((handles.locsFilt(:,handles.xCol))))/handles.pxlsizeVis);
        
rendered = hist3([handles.locsFilt(:,handles.yCol),handles.locsFilt(:,handles.xCol)],[heigth width]);

end

handles.rendered = imgaussfilt(rendered,1);

figure('Position',[300 300 500 500],'Name','Gaussian blurred localizations') 
imshow(imgaussfilt(rendered,1));
colormap(gca,'hot')

guidata(hObject, handles); % Update handles structure



% --- Executes on button press in saveIM.
function saveIM_Callback(hObject, eventdata, handles)
% hObject    handle to saveIM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

selpath = uigetdir(handles.Path_Ch1,'Select Save Path');

cd(selpath);


I32 = [];
I32 = uint32(handles.rendered);

t = Tiff([handles.Name_Ch1 '_DC.tiff'],'w');
tagstruct.ImageLength     = size(I32,1);
tagstruct.ImageWidth      = size(I32,2);
tagstruct.Photometric     = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample   = 32;
tagstruct.SamplesPerPixel = 1;
tagstruct.RowsPerStrip    = 16;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.Software        = 'MATLAB';
t.setTag(tagstruct)

t.write(I32);
t.close()

guidata(hObject, handles); % Update handles structure



function filtFrame_Callback(hObject, eventdata, handles)
% hObject    handle to filtFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filtFrame as text
%        str2double(get(hObject,'String')) returns contents of filtFrame as a double


handles = guidata(hObject);
handles.filtFrame = str2double(get(hObject,'String'));
guidata(hObject, handles); % Update handles structure


% --- Executes during object creation, after setting all properties.
function filtFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filtSigma_Callback(hObject, eventdata, handles)
% hObject    handle to filtSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filtSigma as text
%        str2double(get(hObject,'String')) returns contents of filtSigma as a double

handles = guidata(hObject);

string = get(hObject,'String');
handles.filtSig = str2double(regexp(string,',', 'split'));

guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function filtSigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filtUnc_Callback(hObject, eventdata, handles)
% hObject    handle to filtUnc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filtUnc as text
%        str2double(get(hObject,'String')) returns contents of filtUnc as a double

handles = guidata(hObject);
handles.filtUnc = str2double(get(hObject,'String'));
guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function filtUnc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtUnc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filtPhot_Callback(hObject, eventdata, handles)
% hObject    handle to filtPhot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filtPhot as text
%        str2double(get(hObject,'String')) returns contents of filtPhot as a double

handles = guidata(hObject);
handles.filtPhot = str2double(get(hObject,'String'));
guidata(hObject, handles); % Update handles structure



% --- Executes during object creation, after setting all properties.
function filtPhot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtPhot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in undoFilt.
function undoFilt_Callback(hObject, eventdata, handles)
% hObject    handle to undoFilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

set(handles.locCount, 'String', ['Filter removed (' num2str(length(handles.locs)) ' localizations left)']);

set(handles.locCount, 'String', [num2str(length(handles.locs)) ' localizations ']);

handles.locsFilt = [];

guidata(hObject, handles); % Update handles structure


% --- Executes on button press in saveLocs.
function saveLocs_Callback(hObject, eventdata, handles)
% hObject    handle to saveLocs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

if isempty(handles.locsFilt);
   
    locsToSave = handles.locsDC;
    savename = [handles.Name_Ch1 '_DC.csv'];

else
    
    locsToSave = handles.locsFilt;
    savename = [handles.Name_Ch1 '_filt.csv'];
    

end

cd(Path_Ch1);

fileID = fopen(savename,'w');
fprintf(fileID,[[handles.line] ' \n']);
dlmwrite(savename,locsToSave,'-append');
fclose('all');

guidata(hObject, handles); % Update handles structure


% --- Executes on selection change in method.
function method_Callback(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from method

handles.output = hObject;
contents = cellstr(get(hObject,'String'));
handles.method = contents{get(hObject,'Value')};
fprintf(['\n ' handles.method ' selected \n']);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
