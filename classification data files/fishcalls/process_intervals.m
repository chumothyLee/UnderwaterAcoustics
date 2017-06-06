
%read in the file
intervals = load("../test/GofMX_MP01_100731_000345.df100.x_intervals_subset.txt");
%intervals = load("../test/test_intervals.txt");
start_times = intervals(:,round(1));
end_times = intervals(:,round(2));
%start_times = [10, 38000];
%end_times = [90, 38130];
filename = '../test/GofMX_MP01_100731_000345.df100.x.wav';
%%%%%%%%%%%

sampleRate = parm.sample_freq;

file_data = [];
time = [];
data_width = parm.nrec;

file_length = length(start_times);

for i=1:length(start_times)
    
    fprintf("Progress: %d%%\n", round((i/file_length)*100))
    
    
    start_time = start_times(i);
    end_time = end_times(i);

    %{
    if (end_time - start_time > 130 || end_time - start_time < 15 or start_time < 10)
        fprintf("interval time of %d is too long\n", (end_time - start_time)); 
        continue
    end
    %}

    
    mid_point = floor(((end_time + start_time))/2);

    sub_data_start_time = mid_point - 5;
    %sub_data_end_time = mid_point + 5;

    data = audioread(filename, ...
        [sub_data_start_time*sampleRate, sub_data_start_time*sampleRate + data_width]);


    [sp] = GPL_fft(data,parm);
    sp_whiten = GPL_whiten(sp,parm);
    sp_loop=sp_whiten;

    %[quiet_whiten, quiet_fft, quiet_base, noise_floor, blocked, baseline0] = GPL_quiet(sp,sp_whiten,parm);

    norm_v=sp_loop./(ones(parm.nfreq,1)*sum(sp_loop.^2).^(1/2));
    norm_h=sp_loop./(sum(sp_loop'.^2).^(1/2)'*ones(1,parm.nbin));

    %next step was not a part of GPL in Helble et al.
    norm_v=whiten_matrix(norm_v')';norm_h=whiten_matrix(norm_h);

    bas=abs(norm_v).^parm.xp1.*abs(norm_h).^parm.xp2;
    
    A = flipud(mat2gray(abs(20*log10(abs(bas)))));
    
    %A1 = A(:, mid_point_pixel - 102:mid_point_pixel + 101);
    A1 = A(:,1:204);
    
    imwrite(A1,'im1.jpg');
    A1 = imread('im1.jpg');

    data = reshape(A1, 1, 204*204);

    file_data = [file_data; data];
    time = [time; mid_point];
    
end

image_data_name = "image_data.mat";
save(image_data_name, 'file_data', 'time');


