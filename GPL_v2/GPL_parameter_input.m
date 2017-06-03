function [parm]=GPL_parameter_input; 

parm.sample_freq=input('sample frequency\n');
dp=input('# seconds for each record (e.g. 75)\n');
parm.nrec=dp*parm.sample_freq;
parm.xp1=input('exponent for u (normed over frequency)\n');
parm.xp2=input('exponent for y (normed over time)\n');
parm.freq_lo=input('lower frequency limit (Hz)\n');
parm.freq_hi=input('upper frequency limit (Hz)\n');
parm.sum_freq_lo=input('lower frequency limit for summation (Hz)\n');
parm.sum_freq_hi=input('upper frequency limit for summation (Hz)\n');

parm.whiten=input('1: whiten in time only   2: whiten in time and frequency\n');
parm.white_x=input('enhanced mean noise level?');

parm.min_call=input('min call length (in seconds)?\n');
parm.max_call=input('max call length (in seconds)?\n');

sample_freq=parm.sample_freq;
nrec=parm.nrec;
xp1=parm.xp1;
xp2=parm.xp2;
freq_lo=parm.freq_lo;
freq_hi=parm.freq_hi;
sum_freq_lo=parm.sum_freq_lo;
sum_freq_hi=parm.sum_freq_hi;
whiten=parm.whiten;

% choose fftl:

ideal=11+log2(sample_freq/10000);
quot=2.^(ideal-floor(ideal)+[0,1,2,3]);
res=ceil(quot)-quot;[k1,k2]=min(res);
quot=ceil(quot(k2));ideal=floor(ideal)-k2+1;

% default skip = fftl/4:

fftl=2^ideal*quot
fftl=input('fftl (above?) or your own \n');

skip=fftl/4
skip=input('skip (above?) or your own \n');

% determine the bins to keep:

freq=[0:fftl/2]/fftl*sample_freq;
[dummy,bin_lo]=min(abs(freq-freq_lo));
[dummy,bin_hi]=min(abs(freq-freq_hi));

[dummy,sum_bin_lo]=min(abs(freq-sum_freq_lo));
[dummy,sum_bin_hi]=min(abs(freq-sum_freq_hi));

% slate size that results:

J=floor((nrec-fftl)/skip)+1;

% Tack on the new entries to the parm structure array:
parm.loop = 5;
parm.merge =2;
parm.overlap=2;
parm.nbin=J;
parm.fftl=fftl;
parm.skip=skip;
parm.bin_lo=bin_lo;
parm.bin_hi=bin_hi;

parm.nfreq=bin_hi-bin_lo+1;
parm.sum_bin_lo=sum_bin_lo;
parm.sum_bin_hi=sum_bin_hi;
parm.noise_ceiling=input('noise ceiling \n');
parm.thresh=input('threshold \n');

%parm.iplt=input('0: plotting off  [1,2,3]: plotting on\n');
parm.template=input('0: template off  1: template on?\n');
if parm.template==1
parm.cut=input('template threshold?\n');
parm.waveform=0;
parm.cm_on=input('All countour on?\n');
parm.cm_max_on=input('Single contour on?\n');
parm.cm_max2_on=input('Second contour on?\n');


end

parm.measurements=input('0: measurements off  1: measurements on?\n');
if parm.measurements==1

parm.slope=1;
end

parm.filter=input('0: filter off  1: filter on?\n');
if parm.filter==1

end



