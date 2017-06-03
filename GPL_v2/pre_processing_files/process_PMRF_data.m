

P=10000; 
Q=96000; % For PMRF
%Q=95989;
%Q=46000; %For PRMF 46MB files

for(jj=1:5)

fid=fopen(files(jj+3).name);
data=fread(fid,'short');
fclose(fid);
data=resample(data,P,Q);

scale_factor=1; julian_date=0;

scheck=length(data);
if(scheck < P*10*60)
    data=[data;zeros((P*10*60)-scheck,1)];
end
calls=[];


for(j=1:10)
sub_data=data(1+(j-1)*parm.nrec:((j-1)*parm.nrec)+parm.nrec);

[GPL_struct]=GPL_v1(sub_data,parm);

       
        for(k=1:length(GPL_struct))
%       For localization testing
      GPL_struct(k).start_time=GPL_struct(k).start_time+((j-1)*parm.nrec);
      GPL_struct(k).end_time=GPL_struct(k).end_time+((j-1)*parm.nrec);

     GPL_struct(k).julian_start_time=julian_date+datenum(2000,0,0,0,0,GPL_struct(k).start_time*scale_factor/parm.sample_freq);
     GPL_struct(k).julian_end_time=julian_date+datenum(2000,0,0,0,0,GPL_struct(k).start_time*scale_factor/parm.sample_freq);
       

      
       end
        
     sprintf('hours processed'); j/75

         calls=[calls,GPL_struct];
end

hyd(jj+9).detection.parm=parm;
hyd(jj+9).detection.calls=calls;


end

% for(j=1:14)
%     hyd(j).detection.calls=master_detection_struct(j).detection_struct;
%     hyd(j).detection.parm=parm;
% end