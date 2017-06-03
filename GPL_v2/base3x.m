function [ks]=base3x(baseline);

bs=sort(baseline)';
bs1=length(bs);
z=ones(bs1,1);
if mod(bs1,2)==1
 bs=bs(1:end-1);
 bs1=bs1-1;end
bs=reshape(bs,bs1/2,2);
[b1,b2]=min(diff(bs'));
low=bs(b2,1);high=bs(b2,2);
k1=find(baseline<low);z(k1)=0;
k2=find(baseline>high);z(k2)=0;
ks=find(z);

