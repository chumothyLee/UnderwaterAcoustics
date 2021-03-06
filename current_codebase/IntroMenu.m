function varargout = IntroMenu(varargin)
% INTROMENU MATLAB code for IntroMenu.fig
%      INTROMENU, by itself, creates a new INTROMENU or raises the existing
%      singleton*.
%
%      H = INTROMENU returns the handle to a new INTROMENU or the handle to
%      the existing singleton*.
%
%      INTROMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTROMENU.M with the given input arguments.
%
%      INTROMENU('Property','Value',...) creates a new INTROMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IntroMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IntroMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IntroMenu

% Last Modified by GUIDE v2.5 11-Jun-2017 00:07:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IntroMenu_OpeningFcn, ...
                   'gui_OutputFcn',  @IntroMenu_OutputFcn, ...
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


% --- Executes just before IntroMenu is made visible.
function IntroMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IntroMenu (see VARARGIN)

% Choose default command line output for IntroMenu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IntroMenu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IntroMenu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in process x.wav file.
function processXWav_Callback(hObject, eventdata, handles)
% hObject    handle to processXWav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% runs new_parm and automatically steps through training process
% run('new_parm.m');
% run('sample_generation_main.m');
% runs sampleGenUI and steps through process via a User Interface
 run('sampleGenUi.m');

% --- Executes on button press in processTrainData.
function processTrainData_Callback(hObject, eventdata, handles)
% hObject    handle to processTrainData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('loading.m');


% --- Executes on button press in procIntervals.
function procIntervals_Callback(hObject, eventdata, handles)
% hObject    handle to procIntervals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('./fishcalls/process_intervals.m');

% --- Executes on button press in procData.
function procData_Callback(hObject, eventdata, handles)
% hObject    handle to procData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('./fishcalls/process_test_data.m');