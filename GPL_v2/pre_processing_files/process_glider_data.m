load glider_parm

P=10000; 
Q=10000; % For Glider

rl_min = 2;

calls=[];

for(jj=1:length(files)-4)
    
    jj/length(files) * 100

data=audioread(files(jj+4).name);

%data=resample(data,P,Q);

scale_factor=1;  julian_date = datenum(2014,10,10,13,23,38);

scheck=length(data);
if(scheck < P*rl_min*60)
    data=[data;zeros((P*rl_min*60)-scheck,1)];
end



for(j=1:rl_min)
sub_data=data(1+(j-1)*parm.nrec:((j-1)*parm.nrec)+parm.nrec);


%Check for bad data
test=sort(abs(sub_data(1:100:end)));
data_check=std(test(1:500));


if(data_check > 0)

[GPL_struct]=GPL_v1(sub_data,parm);

       
        for(k=1:length(GPL_struct))
%       For localization testing
      GPL_struct(k).start_time=GPL_struct(k).start_time+((j-1)*parm.nrec);
      GPL_struct(k).end_time=GPL_struct(k).end_time+((j-1)*parm.nrec);
      
     running_start_time=GPL_struct(k).start_time+((jj-1)*parm.nrec*rl_min);
     running_end_time=GPL_struct(k).end_time+((jj-1)*parm.nrec*rl_min);
      

     GPL_struct(k).julian_start_time=julian_date+datenum(0,0,0,0,0,running_start_time*scale_factor/parm.sample_freq);
     GPL_struct(k).julian_end_time=julian_date+datenum(0,0,0,0,0,running_end_time*scale_factor/parm.sample_freq);
     
     GPL_struct(k).fname=files(jj+3).name;
       

      
        end
        


         calls=[calls,GPL_struct];
        
         else
    display('Corrupt data, skipping...');
end
end


end


hyd(1).detection.parm=parm;
hyd(1).detection.calls=calls;


% for(j=1:14)
%     hyd(j).detection.calls=master_detection_struct(j).detection_struct;
%     hyd(j).detection.parm=parm;
% end