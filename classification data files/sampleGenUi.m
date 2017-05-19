function varargout = sampleGenUi(varargin)
% SAMPLEGENUI MATLAB code for sampleGenUi.fig
%      SAMPLEGENUI, by itself, creates a new SAMPLEGENUI or raises the existing
%      singleton*.
%
%      H = SAMPLEGENUI returns the handle to a new SAMPLEGENUI or the handle to
%      the existing singleton*.
%
%      SAMPLEGENUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAMPLEGENUI.M with the given input arguments.
%
%      SAMPLEGENUI('Property','Value',...) creates a new SAMPLEGENUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sampleGenUi_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sampleGenUi_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sampleGenUi

% Last Modified by GUIDE v2.5 17-May-2017 17:27:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sampleGenUi_OpeningFcn, ...
                   'gui_OutputFcn',  @sampleGenUi_OutputFcn, ...
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


% --- Executes just before sampleGenUi is made visible.
function sampleGenUi_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to sampleGenUi (see VARARGIN)
    
    global fileIndex;
    global processStarted;
    fileIndex = 0;
    processStarted = false;

    %% initialize axes plots with image legends
    axes(handles.blank)
    matlabImage = imread('./ImagesForLegend/blank.jpg');
    imshow(matlabImage)
    title('blank - option 1');
    axis off
    axis image

    axes(handles.noise)
    matlabImage = imread('./ImagesForLegend/noise.jpg');
    imshow(matlabImage)
    title('noise - option 2');
    axis off
    axis image

    axes(handles.croak)
    matlabImage = imread('./ImagesForLegend/croak.jpg');
    imshow(matlabImage)
    title('croak - option 3');
    axis off
    axis image

    axes(handles.jetski)
    matlabImage = imread('./ImagesForLegend/jetski.jpg');
    imshow(matlabImage)
    title('jetski - option 4');
    axis off
    axis image

    axes(handles.clicktrain)
    matlabImage = imread('./ImagesForLegend/clicktrain.jpg');
    imshow(matlabImage)
    title('clicktrain - option 5');
    axis off
    axis image

    axes(handles.pulsetrain)
    matlabImage = imread('./ImagesForLegend/pulsetrain.jpg');
    imshow(matlabImage)
    title('pulsetrain - option 6');
    axis off
    axis image

    axes(handles.buzz)
    matlabImage = imread('./ImagesForLegend/buzz.jpg');
    imshow(matlabImage)
    title('buzz - option 7');
    axis off
    axis image

    axes(handles.downsweep)
    matlabImage = imread('./ImagesForLegend/downsweep.jpg');
    imshow(matlabImage)
    title('downsweep - option 8')
    axis off
    axis image

    axes(handles.beat)
    matlabImage = imread('./ImagesForLegend/beat.jpg');
    imshow(matlabImage)
    title('beat - option 9');
    axis off
    axis image

    %axes(handles.sample)
    %matlabImage = imread('im1.jpg');
    %imshow(matlabImage)
    %title('label');
    %axis off
    %axis image
    %%
    
    

    % Choose default command line output for sampleGenUi
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes sampleGenUi wait for user response (see UIRESUME)
    % uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sampleGenUi_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in confirmLabel.
function confirmLabel_Callback(hObject, eventdata, handles)
% hObject    handle to confirmLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in skipLabel.
function skipLabel_Callback(hObject, eventdata, handles)
% hObject    handle to skipLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in beginLabelProc.
function beginLabelProc_Callback(hObject, eventdata, handles)
    % hObject    handle to beginLabelProc (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    %% check global flag
    global processStarted;
    
    if processStarted == true
        return
    end
    
    processStarted = true;
    
    %% setup workspace object parm
    run('new_parm.m');
    
    % dialogue to prompt user to select a .x.wav to process
    choice = questdlg('Select a .x.wav file to process', 'Select Data', 'OK', 'Cancel','OK');

    if strcmp(choice, 'Cancel')
       return
    end

    % get file and file path
    [filename, pathname]= uigetfile('*.x.wav');
    cwd=pwd;
    cd(pathname)
    file_dir=pwd;
    addpath(pwd);
    files=dir('*.x.wav');
    cd(cwd);

    for i = 1:length(files)
        if strcmp(files(i).name,filename)
            file_index = i;
            break;
        end
    end

    calls=[];
    t_pad=parm.pad*parm.sample_freq;
    t_actual=parm.nrec-2*t_pad;
    data = [];
    labels = [];
    timeinfo = [];


    filenum = 0;

    %% dialogue to prompt user to select a directory to put training data
    choice = questdlg('Select a directory to store training data', 'Select Directory', 'OK', 'Cancel','OK');

    if strcmp(choice, 'Cancel')
       return
    end

    % directory name to store training data
    dirToStore = uigetdir;
    %%

    for q=file_index
        %fprintf("for loop: %d\n", q)
        if(length(files(q).name) > 4 )
            %fprintf("length of files(q).name is > 4\n")
            if( strcmp(files(q).name(end-5:end),'.x.wav'))
                %fprintf("valid file\n")
                %siz=audioread(files(q).name);
                info = audioinfo(files(q).name);
                siz = [info.TotalSamples, info.NumChannels];

                %fprintf("finished with audioread\n")
                %fprintf("siz(1) = %d\n", siz(1))
                scale_factor=1;

                temp_name=files(q).name;
                PARAMS=getxwavheaders(file_dir,temp_name);
                julian_start_date=PARAMS.ltsahd.dnumStart(1);
                %fprintf("finished with getxwavheaders\n")
                time = julian_start_date + datenum(2000,0,0,0,0,0);
                %fprintf("t_actual: %d\n", t_actual)
                for(j=1:siz/t_actual/scale_factor)

                    %fprintf("j: %d, num_iterations: %d\n", j, siz/t_actual);

                    fprintf("j: %d\n", j);
                    off=(j-1)*t_actual+t_pad;

                    %datestr(julian_start_date+datenum(2000,0,0,0,0,(off+1-t_pad)/parm.sample_freq))
                    datestr=0;
                    if(off+1+t_pad+t_actual > siz)
                        endlimit = siz;
                    else
                        endlimit = off+1+t_pad+t_actual;
                    end

                    sub_data=audioread(files(q).name,[off+1-t_pad,endlimit]);

                    fprintf("calling spectogram\n");

                    time_new = time + datenum(0,0,0,0,0,(j-1)*((parm.nrec/parm.sample_freq) - 2*parm.pad));

                   [sp] = GPL_fft(sub_data,parm);
                    %fprintf("finished GPL_fft")
                    %%%%%%% Whiten and smooth
                    sp_whiten = GPL_whiten(sp,parm);
                    sp_loop=sp_whiten;

                    %%%%%%% Extract and replicate quiet (non-signal) portion of data
                    [quiet_whiten, quiet_fft, quiet_base, noise_floor, blocked, baseline0] = GPL_quiet(sp,sp_whiten,parm);

                    norm_v=sp_loop./(ones(parm.nfreq,1)*sum(sp_loop.^2).^(1/2));
                    norm_h=sp_loop./(sum(sp_loop'.^2).^(1/2)'*ones(1,parm.nbin));

                    %next step was not a part of GPL in Helble et al.
                    norm_v=whiten_matrix(norm_v')';norm_h=whiten_matrix(norm_h);

                    bas=abs(norm_v).^parm.xp1.*abs(norm_h).^parm.xp2;

                    axes(handles.spectogram)

                    
                    ns=[1:length(baseline0)]*parm.skip/parm.sample_freq;
                    fr=linspace(parm.freq_lo,parm.freq_hi,parm.bin_hi-parm.bin_lo+1);
                    imagesc(ns,fr,20*log10(abs(sp)),[-40,0]);
                    title('Spectrogram'); 
                    axis xy
                    
                    waitforbuttonpress;

                    
                    
                    
                    filenum = filenum + 1;

                   

                end

            end

        end

    end



    

% --- Executes on button press in finishLabelProc.
function finishLabelProc_Callback(hObject, eventdata, handles)
    % hObject    handle to finishLabelProc (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global processStarted;


% --- Executes on button press in blankButton.
function blankButton_Callback(hObject, eventdata, handles)
% hObject    handle to blankButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of blankButton

% --- Executes on button press in noiseButton.
function noiseButton_Callback(hObject, eventdata, handles)
% hObject    handle to noiseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of noiseButton

% --- Executes on button press in croakButton.
function croakButton_Callback(hObject, eventdata, handles)
% hObject    handle to croakButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of croakButton

% --- Executes on button press in jetskiButton.
function jetskiButton_Callback(hObject, eventdata, handles)
% hObject    handle to jetskiButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of jetskiButton

% --- Executes on button press in clicktrainButton.
function clicktrainButton_Callback(hObject, eventdata, handles)
% hObject    handle to clicktrainButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of clicktrainButton

% --- Executes on button press in pulsetrainButton.
function pulsetrainButton_Callback(hObject, eventdata, handles)
% hObject    handle to pulsetrainButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of pulsetrainButton

% --- Executes on button press in buzzButton.
function buzzButton_Callback(hObject, eventdata, handles)
% hObject    handle to buzzButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of buzzButton

% --- Executes on button press in downsweepButton.
function downsweepButton_Callback(hObject, eventdata, handles)
% hObject    handle to downsweepButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of downsweepButton

% --- Executes on button press in beatButton.
function beatButton_Callback(hObject, eventdata, handles)
% hObject    handle to beatButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of beatButton