function [cm,cm_max,cm_max2]=GPL_contour(bas0,cutoff);

[sz1,sz2]=size(bas0);
bas=zeros(sz1+2,sz2+2);
bas(2:end-1,2:end-1)=bas0;

score=0;cm=0*bas;cm_max=0*bas;cm_max2=0*bas; ks0=0;

[sz1,sz2]=size(bas);
basgot=reshape(bas,sz1*sz2,1);
[b1,mu]=whiten_vec(basgot);
qre=bas/mu-1;
if nargin==1
cutoff=10;end
a_min=10;
k=find(qre>cutoff);

if length(k)> a_min;

     msk0=zeros(sz1,sz2);
     msk0(k)=1;
     dm=msk0;
     
 dm=conv2(dm,ones(3,3)/9,'same');
 k=find(dm>2/9);dm(k)=1;
 k=find(dm<1);dm(k)=0;
 dm=dm+msk0;
 
 kk=find(dm);
 chain=island1x(kk,sz1,sz2);
 [area,t,col] = island21(bas,chain);
 
 
 
 
 if max(area)>a_min
 score=1; % at least one viable contour exists, proceed
   ks=find(area>0.05*max(area));

 msk=zeros(sz1,sz2);  [dummy,ks0]=sort(t);
     msk(chain(col(ks0(end))+1:col(ks0(end)+1)-1))=1;
     cm_max=msk.*bas;  % Single contour of biggest area in the slate
     
     if(length(ks0)>1)
      msk=zeros(sz1,sz2);
        msk(chain(col(ks0(end-1))+1:col(ks0(end-1)+1)-1))=1;
        cm_max2=msk.*bas;  % Single contour of biggest area in the slate
     end
 
     msk=zeros(sz1,sz2);
     for dummy=1:length(ks)
     msk(chain(col(ks(dummy))+1:col(ks(dummy)+1)-1))=1;end
     cm=msk.*bas;  
 end;end;


cm=cm(2:end-1,2:end-1);
cm_max=cm_max(2:end-1,2:end-1);

if(length(ks0)>1)
cm_max2=cm_max2(2:end-1,2:end-1);
end