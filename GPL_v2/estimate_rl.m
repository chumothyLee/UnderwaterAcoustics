function [spec_rl]=estimate_rl(cm,sp_orig);
 

[k1]=find(cm);
new_slate=zeros(size(cm));
new_slate(k1)=sp_orig(k1);
pad=conv2(new_slate,ones(3,3)/9,'same');
k1x=find(pad);
noise_slate=sp_orig;
noise_slate(k1x)=0;

[x1,y1]=find(noise_slate);
k0x=find(noise_slate);
z1=noise_slate(k0x);
[x2,y2]=find(cm);
z2=griddata(x1,y1,z1,x2,y2,'nearest');
new_slate(k1)=new_slate(k1)-z2;
k=find(new_slate<0);
new_slate(k)=0;

%noise_slate(k1)=z2;  %imagesc(log([noise_slate,new_slate]))

spec_rl= sqrt(mean(sum(new_slate.^2,1))); 