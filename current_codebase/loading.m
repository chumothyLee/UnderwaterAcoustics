imagesdata = [];
label = [];


%% dialogue to prompt user to select a directory to put training data
choice = questdlg('Select a directory containing training data', 'Select Directory', 'OK', 'Cancel','OK');

if strcmp(choice, 'Cancel')
    return
end

% directory name to store training data
mat_directory = uigetdir;

%mat_directory = 'test_data'; %TODO: guify this
files = dir(mat_directory);
fileIndex = find(~[files.isdir]);
%fprintf("%d", length(fileIndex));

%% collecting image data from different files

for i = 1:length(fileIndex)
    %str1 = strcat('image_data',int2str(i) ,'.mat');
    
    currFile = fullfile(mat_directory, files(fileIndex(i)).name)
    %fprintf("%s\n", currFile);
    %continue if not a .mat file
    if currFile(end-3:end) ~= '.mat'
        continue
    end
    file = load(currFile);
    
    %data = file.currData;
    %label = file.currLabel;
    
    imagesdata = [imagesdata;file.currData];
    label = [label;file.currLabel];
    %clear data
    %clear label
end
clear labels
%% shuffling----------
l = size(imagesdata);
l1 = l(1);
idx = randperm(l1);
imagesdata = imagesdata(idx,:);
label = label(idx);

%% dividing train and test set
images.set(1:l1) = 0;
images.set(1:uint32(l1*80/100)) = 1;
images.set(uint32(l1*80/100):l1) = 3;

%% changing the dimentions(204 x 204 x 1 x total_images) for input to CNN 
input_data =[];
images.data = reshape(imagesdata',[204,204,1,l1]);
images.data =single(images.data);
dataMean = mean(images.data(:,:,:,images.set == 1), 4);
images.data = bsxfun(@minus, images.data, dataMean) ;
images.data_mean = reshape(mean(imagesdata),[204,204]);
images.data_mean = single(images.data_mean);
images.labels(1:l1) = 0;
%% labeling 1 to 9...
for i = 1:l1
        if(strcmp(label(i),'blank'))
            images.labels(i) = 1;
        elseif(strcmp(label(i),'noise'))
            images.labels(i) = 2;
        elseif(strcmp(label(i),'croak'))
            images.labels(i) = 3;
        elseif(strcmp(label(i),'jet-ski'))
            images.labels(i) = 4;
        elseif(strcmp(label(i),'click train'))
            images.labels(i) = 5;
        elseif(strcmp(label(i),'pulse train'))
            images.labels(i) = 6;
        elseif(strcmp(label(i),'buzz'))
            images.labels(i) = 7;
        elseif(strcmp(label(i),'downsweep'))
            images.labels(i) = 8;
        elseif(strcmp(label(i),'beat'))
            images.labels(i) = 9;
        end
end

meta.sets = {'train', 'val', 'test'} ;
meta.classes = arrayfun(@(x)sprintf('%d',x),0:8,'uniformoutput',false) ;


list = ['blank      ';'noise      ';'croak      ';'jet-ski    ';'click train';'pulse train';'buzz       ';'downsweep  ';'beat       '];
listofcalls = cellstr(list);
s = size(listofcalls);
s1 = s(1);
for i = 1:s1
    count = size(find(strcmp(label,listofcalls(i))));
    disp(listofcalls(i)) 
    disp(count(1))
end

%% dialogue to prompt user to select a directory to put training data
choice = questdlg('Select a directory to store imdb file', 'Select Directory', 'OK', 'Cancel','OK');

if strcmp(choice, 'Cancel')
   return
end

% directory name to store training data
dirToStore = uigetdir;
filename = fullfile(dirToStore, 'imdb.mat');
save(filename);