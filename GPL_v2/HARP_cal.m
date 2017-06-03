%code snippets
        %% CONSTANTS
        SL_dB=160;%186;%rms source level%et al Catherine Berchok paper  St Lawrence blue whale sounds
        Fs_O=10000;%Sampling Frequency Original TimeSeriess
        Fs_R=2000;%Sampling Frequency Resampled                             
        FREQ_RANGE=[10 100];%could load this dynamically from cram                        
        FilterOrder=170;%divisible by Fs_Orig/Fs_new and even
        NFFT_INV=100000;%X point fft for inverted fft and fft 
        NFFT_GPL=2048;%ds_NFFT=NFFT_INV*(Fs_R/Fs_O);
        SG_POL=90;%spectrogram overlap %                        
        minSNRFreq=35;%used when calculating snr df*sum(sigonly(35:90hz))..etc
        maxSNRFreq=90;
        SIG_CALL_INSERT_TIME=30;%in seconds(this is picking the point in a 75 sec chunk window of noise at which to add signal)
        BITS_PER_SAMPLE=16;%16;        
        numberOfRandomNoiseChunks=200;
        sizeOfNoiseChunkInSecs=75;  
%-----------------------------------------------------------------------------------------------------------%        
%this is the calibration transfer function
%-----------------------------------------------------------------------------------------------------------%        
        %% Calculate the frequency domain calibration transfer function             
        %harp_tf_calfile=fullfile(basepath,'lmr-harp','CALIBRATION_FILES','HARP_TF_FILES','HARP_TF_FILES','SOCAL','SOCAL40H','591_100331','591_100331_invSensit.tf');
        harp_tf_calfile={...
        fullfile(basepath,'lmr-harp','CALIBRATION_FILES','HARP_TF_FILES','HARP_TF_FILES','SOCAL','SOCAL40H','591_100331','591_100331_invSensit.tf'),...
        fullfile(basepath,'lmr-harp','CALIBRATION_FILES','HARP_TF_FILES','HARP_TF_FILES','SOCAL','SOCAL40M','588_091116','588_091116_invSensit.tf'),...
        fullfile(basepath,'lmr-harp','CALIBRATION_FILES','HARP_TF_FILES','HARP_TF_FILES','SOCAL','SOCAL40N','584_091110','584_091110_invSensit.tf'),...
        fullfile(basepath,'lmr-harp','CALIBRATION_FILES','HARP_TF_FILES','HARP_TF_FILES','SOCAL','SOCAL38H','584_091110','584_091110_invSensit.tf'),...
        fullfile(basepath,'lmr-harp','CALIBRATION_FILES','HARP_TF_FILES','HARP_TF_FILES','SOCAL','SOCAL38M','596_100107','596_100107_invSensit.tf'),...
        fullfile(basepath,'lmr-harp','CALIBRATION_FILES','HARP_TF_FILES','HARP_TF_FILES','SOCAL','SOCAL38N','566_090901','566_090901_invSensit.tf')...
        };%harp_tf_calfile'    
        all_caldata_interp=[];
        for i=1:length(harp_tf_calfile)
            tf_calData=load(char(harp_tf_calfile(i)));%first col=freq,secondcol=dBre upa/counts
            tf_calData_interp_dB = interp1(tf_calData(:,1),tf_calData(:,2),0:0.1:5000);%interpolated so df's are equally spaced at 0.1hz like sig+cram
            tf_calData_interp_dB(isnan(tf_calData_interp_dB)) = 0 ;%need to deal with tapering..or...if your filtering later...at undesired freq...
            tf_scale_linear=complex(10.^(tf_calData_interp_dB/20)',0);%make linear %all real components, assuming phase 0            
            all_caldata_interp(:,:,i)=tf_scale_linear;
        end      
        if siteNumber==40
            switch siteLetter
                case 'H';tf_scale_linear=all_caldata_interp(:,:,1);%fprintf('40H\n');
                case 'M';tf_scale_linear=all_caldata_interp(:,:,2);%fprintf('40M\n');
                case 'N';tf_scale_linear=all_caldata_interp(:,:,3);%fprintf('40N\n');
                otherwise;tf_scale_linear=mean(squeeze(all_caldata_interp),2);%fprintf('avg\n');
            end
        elseif siteNumber==38
            switch siteLetter
                case 'H';tf_scale_linear=all_caldata_interp(:,:,4);%fprintf('38H\n');
                case 'M';tf_scale_linear=all_caldata_interp(:,:,5);%fprintf('38M\n');
                case 'N';tf_scale_linear=all_caldata_interp(:,:,6);%fprintf('38N\n');
                otherwise;tf_scale_linear=mean(squeeze(all_caldata_interp),2);%fprintf('avg\n');
            end
        else
            tf_scale_linear=mean(squeeze(all_caldata_interp),2);%fprintf('avg\n');
        end
        
        
%-----------------------------------------------------------------------------------------------------------%        
%here we load the timeseries
%transform into the freq domain.
%scale the timeseries into a applicable source level
%apply the harp cal transform....
%and then revert back into the time series..../
%again...this is all out of context...as i just snipped and pasted.
%-----------------------------------------------------------------------------------------------------------%        

            %% Load in the current whale call, then pad to 10 seconds
            padTime=tic;
            eval(sprintf('ts=%s;',char(tsStr)));% df=0.1hZ,Fs=10000...soFFTL=Fs/df=100000 dT=10seconds                
            ts=padarray(ts,[100000-length(ts) 0],0,'post');%want 10 seconds,0.1Hz    
            fprintf(' -MonteCarlo()::{%8.1f  %8.1f}     Padding Elapsed Time\n',toc(padTime),toc(MonteCarloStartTime));
            
            %% Convert time seriesinto counts/calibrate time series            
            % Adjust Source Level to rms values            
            %{
             %%%tsCounts=ts*floor((2^BITS_PER_SAMPLE)/2);% 16 bit should be 32767->-32768            
             %%%SL_rms=(10^(SL_rms/20))*(time_series/rms_avg(time_series))
             %%%SL_peak=(10^(SL_peak/20))*(time_series/max_value(time_series))            
            The acoustic calls of blue whales off California with gender
            data. Mark McDonald, John Calambokidis, Arthur Teranishi,and
            John Hildebrand...Average Call Source Level was 186 dB re:
            1uPa@1m....
            scratch that
            --->switched to catherine berchok's paper of 160dbrms            
            note:
            we have a representative arbirtraily scaled example call.
            we need to apply the transfer function first before we
            amplify to achieve our desired rms Source Level
            the counts are irrelevant prior to calibration           
            now apply the transfer function in the F domain.
            convert into the freq domain            
            %}
            
            %[Sn,~,~,~,~,~,~,~]=dbr_PSD(NFFT_INV,ts,Fs_O,0,'boxcar');             
            Sn=fft(ts,NFFT_INV);
            Sn=Sn(1:(NFFT_INV/2)+1);
                        
            %convolve the tfscalar about the timeseries...in freq Domain
            ts_cal=ifft(Sn.*tf_scale_linear,NFFT_INV,'symmetric');
            ts_rmsVal=rms(ts_cal);
            ts_cal_SL=(10^(SL_dB/20))*(ts_cal/ts_rmsVal);

            %% Transform Time Series into FreqDomain...FFT + PSD if desired     
            fftTime=tic;            
            Sx=fft(ts_cal_SL,NFFT_INV);%[Sx,~,~,~,~,~,~,~]=dbr_PSD (NFFT_INV,ts_cal_SL,Fs_O,0,'boxcar');%Sx->fft(timeseries)..unscaled
            Sx=Sx(1:(NFFT_INV/2)+1);
            fprintf(' -MonteCarlo()::{%8.1f  %8.1f}     FFT Elapsed Time\n',toc(fftTime),toc(MonteCarloStartTime));            
 