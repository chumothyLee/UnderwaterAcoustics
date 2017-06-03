GPL_V2

supporting sample files: data.mat, parm.mat

 [GPL_struct]=GPL_v2(data,parm);

returns a structure file with following entries:

1x6 struct array with fields:

    start_time
    end_time
    cm
    cm_max
    cm_max2

start_time is samples (not seconds) of onset of detection
start_time is samples (not seconds) of end of of detection

cm is the feature matrix of the detection
cm_max is the largest feature matrix of the detection
cm_max2 is the 2nd largest feature matrix of the detection

feature matrices are stored in a compressed format to save space for long deployments.  They are used later during cross-correlation for the localization process. 

To view the features, you can use the command:

figure; imagesc(GPL_full('cm',2,GPL_struct)); axis xy;

Plotting is turned on with a pause by default (for debugging and making sure the code works).  In practice this is turned off by setting:

 parm.plot=0;

