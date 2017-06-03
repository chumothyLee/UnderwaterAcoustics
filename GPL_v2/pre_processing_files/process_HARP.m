
%load blue_whale_D_parm
%load parm_gray
%load regina_parm
%parm.plot=0;
%load TF

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




for(q=1:length(files))
  
 if(length(files(q).name) > 4 )
 if( files(q).name(end-5:end)=='.x.wav')
     
   % siz=wavread(files(q).name,'size');
   % siz=siz(1);
    
    big_wave= wavread(files(q).name);
   
scale_factor=1;
    
temp_name=files(q).name;
PARAMS=getxwavheaders(file_dir,temp_name); 


  
for(j=1:length(big_wave)/parm.nrec/scale_factor)


sub_data=big_wave(1+(j-1)*parm.nrec*scale_factor:((j-1)*parm.nrec*scale_factor)+parm.nrec*scale_factor);
%sub_data=resample(sub_data,P,Q);   $Normally dont use this, even for
%calibration


        datestr(PARAMS.ltsahd.dnumStart(j))
        julian_date=PARAMS.ltsahd.dnumStart(j);

      %  sub_data=calibrate_harp(sub_data,TF);  % Comment this out if you don't want calibrated NL and RL measurements
    
        [GPL_struct]=GPL_v1(sub_data,parm);
  
       
        for(k=1:length(GPL_struct))
            
      GPL_struct(k).julian_start_time=julian_date+datenum(2000,0,0,0,0,GPL_struct(k).start_time/parm.sample_freq);
      GPL_struct(k).julian_end_time=julian_date+datenum(2000,0,0,0,0,GPL_struct(k).end_time/parm.sample_freq);

      GPL_struct(k).start_time=GPL_struct(k).start_time+((j-1)*parm.nrec);
      GPL_struct(k).end_time=GPL_struct(k).end_time+((j-1)*parm.nrec);

   
            
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



