function [GPL_struct] = GPL_measurements(GPL_struct,sp,sp_whiten,quiet_fft, start,finish,parm);

 quiet_fft=2*quiet_fft.^2;
 quiet_fft=sum(quiet_fft,1);
 quiet_fft=sqrt(mean(quiet_fft));

for k=1:length(start)
    
    % access & reconstruct cm/cm_max matrices as needed 
    
      if(isfield(GPL_struct,'cm')); cm = GPL_full('cm',k,GPL_struct); end
      if(isfield(GPL_struct,'cm_max')); cm_max =  GPL_full('cm_max',k,GPL_struct); end
      if(isfield(GPL_struct,'cm_max2')); cm_max2 = GPL_full('cm_max2',k,GPL_struct); end
      



if(parm.measure.slope == 1 || parm.measure.cm_max_duration ==1)
nonz=find(sum(cm_max));
kk=length(nonz);

GPL_struct(k).cm_max_duration_time = kk * (parm.skip/parm.sample_freq);
GPL_struct(k).cm_max_duration_bin = kk ;
end

if(parm.measure.slope == 1 || parm.measure.cm_max2_duration ==1)
nonz=find(sum(cm_max2));
kk=length(nonz);
GPL_struct(k).cm_max2_duration_time = kk * (parm.skip/parm.sample_freq);
GPL_struct(k).cm_max2_duration_bin = kk ;
end

if(parm.measure.slope==1)
GPL_struct(k).slope_ci=nan;
GPL_struct(k).slope=nan;

nonz=find(sum(cm_max));
kk=length(nonz);

      if kk>2
      
      freq=[0:parm.fftl/2]/parm.fftl*parm.sample_freq;
      freq=freq(parm.bin_lo:parm.bin_hi)';
               
       wt=sum(cm_max');  kf=find(wt);
       kf=kf([1,end]);freq_range=freq(kf);
       
        wt=sum(cm_max');fnd=(wt*freq)/sum(wt);
        [ys,xs,ws]=find(cm_max);
    
        [fitresult, gof] = weighted_slope(xs, ys, ws.^2);
        ci = confint(fitresult,0.95);
        confidence = abs(ci(1)-ci(2));
      
        GPL_struct(k).slope_ci=confidence;
        GPL_struct(k).slope = fitresult.p1;
        
        
      end
end
      
if(parm.measure.cm_max_bandwidth == 1)
  %%% Record the number of frequency bins in contour    
  jj=length(find(sum(cm_max')));
  GPL_struct(k).cm_max_bandwidth_freq = jj*(parm.sample_freq/parm.fftl);
 GPL_struct(k).cm_max_bandwidth_bin = jj;
end
  
if(parm.measure.cm_max2_bandwidth == 1)
  jj=length(find(sum(cm_max2')));
  GPL_struct(k).cm_max2_bandwidth_freq = jj*(parm.sample_freq/parm.fftl);
 GPL_struct(k).cm_max2_bandwidth_bin = jj;
end
  


if(parm.measure.spec_noise==1)
    
 GPL_struct(k).spec_noise = quiet_fft;
end

if(parm.measure.spec_rl==1)
    
if length(find(cm)) > 5
    
sp_subset=sp(:,start(k):finish(k));
    
[spec_rl]=estimate_rl(cm,sp_subset);
else
    spec_rl=nan;
end


GPL_struct(k).spec_rl = spec_rl;
end

     
end

%GPL_struct=rmfield(GPL_struct,'cm');




