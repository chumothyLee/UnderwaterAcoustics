function sp_whiten = GPL_whiten(sp,parm);

[sp_whiten,dummy,mu]=whiten_matrix(sp,parm.white_x);
sp_whiten=abs((sp_whiten./(mu*ones(1,parm.nbin))).')';

% optional vertical whitening

if parm.whiten==2
[sp_whiten,dummy,mu]=whiten_matrix(sp_whiten');
sp_whiten=abs(sp_whiten'./(ones(parm.nfreq,1)*mu'));end

cross=ones(3,3);cross(2,2)=4;cross(1,3)=0;
cross(3,1)=0;cross(1,1)=0;cross(3,3)=0;cross=cross/8;
sp_whiten=conv2(sp_whiten,cross,'same');
