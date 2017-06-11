
%% dialogue to prompt user to select a directory to put training data
choice = questdlg('Select a file containing intervals to label', 'Select file', 'OK', 'Cancel','OK');

if strcmp(choice, 'Cancel')
    return
end

%% directory name to store training data
txt_file = uigetfile;

%%read in the file
intervals = load(txt_file);
%intervals = load("../test/test_intervals.txt");
start_times = intervals(:,round(1));
end_times = intervals(:,round(2));
%start_times = [10, 38000];
%end_times = [90, 38130];
[pathstr,name,ext] = fileparts(txt_file)
filename = fullfile(pathstr, name, '.x.wav');
%%%%%%%%%%%

sampleRate = parm.sample_freq;

data = [];
time = [];
data_width = parm.nrec;

file_length = length(start_times);

for i=1:length(start_times)
    
    fprintf("Progress: %d%%\n", round((i/file_length)*100))
    
    
    start_time = start_times(i);
    end_time = end_times(i);
    
    mid_point = floor(((end_time + start_time))/2);

    sub_data_start_time = mid_point - 5;

    if sub_data_start_time < 1
        %continue if the edge of the picture would be non-positive
        continue
    end
    sub_data = audioread(filename, ...
        [sub_data_start_time*sampleRate, sub_data_start_time*sampleRate + data_width]);


    [sp] = GPL_fft(sub_data,parm);
    sp_whiten = GPL_whiten(sp,parm);
    sp_loop=sp_whiten;

    %[quiet_whiten, quiet_fft, quiet_base, noise_floor, blocked, baseline0] = GPL_quiet(sp,sp_whiten,parm);

    norm_v=sp_loop./(ones(parm.nfreq,1)*sum(sp_loop.^2).^(1/2));
    norm_h=sp_loop./(sum(sp_loop'.^2).^(1/2)'*ones(1,parm.nbin));

    %next step was not a part of GPL in Helble et al.
    norm_v=whiten_matrix(norm_v')';norm_h=whiten_matrix(norm_h);

    bas=abs(norm_v).^parm.xp1.*abs(norm_h).^parm.xp2;
    
    A = flipud(mat2gray(abs(20*log10(abs(bas)))));
    
    A1 = A(:,1:204);
    
    imwrite(A1,'im1.jpg');
    A1 = imread('im1.jpg');

    sub_data = reshape(A1, 1, 204*204);

    data = [data; sub_data];
    time = [time; mid_point];
    
end

%% dialogue to prompt user to select a directory to put training data
choice = questdlg('Select a directory to store labeled data', 'Select Directory', 'OK', 'Cancel','OK');

if strcmp(choice, 'Cancel')
   return
end

% directory name to store training data
dirToStore = uigetdir;

image_data_name = "image_data.mat";
save(fullfile(dirToStore, image_data_name, 'data', 'time'));