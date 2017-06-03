function [GPL_struct] = GPL_filter(GPL_struct,sp,sp_whiten,start,finish,parm);



for(k=1:length(GPL_struct))
        % access & reconstruct cm/cm_max matrices as needed 
GPL_struct(k).filter=0;

   if(isfield(parm.filter_parm,'cm_max_duration'))
   if(isfield(parm.filter_parm,'cm_max_bandwidth'))
   if(isfield(parm.filter_parm,'slope_lower'))
   if(isfield(parm.filter_parm,'slope_upper'))
           
       if(GPL_struct(k).cm_max_duration_bin >= parm.filter_parm.cm_max_duration && GPL_struct(k).cm_max_bandwidth_bin >= parm.filter_parm.cm_max_bandwidth...
               && GPL_struct(k).slope > -1.5 && GPL_struct(k).slope < -0.06)
          
       GPL_struct(k).filter=1;
       end

   end
   end
   end
   end
   
   
   
   if(isfield(parm.filter_parm,'cm_max2_duration'))
   if(isfield(parm.filter_parm,'cm_max2_bandwidth'))
   if(isfield(parm.filter_parm,'slope_lower'))
   if(isfield(parm.filter_parm,'slope_upper'))
       
       if(GPL_struct(k).cm_max2_duration_bin > parm.filter_parm.cm_max2_duration && GPL_struct(k).cm_max2_bandwidth_bin > parm.filter_parm.cm_max2_bandwidth...
               && GPL_struct(k).slope > -1.5 && GPL_struct(k).slope < -0.06)
          
       GPL_struct(k).filter=1;
       end

   end
   end    
   end
   end
    
   end
   end    
    
    
   
   
   


