function [base_out,newpad]=GPL_cropping(base_in,noise_ceiling,thresh);   

iflag=0;newpad=[];base_out=base_in;
 while iflag==0
     [k1,k2]=max(base_out);
     if k1<thresh;
         iflag=1;
         return
     end
     js=find(base_out<noise_ceiling);
     
     j1=find(js<k2);
     if length(j1)==0;
         js1=1;
     else
         js1=js(j1(end)); end
     j2=find(js>k2);
     if length(j2)==0;
         js2=length(base_out);
     else
         js2=js(j2(1)); end
     
     newpad=[newpad',[js1,js2]']';
     base_out(js1:js2)=0;
 end
