function varargout = MainMenu(varargin)
% MAINMENU MATLAB code for MainMenu.fig
%      MAINMENU, by itself, creates a new MAINMENU or raises the existing
%      singleton*.
%
%      H = MAINMENU returns the handle to a new MAINMENU or the handle to
%      the existing singleton*.
%
%      MAINMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINMENU.M with the given input arguments.
%
%      MAINMENU('Property','Value',...) creates a new MAINMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainMenu

% Last Modified by GUIDE v2.5 14-May-2017 18:41:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainMenu_OpeningFcn, ...
                   'gui_OutputFcn',  @MainMenu_OutputFcn, ...
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


% --- Executes just before MainMenu is made visible.
function MainMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainMenu (see VARARGIN)

% Choose default command line output for MainMenu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainMenu wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%% spectogram plot
axes(handles.axes1)
%ns=[1:length(baseline0)]*parm.skip/parm.sample_freq;
%fr=linspace(parm.freq_lo,parm.freq_hi,parm.bin_hi-parm.bin_lo+1);
%matlabImage = imagesc(ns,fr,20*log10(abs(sp)),[-40,0]);
%image(matlabImage);
axis xy; 
title('Spectrogram'); 

axes(handles.axes2)
matlabImage = imread('./ImagesForLegend/blank.jpg');
imshow(matlabImage)
title('blank - option 1');
axis off
axis image

axes(handles.axes3)
matlabImage = imread('./ImagesForLegend/noise.jpg');
imshow(matlabImage)
title('noise - option 2');
axis off
axis image

axes(handles.axes4)
matlabImage = imread('./ImagesForLegend/croak.jpg');
imshow(matlabImage)
title('croak - option 3');
axis off
axis image

axes(handles.axes5)
matlabImage = imread('./ImagesForLegend/jetski.jpg');
imshow(matlabImage)
title('jetski - option 4');
axis off
axis image

axes(handles.axes6)
matlabImage = imread('./ImagesForLegend/clicktrain.jpg');
imshow(matlabImage)
title('clicktrain - option 5');
axis off
axis image

axes(handles.axes7)
matlabImage = imread('./ImagesForLegend/pulsetrain.jpg');
imshow(matlabImage)
title('pulsetrain - option 6');
axis off
axis image

axes(handles.axes8)
matlabImage = imread('./ImagesForLegend/buzz.jpg');
imshow(matlabImage)
title('buzz - option 7');
axis off
axis image

axes(handles.axes9)
matlabImage = imread('./ImagesForLegend/downsweep.jpg');
imshow(matlabImage)
title('downsweep - option 8')
axis off
axis image

axes(handles.axes10)
matlabImage = imread('./ImagesForLegend/beat.jpg');
imshow(matlabImage)
title('beat - option 9');
axis off
axis image

axes(handles.axes11)
matlabImage = imread('im1.jpg');
imshow(matlabImage)
title('label');
axis off
axis image

% --- Outputs from this function are returned to the command line.
function varargout = MainMenu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
