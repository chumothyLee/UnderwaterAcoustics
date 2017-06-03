function [cal_time_series]=calibrate_harp(time_series,TF)
%function [cal_time_series]=calibrate_harp(time_series,TF)
    %note: original units in the documentation of the harp tf files are dB re uPa(rms)^2/counts^2.
    %so --> (timeseries_in_counts)*(10^(value/20))= X uPascals    
%% DONT ADJUST THESE AND EXPECT POSITIVE RESULTS
        Fs_O=10000;%Sampling Frequency Original TimeSeriess        
        NFFT_INV=100000;%X point fft for inverted fft and fft 
        BITS_PER_SAMPLE=16;%16; 

%% TESTING code (if you want this...go find the function at the end...and uncomment it out)
    %{
    TESTING=0;
    if TESTING
        FilterOrder=170;%divisible by Fs_Orig/Fs_new and even
        Fs_R=2000;%Sampling Frequency Resampled                                             
        basepath='Z:\';
        HARP_FOLDER=fullfile(basepath,'lmr-harp',sprintf('SOCAL%s','H'),sprintf('%02d%s',40,'H'),filesep);
        numOfChunks=1;
        sizeOfChunkSec=50;
        [~,time_series]= dbr_GetSamples(HARP_FOLDER,FilterOrder,numOfChunks,sizeOfChunkSec,Fs_O,Fs_R,BITS_PER_SAMPLE,NFFT_INV,1,1,1,1);    
        time_series=time_series(FilterOrder+1:end-FilterOrder);        
        TF=load('Z:\lmr-harp\CALIBRATION_FILES\HARP_TF_FILES\HARP_TF_FILES\SOCAL\SOCAL40H\591_100331\591_100331_invSensit.tf');    
        assignin('base','TF',TF);%TF data is frequency data from the tf cal files.
        assignin('base','time_series',time_series);        
        dbr_MakeBackups();
    end        
    %}
%% INTERPOLATE THE TF data from the harp calibration files.                        
    %need to define the region before first sample, need to taper it down.
    %if its abrupt, then filter..which we do later  elsewhere in the monte carlo sim...so
    tf_calData=TF;
    tf_calData_interp_dB = interp1(tf_calData(:,1),tf_calData(:,2),0:0.1:5000);%interpolated so df's are equally spaced at 0.1hz like sig+cram
    tf_calData_interp_dB(isnan(tf_calData_interp_dB)) = 0 ;%need to deal with tapering..or...if your filtering later...at undesired freq...
    tf_scale_linear=complex(10.^(tf_calData_interp_dB/20)',0);%make linear %all real components, assuming phase 0    

%% PLOT OR NOT TO PLOT...your call
PLOT_CAL_CURVE=0;    
    if PLOT_CAL_CURVE        
        figure(1);clf;    
        plot(tf_calData(:,1),tf_calData(:,2),'b*',0:0.1:5000,20*log10(tf_scale_linear),'g--.');
        %plot(tf_calData(:,1),tf_calData(:,2),'x');
        axis([30 100 70 73]);
        xlabel('Frequency(Hz)');ylabel('dB re 1 uPa^2/Counts^2');
        title('quick dB check of invSensit.tf file');
        legend('show');legend('orig','interp');
        print('-djpeg','CalibrationTransferFunctionInterpolation_all.jpg');
    end

%% apply the interpolated transfer function...note assumption about 0 phase     
    %Convert the input data to counts
    cal_time_series=time_series*floor((2^16)/2);%bitsPerSample=16bits        
    Lsize=length(cal_time_series);    
    if Lsize>1000000
        cal_time_series=[];
        error('calibrate_harp():: The function cannot presently handle more than 100 seconds of 10kHz data');
    end %ASSUMPTIONS....timeseries is 10khz and no bigger than 100 seconds    
    
    % convert into the freq domain    
    %100 seconds of 10khz @ 0.1Hz intervals .keeps bean counting easy
    % a very convoluted/complicated way of obtaining the fft of the input.
    %ive already slayed this dragon...i know it lookss odd...but
    %essentially im using the spectrogram function to handle the dirty
    %work. to make sure spectrogram was doing it right, i did the dirty
    %work as well, you can toggle between the 2 options in the sub function
    %if you want...its defaulting to letting matlab do the dirty work
    % by dirty work, i mean managing the cases where the input time series
    % has more samples in it than the fft length. in that instance matlab's
    % fft will just truncate the results...which we cant allow...so....we
    %vectorize the input
    paddedTS=padarray(cal_time_series,[1000000-Lsize 0],0,'post');
    [Sn,~,~,~] = spectrogram(paddedTS,boxcar(NFFT_INV),0,NFFT_INV,Fs_O);                                   
    
    %modify the scalar so it works with spectrogram/fft matrix output
    newTFSCALAR=repmat(tf_scale_linear,1,size(Sn,2));    
    %convolve the scalar about the timeseries...in the freq Domain multiply    
    cal_time_series=ifft(Sn.*newTFSCALAR,NFFT_INV,'symmetric');    
    %reshape the vectored output matrix back into 1 dimension
    cal_time_series=reshape(cal_time_series,[(size(cal_time_series,1)*size(cal_time_series,2)),1]);
    %trim the result to do away with the padding that occurred.
    cal_time_series=cal_time_series(1:Lsize);                                                             
    assignin('base','cal_time_series',cal_time_series);
    
    PLOT_INPUT_OUTPUT=0;
    if PLOT_INPUT_OUTPUT
        figure(2);clf;
        subplot(2,1,1);
        plot(time_series);
        subplot(2,1,2)        
        plot(cal_time_series);
    end

end

%% hacking from these core functions...which where hacked.
%{ 
%this is why i get away with the spectrogram function doing the dirty work!
function [S,F,T,P,dt_sgram,df_sgram,status,win]=dbr_UTILITY(NFFT,timeSeries,Fs,percentOL,wintype)                                
    type=0;%type0 is all matlab, type1 is my own roll(they are equivalent!)        
    %keep in mind things get different when the timeseries is longer than
    %the fft length...just packaging issues.
    [L,~]=size(timeSeries);  
    Noverlap= floor(((percentOL)/100)*NFFT);% Number of Overlap( 50%)
    if strcmp(wintype,'kaiser')
        win=kaiser(NFFT,7.5);%alpha=2.5 or beta=7.5 %win = hanning(NFFT);%window definition
    else
        win=boxcar(NFFT);
    end
    dt_sgram_offset=NFFT/2/Fs;
    dt_sgram=(NFFT-Noverlap)/Fs;%deterimine the time bin size        
    df_sgram=Fs/NFFT;
    scaleFactor=1/((sum(win.^2)));%boxcar...this is 1/FFTL
    %scaleFactor=1/(Fs*NFFT*(1/NFFT)*(sum(win.^2)));%boxcar...this is 1/FFTL
    %Ts = 1/Fs;                                
    
    %S-->Xavg_dft
    %P-->abs(Xavg_dft)^2 for boxcar
    %P returns pressure spectral density....upa^2/hz
    %P(f)=(S(f)^2)/(fs*fftl*(1/fftl)*sum(window^2))
    if type==0    
        %all matlab! both mine and theirs are verified equivalents!!!        
        
        [S,F,T,~] = spectrogram(timeSeries,win,Noverlap,NFFT,Fs);     
        %size(T)
        numOfTimeBins=size(T,2);%aka k        
        %choosing to overwrite matlab scaling factor applied to P and using
        %own desired scaling factor on the fft output S.
        %normalize . Note: the input is a real valued signal thus the
        %accounting ocurring for the energy in the imaginary realm. also
        %note Amplitude^2 ~ Energy....short version(one sided PSD)                
        P=scaleFactor*(2*((real(S).^2)+(imag(S).^2)));
    elseif type==1
        %just to prove i do know HOW to do it...but ...identical
        %number of columns.aka.num of fft time bins...fix rounds to 0        
        numOfTimeBins=fix((L-Noverlap)/((length(win)-Noverlap)));
        %run a scrolling dft on the timeseries data that has been windowed.
        %move in (NFFT-Noverlap) chunks.doing a NFFT length fft.
        %index begins at 1..initialize a array to hold whats coming...    
        xdft=zeros((NFFT/2)+1,numOfTimeBins);
        for numTBins=1:numOfTimeBins
            b_elem=(NFFT-Noverlap)*(numTBins-1)+1;%beginning of chunk
            e_elem=b_elem+NFFT-1; %-1 
            if (e_elem>length(timeSeries))                    
                timechunk=timeSeries(b_elem:end);
                timechunk=padarray(timechunk,[((NFFT+1)-length(timechunk)) 0],0,'post');            
            else timechunk=timeSeries(b_elem:e_elem);
            end                  
            chunk=fft(timechunk.*win,NFFT);%dft
            xdft(:,numTBins)=chunk(1:NFFT/2+1);    
        end      
        %normalize . Note: the input is a real valued signal thus the
        %accounting ocurring for the energy in the imaginary realm. also
        %note Amplitude^2 ~ Energy....short version(one sided PSD)        
        P=scaleFactor*(2*((real(xdft).^2)+(imag(xdft).^2)));
        %alignment issues
        T=(dt_sgram*(0:(numOfTimeBins-1)))+dt_sgram_offset;
        F=df_sgram*(0:(NFFT/2))';        
        S=xdft;        
    else error('''%s'': the var ''type'' not define','dbr_PSD()');
    end        
    status=sprintf('\n {Fs=%.0f(Hz)  samplesOfSignal=%d  NFFT=%d  %%OverLap=%.0f  numOfTimeBins=%d}\n{dt-sgram-offset=%f(s)  dt-sgram=%f(s)  df-sgram=%f(Hz)}\n',Fs,L,NFFT,percentOL,numOfTimeBins,dt_sgram_offset,dt_sgram,df_sgram);    
    %P= power 
    %T= TimeBins
    %F= FreqBins
    %S= FFT
    %assignin('base','P',P);
    %error('hi');
    
end
%}
%{
%I HACKED THIS ...for the above function.....
function TEST_calibXferFx
    %note: original units in the documentation of the harp tf files are dB re uPa(rms)^2/counts^2.
    %so --> (timeseries_in_counts)*(10^(value/20))= X uPascals
    dbr_MakeBackups();
    basepath='Z:';
    harp_tf_calfile={...
    fullfile(basepath,'lmr-harp','CALIBRATION_FILES','HARP_TF_FILES','HARP_TF_FILES','SOCAL','SOCAL40H','591_100331','591_100331_invSensit.tf'),...
    fullfile(basepath,'lmr-harp','CALIBRATION_FILES','HARP_TF_FILES','HARP_TF_FILES','SOCAL','SOCAL40M','588_091116','588_091116_invSensit.tf'),...
    fullfile(basepath,'lmr-harp','CALIBRATION_FILES','HARP_TF_FILES','HARP_TF_FILES','SOCAL','SOCAL40N','584_091110','584_091110_invSensit.tf'),...
    fullfile(basepath,'lmr-harp','CALIBRATION_FILES','HARP_TF_FILES','HARP_TF_FILES','SOCAL','SOCAL38H','584_091110','584_091110_invSensit.tf'),...
    fullfile(basepath,'lmr-harp','CALIBRATION_FILES','HARP_TF_FILES','HARP_TF_FILES','SOCAL','SOCAL38M','596_100107','596_100107_invSensit.tf'),...
    fullfile(basepath,'lmr-harp','CALIBRATION_FILES','HARP_TF_FILES','HARP_TF_FILES','SOCAL','SOCAL38N','566_090901','566_090901_invSensit.tf')...
    };%harp_tf_calfile'

    figure(1);clf;
    all_caldata=[];
    all_caldata_interp=[];
    for i=1:length(harp_tf_calfile)
        tf_calData=load(char(harp_tf_calfile(i)));%first col=freq,secondcol=dBre upa/counts
        %need to define the region before the first sample
        % we need to taper it down.if its abrupt, then filter..which we do
        % elsewhere in the monte carlo sim...so
        tf_calData_interp_dB = interp1(tf_calData(:,1),tf_calData(:,2),0:0.1:5000);%interpolated so df's are equally spaced at 0.1hz like sig+cram
        tf_calData_interp_dB(isnan(tf_calData_interp_dB)) = 0 ;%need to deal with tapering..or...if your filtering later...at undesired freq...
        tf_scale_linear=complex(10.^(tf_calData_interp_dB/20)',0);%make linear %all real components, assuming phase 0    
        %assignin('base',sprintf('tf_scale_linear_%d',i),tf_scale_linear); 
        all_caldata(:,:,i)=tf_calData;
        all_caldata_interp(:,:,i)=tf_scale_linear;
        %plot(tf_calData(:,1),tf_calData(:,2));
    end
    assignin('base','all_caldata',all_caldata);
    assignin('base','all_caldata_interp',all_caldata_interp);
    b=1:length(harp_tf_calfile);
    plot(squeeze(all_caldata(:,1,b)),squeeze(all_caldata(:,2,b)),'-',0:0.1:5000,20*log10(squeeze(all_caldata_interp(:,1,b))),'--.');
    axis([30 100 70 73]);
    xlabel('Frequency(Hz)');ylabel('dB re 1 uPa^2/Counts^2');
    title('quick dB check of invSensit.tf file');
    legend('show');legend('40H','40M','40N','38H','38M','38N');
    print('-djpeg','CalibrationTransferFunctionInterpolation_all.jpg');

    figure(2);clf;
    plot(0:0.1:5000,20*log10(mean(squeeze(all_caldata_interp),2)),'-x');
    axis([30 100 70 73]);
    xlabel('Frequency(Hz)');ylabel('dB re 1 uPa^2/Counts^2');
    title('quick dB check of invSensit.tf file');
    legend('show');legend('avg of 40H 40M 40N 38H 38M 38N');
    print('-djpeg','CalibrationTransferFunctionInterpolation_avg.jpg');
end
%}
%need this for testing...this is how i was grabbing my time series for testing%
%{
function [ds_noise_chunk,conti_wave]= dbr_GetSamples(HARP_FOLDER,FilterOrder,numberOfRandomNoiseChunks,sizeOfNoiseChunkInSecs,Fs_O,Fs_R,bitsPerSample,NFFT_INV,tf_scale_linear,minSNRFreq,maxSNRFreq,NFFT_GPL)
    %% Grab a "noise" sample randomly from the data set.
    %to do this we will create a random number generator that
    %randomly selects one of the X number of files within a
    %deployment.  Then within that file we will randomly grab a
    %chunk of time...our goal is to grab a 75 second chunk. However
    % we need to lpf and desample that data since the gpl wants 2k
    % and the data is 10k...so we will lose data at the endpoints
    % equal to the length of the filter we are using..described by
    % me elsewhere.
    %ds_NFFT=NFFT_INV*(Fs_R/Fs_O);
    
    %within the function 2 variables can be toggled
    % (1=makerandom,2=calibratetimeseries)
    % make random allows for enable/disable random data(on by default)
    % calibrate applies xferFunction in the freqDomain(on by default)

    %% Make a recursivedirectory listing of all files within defined folder
    % presently only allowing one recursive level search beyond start
    %HARP_FOLDER=fullfile(basepath,'lmr-harp','SOCALH','40H','SOCAL40H_disk01_df20',filesep);
    fprintf(' --grabRandomNoiseSamples():: base LMR folder=%s\n',HARP_FOLDER);
    harpfiles=[];
    [xp,xn,~]=fileparts(HARP_FOLDER);    
    harplisting=dir(fullfile(xp,xn));
    harplisting= harplisting(~cellfun(@isempty,{harplisting(:).date}));             
    j=0;
    for i=1:length(harplisting)        
        if (harplisting(i).isdir==0)
            j=j+1;            
            harpfiles{j}=fullfile(HARP_FOLDER,xn,harplisting(i).name);
        else  % allow one folder level descent to search                    
            if ~strcmp(harplisting(i).name,'.') && ~strcmp(harplisting(i).name,'..')                
                harplisting2=dir(fullfile(HARP_FOLDER,harplisting(i).name));                        
                harplisting2=harplisting2(~cellfun(@isempty,{harplisting2(:).date}));
                for k=1:length(harplisting2)
                    if(harplisting2(k).isdir==0)
                        j=j+1;
                        harpfiles{j}=fullfile(HARP_FOLDER,harplisting(i).name,harplisting2(k).name);
                    end
                end                
            end            
        end
    end % harpfiles=harpfiles';
    %harpfiles'
    % Redefine what we are after by just locating the .wav files
    wavfiles=harpfiles(~cellfun(@isempty,strfind(harpfiles','.wav')));
    %wavfiles'

    %% Start building the grab bag
    %numberOfRandomNoiseChunks=300;
    %sizeOfNoiseChunkInSecs=75;            
    % create a struct to hold X number of random noise chunks with
    %{
    random filename, 
    randomstart/stop locations of the original noise time seris
    lpf'ed+downsampled time series for no
    calibration flag
    signal level of noise in dB =sig to noise
    %}
    % for 300 files...downsamples to 2khz...we are talking 360MByte
    ds_noise_chunk=repmat(struct('filename','','calibrated',0,'startSamplenum',0,'endSamplenum',0,'ds_ts',zeros(Fs_R*(sizeOfNoiseChunkInSecs),1),'subSigLeveldB',0,'allSigLeveldB',0),1,numberOfRandomNoiseChunks);                                        
    
    %preallocate memory for downsamples noise chunks            
    lastPercentDone=0;
    printPercentDone=0;
    
    for i=1:numberOfRandomNoiseChunks
        % Grab a random 75 second chunk somwhere in time.
        %stupid CR in matlab command window on windows...adds lf
        
        percentDone=int32(100*(i/numberOfRandomNoiseChunks));
        if percentDone~=lastPercentDone; printPercentDone=1;
        else printPercentDone=0;
        end               
        if printPercentDone; nchar=fprintf(' --grabRandomNoiseSamples():: %%Completed=%.0f',percentDone);                                   
        end 
        

        % Need to lpf and desample a random 75 sec chunk(but we
        % need a bit more on either side (filterorderlength) to
        % get the 75 we are after...without endpoint effects.
        conti_size=sizeOfNoiseChunkInSecs*Fs_O+FilterOrder*2;%75 sec + 
MAKE_RANDOM=1;%1=default=random....or 0=deteriministic spot
        if MAKE_RANDOM            
            random_file=char(wavfiles(randi(length(wavfiles))));%dereference the cell!
            wav_info=audioinfo(random_file);
            minSampleNum=1+FilterOrder;%force the random generator to not give us a starting value such that we cannot get a 75 second chunk
            maxSampleNum=wav_info.TotalSamples-conti_size;                                        
            randomStartingSample=randi([minSampleNum,maxSampleNum]);                            
        else
            fileindex=1;%anywhere between 1 and length(wavfiles)
            random_file=char(wavfiles(fileindex));%dereference the cell!
            wav_info=audioinfo(random_file);
            minSampleNum=1+FilterOrder;%force the random generator to not give us a starting value such that we cannot get a 75 second chunk
            maxSampleNum=wav_info.TotalSamples-FilterOrder-1;
            randomStartingSample= 10000;%anywhere between minsample and max   
        end
        if bitsPerSample~=wav_info.BitsPerSample; error('dbr_GrabRadnomNoiseSamples:BitsPerSample do not agree');end;
         % read in a chunk that containes the length we want plus.. 
        [conti_wave,Fs_Orig]=audioread(random_file,[randomStartingSample randomStartingSample+conti_size-1]);                
        

        % Begin filling in the return structure
        ds_noise_chunk(i).filename=random_file;%what we store here...needs to be accounted for on either linux/windows later!
        ds_noise_chunk(i).calibrated=0;%CALIBRATE_NOISE;
        ds_noise_chunk(i).startSamplenum=1+randomStartingSample+FilterOrder;
        ds_noise_chunk(i).endSamplenum=1+randomStartingSample+conti_size-FilterOrder;

        if printPercentDone; fprintf(repmat('\b',1,nchar));%a delay must be present to see the intermediary results(assuming that happens above)
        end
        lastPercentDone=percentDone;
    end
    nchar=fprintf(' --grabRandomNoiseSamples():: %%Completed=%.0f\n',100*(i/numberOfRandomNoiseChunks));                                       
end
%}
