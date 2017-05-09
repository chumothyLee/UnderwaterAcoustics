function varargout = sample_generation_gui(varargin)
% SAMPLE_GENERATION_GUI MATLAB code for sample_generation_gui.fig
%      SAMPLE_GENERATION_GUI, by itself, creates a new SAMPLE_GENERATION_GUI or raises the existing
%      singleton*.
%
%      H = SAMPLE_GENERATION_GUI returns the handle to a new SAMPLE_GENERATION_GUI or the handle to
%      the existing singleton*.
%
%      SAMPLE_GENERATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAMPLE_GENERATION_GUI.M with the given input arguments.
%
%      SAMPLE_GENERATION_GUI('Property','Value',...) creates a new SAMPLE_GENERATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sample_generation_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sample_generation_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sample_generation_gui

% Last Modified by GUIDE v2.5 09-May-2017 09:52:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sample_generation_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @sample_generation_gui_OutputFcn, ...
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


% --- Executes just before sample_generation_gui is made visible.
function sample_generation_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sample_generation_gui (see VARARGIN)

% Choose default command line output for sample_generation_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sample_generation_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%my code

imshow('blank.jpg', 'Parent', handles.axes1)
imshow('noise.jpg', 'Parent', handles.axes2)
imshow('croak.jpg', 'Parent', handles.axes3)
imshow('jetski.jpg', 'Parent', handles.axes4)
imshow('clicktrain.jpg', 'Parent', handles.axes5)
imshow('pulsetrain.jpg', 'Parent', handles.axes6)
imshow('buzz.jpg', 'Parent', handles.axes7)
imshow('downsweep.jpg', 'Parent', handles.axes8)
imshow('beat.jpg', 'Parent', handles.axes9)
%end my code






% --- Outputs from this function are returned to the command line.
function varargout = sample_generation_gui_OutputFcn(hObject, eventdata, handles) 
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
input(prompt0,'s') = 'y';
% end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







