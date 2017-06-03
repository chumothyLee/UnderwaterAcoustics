function [sp] = GPL_fft(data,parm);

dt=parm.skip/parm.sample_freq;
cutoff_short=ceil(parm.min_call/dt)-2;
cutoff_long=ceil(parm.max_call/dt)-2;
win=hamming(parm.fftl);
sp=zeros(parm.nfreq,parm.nbin);

x=data;[x1,x2]=size(x); 
if x2>x1
  x=x';end

for j=1:parm.nbin
start=(j-1)*parm.skip+1;
finish=start+parm.fftl-1;
q=fft(x(start:finish).*win);
sp(:,j)=abs(q(parm.bin_lo:parm.bin_hi));end
