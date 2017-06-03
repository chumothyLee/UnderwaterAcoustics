function [GPL_struct] = GPL_v2(data, parm); 

%%%%%%% Take FFT
[sp] = GPL_fft(data,parm);

%%%%%%% Whiten and smooth
sp_whiten = GPL_whiten(sp,parm);
sp_loop=sp_whiten;

%%%%%%% Extract and replicate quiet (non-signal) portion of data
[quiet_whiten, quiet_fft, quiet_base, noise_floor, blocked, baseline0] = GPL_quiet(sp,sp_whiten,parm);


%%%%%% Use GPL algorithm
 mcalls=[]; ic=0;lc=2;
low_off=parm.sum_bin_lo-parm.bin_lo+1;
high_off=parm.sum_bin_hi-parm.bin_lo+1;
dt=parm.skip/parm.sample_freq;

%%%%%% Loop, find units above threshhold
   while ic<parm.loop && lc >1
       
   norm_v=sp_loop./(ones(parm.nfreq,1)*sum(sp_loop.^2).^(1/2));
   norm_h=sp_loop./(sum(sp_loop'.^2).^(1/2)'*ones(1,parm.nbin));

   % next step was not a part of GPL in Helble et al. 
   norm_v=whiten_matrix(norm_v')';norm_h=whiten_matrix(norm_h);

   bas=abs(norm_v).^parm.xp1.*abs(norm_h).^parm.xp2;
   
  
   base_in=sum(bas(low_off:high_off,:).^2);
   [b0]=whiten_vec(base_in');
   % ALWAYS use initial [quiet_base, noise_floor]
   base_in=b0'/quiet_base;

   [base_out,calls]=GPL_cropping(base_in,parm.noise_ceiling*noise_floor,...
                             parm.thresh*noise_floor);   
 
   [lc,dummy]=size(calls);
   unblocked=zeros(parm.nbin,1);
   for j=1:lc
       unblocked(calls(j,1):calls(j,2))=1;end

    % disallow any detections from before
    tst=unblocked - blocked;
    k=find(tst<1);tst(k)=0;
    
    st=find(diff(tst)>0)+1;
    if tst(1)==1
        st=[1,st']';end
    fn=find(diff(tst)<0);
    if tst(end)==1
        fn=[fn',parm.nbin]';end
    calls=[st,fn];

    % merge  
    [k1,k2]=sort(calls(:,1));
    st=calls(k2,1);fn=calls(k2,2);
    k=find(st(2:end)-fn(1:end-1)<parm.overlap);
    omit=length(k);
    if omit>0
     n=1:length(st); 
     st=st(setdiff(n,k+1));
     fn=fn(setdiff(n,k));
    end

    calls=[st,fn];
    % kill zero length
    dur=diff(calls');k=find(dur);
    calls=calls(k,:);
    
    mcalls=[mcalls',calls']';
     ic=ic+1;
     [lc,dummy]=size(calls); % corrected for # actually added
   
    % now block everything just found
    blocked=blocked+unblocked;
    k=find(blocked>1);blocked(k)=1;

    ksel=find(base_out==0);
    sp_loop(:,ksel)=quiet_whiten(:,ksel);

   end % finished unit selection

   
%%%%%%% Prune

   [start,finish,times]=GPL_prune(mcalls,parm);
   

GPL_struct=[];

 siz=size(times);
 if siz(1) > 0
     
    %%% Code added to detect calls that cross slate boundaries
    t_pad=parm.pad*parm.sample_freq;
    k1=find(times(:,1)>t_pad);            % only calls that BEGIN after left padding
    k2=find(times(:,1)<=parm.nrec-t_pad);  %     ...            before  right padding
    k1=intersect(k1,k2);
    times=times(k1,:);
    start=start(k1,:);
    finish=finish(k1,:);
 end
 
siz=size(times);
if (siz(1) > 0)     


        
   for k=1:siz(1);
       GPL_struct(k).start_time=times(k,1);
       GPL_struct(k).end_time=times(k,2);end
  
   

     
%%%%%% Diagnostics

if parm.template==1
 [GPL_struct] = GPL_template(GPL_struct,sp,sp_whiten,start,finish,data,parm);end



if parm.measurements==1
 [GPL_struct] = GPL_measurements(GPL_struct,sp,sp_whiten,quiet_fft,start,finish,parm);end





%%%%%% Filter

if parm.filter==1
 [GPL_struct] = GPL_filter(GPL_struct,sp,sp_whiten,start,finish,parm);end

end

if parm.plot==1
    ks=find(baseline0<=parm.noise_ceiling);  
    ns=[1:length(baseline0)]*parm.skip/parm.sample_freq;

    figure(7);
    subplot(3,1,1)
    fr=linspace(parm.freq_lo,parm.freq_hi,parm.bin_hi-parm.bin_lo+1);
    imagesc(ns,fr,20*log10(abs(sp_whiten)/max(max(sp_whiten))),[-40,0]); 
    axis xy; title('Whitened Spectrogram');

    subplot(3,1,2)
    plot(ns,log10(abs(baseline0)),'k');hold on
    hold on
    for j=1:length(start)
    plot(ns(start(j):finish(j)),log10(abs(baseline0(start(j):finish(j)))),'r');
    end
    l1=log10(parm.noise_ceiling*noise_floor);
    l2=log10(parm.thresh*noise_floor);
    plot(ns,l1+0*ns,'k--');
    plot(ns,l2+0*ns,'g--');
    axis tight
    hold off
    
    subplot(3,1,3)
    fr=linspace(parm.freq_lo,parm.freq_hi,parm.bin_hi-parm.bin_lo+1);
    imagesc(ns,fr,20*log10(abs(sp_loop)/max(max(sp_whiten))),[-40,0]); 
    axis xy; title('Whitened Spectrogram');
    
    drawnow;
    pause;
end


end

