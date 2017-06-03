function [area,t,col] = island21(q,qc)

     area(1)=qc(1);loc=1;
     la=length(qc);
     
     for i=2:99999
      loc=loc+area(i-1)+1;
       if loc == la+1
         break; end
      area(i)=qc(loc);
     end

     col(1)=1;
     for i=1:length(area)
     col(i+1)=col(i)+area(i)+1;  end

     for i=1:length(area)
     t(i)=sum(q(qc(col(i)+1:col(i+1)-1))); end

