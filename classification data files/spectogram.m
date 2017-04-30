function [GPL_struct,subdata,sublabels,subtimeinfo] = GPL_v2(data, parm, time)

%%%%%%% Take FFT
%fprintf("starting GPL_fft")

%%[sp] = GPL_fft(data,parm,time);
[sp] = GPL_fft(data,parm);
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


GPL_struct=[];
list = ['blank      ';'noise      ';'croak      ';'jet-ski    ';'click train';'pulse train';'buzz       ';'downsweep  ';'beat       '];  %call types
listofcalls = cellstr(list);

subplot(2,1,1);
%% spectogram plot
ns=[1:length(baseline0)]*parm.skip/parm.sample_freq;
fr=linspace(parm.freq_lo,parm.freq_hi,parm.bin_hi-parm.bin_lo+1);
imagesc(ns,fr,20*log10(abs(sp)),[-40,0]);
axis xy; title('Spectrogram');

subdata = [];
sublabels = [];
subtimeinfo = [];
xlabel(datestr(time));
shading interp;

%% first prompt to get into the current panel. press 'n'(or enter key) to skip or press 'y' to get in
prompt0 = 'Want to peep into this slot?[y/n]: ';
str0 = input(prompt0,'s');
if(strcmp(str0,'y') || strcmp(str0,'Y'))
    A = flipud(mat2gray(abs(20*log10(abs(bas)))));
    %% second prompt ask to label the image shown as black and white spectogram. press 'y' to label or press 'n'(or enter key) to skip
    prompt1 = 'Want to label?[y/n]: ';
    for im = 1:7
        A1 = A(:,(im-1)*204+1:(im-1)*204+204);
        imwrite(A1,'im1.jpg');
        subplot(2,1,2);
        imshow(A1(:,:,[1 1 1]));
        str = input(prompt1,'s');
        if (strcmp(str,'y') || strcmp(str,'Y'))
            prompt2 = 'label: ';                   %% give enumerates call type number here to label
            templabel = input(prompt2);
            
            A1 = imread('im1.jpg');
            subdata = [subdata;reshape(A1,1,204*204)];
            sublabels = [sublabels;listofcalls(templabel)];
            start_t = time + datenum(0,0,0,0,0,(im-1)*10);
            end_t = start_t + datenum(0,0,0,0,0,10);
            str_time = strcat(datestr(time),' start_time:',datestr(start_t),' end_time:',datestr(end_t));
            subtimeinfo = [subtimeinfo;str_time];
        end
    end
end

drawnow;
pause;

end

