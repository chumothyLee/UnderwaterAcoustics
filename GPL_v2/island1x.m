function [chain] = island1x(a,sz1,sz2)

aa=a;chain=[];
q=length(aa);

for q1=1:q

if isfinite(aa(q1))==1

kk=aa(q1);k=[];
[sk1,sk2]=size(kk);

% if sk1>sk2
%     kk=kk';end

for kl=1:99999
if length(kk) == 0
break
else 
k=[k,kk'];jj=[];   %STILL NEED TO FIX THIS FOR VERSION NUMBER


for i=1:length(kk)
ll=find(aa==kk(i));
aa(ll)=nan;
jj=[jj,[kk(i)+1,kk(i)-1,kk(i)+sz1,kk(i)-sz1]];
end
end
kk=jj;
kk=intersect(kk,aa);
end

chain=[chain,length(k),k];
end
end

