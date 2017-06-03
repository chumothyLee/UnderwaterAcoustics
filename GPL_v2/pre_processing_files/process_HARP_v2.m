
%load blue_whale_D_parm
%load parm_gray
%load regina_parm
%parm.plot=0;
%load TF
warning off;

sprintf('Select folder containing .x.wav to process ');
    [filename, pathname]= uigetfile('*.x.wav');
    cwd=pwd;
    cd(pathname)
    file_dir=pwd;
    addpath(pwd);
    files=dir('*.x.wav');
    cd(cwd);


detection_name=(strcat('detections_GPL_v1_',num2str(parm.freq_lo),'_',num2str(parm.freq_hi),'_'));
calls=[];


t_pad=parm.pad*parm.sample_freq;
t_actual=parm.nrec-2*t_pad;

for(q=1:length(files))
  
 if(length(files(q).name) > 4 )
 if( files(q).name(end-5:end)=='.x.wav')
     
    siz=wavread(files(q).name,'size');
    siz=siz(1);
    
    %big_wave= wavread(files(q).name);
 %big_wave=[zeros(parm.pad*parm.sample_freq,1);big_wave;zeros(parm.pad*parm.sample_freq,1)]; %padded so GPL_v2 can use overlap
   
scale_factor=1;
    
temp_name=files(q).name;
PARAMS=getxwavheaders(file_dir,temp_name); 
julian_start_date=PARAMS.ltsahd.dnumStart(1);

  
for(j=1:siz/t_actual/scale_factor)
    

    off=(j-1)*t_actual+t_pad;
    
   %datestr(julian_start_date+datenum(2000,0,0,0,0,(off+1-t_pad)/parm.sample_freq))
   datestr=0;
   sub_data=wavread(files(q).name,[off+1-t_pad,off+1+t_pad+t_actual]);

%sub_data=big_wave(1+(j-1)*parm.nrec*scale_factor:((j-1)*parm.nrec*scale_factor)+parm.nrec*scale_factor+(2*parm.pad*parm.sample_freq));
%sub_data=resample(sub_data,P,Q);   $Normally dont use this, even for
%calibration


%        datestr(PARAMS.ltsahd.dnumStart(j))
%         julian_date=PARAMS.ltsahd.dnumStart(j);

      %  sub_data=calibrate_harp(sub_data,TF);  % Comment this out if you don't want calibrated NL and RL measurements
    
        [GPL_struct]=GPL_v2(sub_data,parm);
        
        GPL_struct
       
        for(k=1:length(GPL_struct))
            
%       GPL_struct(k).julian_start_time=julian_date+datenum(2000,0,0,0,0,GPL_struct(k).start_time/parm.sample_freq);
%       GPL_struct(k).julian_end_time=julian_date+datenum(2000,0,0,0,0,GPL_struct(k).end_time/parm.sample_freq);

      GPL_struct(k).start_time=GPL_struct(k).start_time+((j-1)*t_actual);
      GPL_struct(k).end_time=GPL_struct(k).end_time+((j-1)*t_actual);
      
      GPL_struct(k).julian_start_time=julian_start_date+datenum(2000,0,0,0,0,GPL_struct(k).start_time/parm.sample_freq);
      GPL_struct(k).julian_end_time=julian_start_date+datenum(2000,0,0,0,0,GPL_struct(k).end_time/parm.sample_freq);

   
            
     GPL_struct(k).fname=temp_name;
       end


         calls=[calls,GPL_struct];
        
end

 end
end

end

 hyd(1).detection.calls=calls;
hyd(1).detection.parm=parm;

 save(strcat(detection_name,files(1).name(1:end-6),'.mat'),'hyd')



