function [start,finish,times]=GPL_prune(mcalls,parm);

dt=parm.skip/parm.sample_freq;

% Merge adjacent calls within allowed gap size  

[k1,k2]=sort(mcalls(:,1));
start=mcalls(k2,1);finish=mcalls(k2,2);
k=find(start(2:end)-finish(1:end-1)<parm.overlap);
omit=length(k);
if omit>0
  n=1:length(start); 
  start=start(setdiff(n,k+1));
  finish=finish(setdiff(n,k));
end

% Prune short calls

cutoff_short=ceil(parm.min_call/dt)-2;
k=find(finish-start>cutoff_short);
start=start(k);finish=finish(k);

% Prune long calls 

cutoff_long=ceil(parm.max_call/dt)-2;
k=find(finish-start<cutoff_long);
start=start(k);finish=finish(k);

% if length(finish)>0
% pad=round(parm.fftl/parm.skip)-1;
% finish=finish+pad;
% if finish(end)>parm.nbin
%     finish(end)=parm.nbin;end;end


times=[(start-1)*parm.skip+1,(finish)*parm.skip];
