warning off;

% dialogue to prompt user to select a .x.wav to process
choice = questdlg('Select a .x.wav file to process', 'Select Data', 'OK', 'Cancel','OK');

if strcmp(choice, 'Cancel')
   return
end

% get file and file path
[filename, pathname]= uigetfile('*.x.wav');
cwd=pwd;
cd(pathname)
file_dir=pwd;
addpath(pwd);
files=dir('*.x.wav');
cd(cwd);

for i = 1:length(files)
    if strcmp(files(i).name,filename)
        file_index = i;
        break;
    end
end

calls=[];
t_pad=parm.pad*parm.sample_freq;
t_actual=parm.nrec-2*t_pad;
data = [];
labels = [];
timeinfo = [];


filenum = 0;

% dialogue to prompt user to select a directory to put training data
choice = questdlg('Select a directory to store training data', 'Select Directory', 'OK', 'Cancel','OK');

if strcmp(choice, 'Cancel')
   return
end

% directory name to store training data
dirToStore = uigetdir;


for q=file_index
    %fprintf("for loop: %d\n", q)
    if(length(files(q).name) > 4 )
        %fprintf("length of files(q).name is > 4\n")
        if( strcmp(files(q).name(end-5:end),'.x.wav'))
            %fprintf("valid file\n")
            %siz=audioread(files(q).name);
            info = audioinfo(files(q).name);
            siz = [info.TotalSamples, info.NumChannels];
            
            %fprintf("finished with audioread\n")
            %fprintf("siz(1) = %d\n", siz(1))
            scale_factor=1;
            
            temp_name=files(q).name;
            PARAMS=getxwavheaders(file_dir,temp_name);
            julian_start_date=PARAMS.ltsahd.dnumStart(1);
            %fprintf("finished with getxwavheaders\n")
            time = julian_start_date + datenum(2000,0,0,0,0,0);
            %fprintf("t_actual: %d\n", t_actual)
            for(j=1:siz/t_actual/scale_factor)
                
                %fprintf("j: %d, num_iterations: %d\n", j, siz/t_actual);
                
                fprintf("j: %d\n", j);
                off=(j-1)*t_actual+t_pad;
                
                %datestr(julian_start_date+datenum(2000,0,0,0,0,(off+1-t_pad)/parm.sample_freq))
                datestr=0;
                if(off+1+t_pad+t_actual > siz)
                    endlimit = siz;
                else
                    endlimit = off+1+t_pad+t_actual;
                end
                
                sub_data=audioread(files(q).name,[off+1-t_pad,endlimit]);
                
                fprintf("calling spectogram\n");
                
                time_new = time + datenum(0,0,0,0,0,(j-1)*((parm.nrec/parm.sample_freq) - 2*parm.pad));
                [GPL_struct,subdata,sublabels,subtimeinfo]=spectogram(sub_data,parm,time_new);
                
                %start new code
                for i=1:length(sublabels)

                    %fprintf("sublabels(%d) = %s",i, string(sublabels(i)))
           
                    switch string(sublabels(i))
                        case "blank"
                            currLabel = 1
                        case "noise"
                            currLabel = 2
                        case "croak"
                            currLabel = 3
                        case "jet-ski"
                            currLabel = 4
                        case "click train"
                            currLabel = 5
                        case "pulse train"
                            currLabel = 6
                        case "buzz"
                            currLabel = 7
                        case "downsweep"
                            currLabel = 8
                        case "beat"
                            currLabel = 9
                        otherwise
                            fprintf("error: unexpected label")
                            continue
                            
                    end
                    
                    
                    fprintf("currLabel: %d\n", currLabel)
                    fprintf("fileNum: %d\n", filenum)
                    filename = fullfile(dirToStore, char("image_data" + currLabel + "_" + filenum + ".mat"));
                    fprintf("saving %s\n", filename)
                    
                    currData = subdata(i,1:end);
                    currLabel = sublabels(i);
                    currTimeInfo = subtimeinfo;
                    save(filename,'currData','currLabel','currTimeInfo');
                    
                    filenum = filenum + 1;
                    
                end
      
                %end new code
                calls=[calls,GPL_struct];
                %data = [data;subdata];
                %labels = [labels;sublabels];
                %timeinfo = [timeinfo;subtimeinfo];
                %fprintf("saving image_data2.mat")
                %save('image_data2.mat','data','labels','timeinfo');
                %j
              
            end
            
        end
        
    end
    
end






