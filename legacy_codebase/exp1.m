load('imdb.mat');


idx = find(images.set == 3);
img = imagesdata(idx,:);
l = label(idx);

for i = 300:300
    
    temp = reshape(img(i,:),[204 204]);
    imshow(temp);
    hold on;
%     prompt1 = 'Want to save?[y/n]: ';
%     str = input(prompt1,'s');
%     if (strcmp(str,'y') || strcmp(str,'Y'))
%         imwrite(temp,strcat('F:/traindata/misclassified/im',int2str(i),'_',l{i},'.jpg'));
%     end
end