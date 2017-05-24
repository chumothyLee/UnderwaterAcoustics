
imagesdata = [];
label = [];

%% collecting image data from different files
for i = 1:22
    str1 = strcat('image_data',int2str(i) ,'.mat');
    load(str1);
    imagesdata = [imagesdata;data];
    label = [label;labels];
    clear data
    clear labels
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
save('imdb.mat');
% count_2 = size(find(strcmp(label,'noise')));
% count_2(1)
% 
% count_3 = size(find(strcmp(label,'croak')));
% count_3(1)
% 
% count_4 = size(find(strcmp(label,'jet-ski')));
% count_4(1)
% 
% count_5 = size(find(strcmp(label,'click train')));
% count_5(1)
% 
% count_6 = size(find(strcmp(label,'pulse train')));
% count_6(1)
% 
% count_7 = size(find(strcmp(label,'buzz')));
% count_7(1)
% 
% count_8 = size(find(strcmp(label,'downsweep')));
% count_8(1)
% 
% count_9 = size(find(strcmp(label,'beat')));
% count_9(1)