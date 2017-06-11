%TODO: specify this with the GUI

%% dialogue to prompt user to select a directory to put training data
choice1 = questdlg('Select an imdb to process', 'Select file', 'OK', 'Cancel','OK');

if strcmp(choice1, 'Cancel')
    return
end

imdbPath = uigetfile;

choice2 = questdlg('Select an directory containing test data', 'Select file', 'OK', 'Cancel','OK');

if strcmp(choice2, 'Cancel')
    return
end

testDirectory = uigetdir;

choice = questdlg('Select a directory to store output', 'Select file', 'OK', 'Cancel','OK');

if strcmp(choice, 'Cancel')
    return
end

outputFile = fullfile(uigetdir, 'test.csv');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%get the network
[net_bn, info_bn] = cnn_fishcalls(...
  'expDir', 'data/fishcalls-bnorm', 'batchNormalization', true);

%extract the dataMean from the imdb.mat file
imdb = load(imdbPath + '/imdb.mat');
dataMean = imdb.dataMean;

%get the directory and the indices of the files
files = dir(testDirectory);
fileIndex = find(~[files.isdir]);

fileID = fopen(outputFile, 'w');
fprintf(fileID, "Time, Label, Degree of Confidence\n");

correct_count = 0;
incorrect_count = 0;

for i=1:length(fileIndex)
    
    %currFile is the current .mat filename
    currFile = files(fileIndex(i)).name;
    
    %continue if not a .mat file
    if currFile(end-3:end) ~= '.mat'
        continue
    end

    %load the file, and extract the data and time label
    currFile = load(currFile);
    s = size(currFile.data);
    numTestPoints = s(1);
    
    for j=1:numTestPoints
        data = currFile.data(j,:);
    
        %format data for the neural network to process
        data = reshape(data', [204, 204, 1, 1]);
        data = single(data);
        data = bsxfun(@minus, data, dataMean) ;
    
        %get the prediction probabilities
        net_bn.layers{end}.type = 'softmax';
        res = vl_simplenn(net_bn, data, [], [], 'mode', 'test');
    
        %get the degree of confidence and the prediction
        scores = squeeze(gather(res(end).x));
        [bestScore, best] = max(scores);
        
        fprintf("%d\n", best);
        %TODO: this will go when we use real test data.  It's just for
        %evaluating the test error right now when using the data Ana gave
        %us
        %{
        if(strcmp(currFile.labels(j),'blank'))
            actual = 1;
        elseif(strcmp(currFile.labels(j),'noise'))
            actual = 2;
        elseif(strcmp(currFile.labels(j),'croak'))
            actual = 3;
        elseif(strcmp(currFile.labels(j),'jet-ski'))
            actual = 4;
        elseif(strcmp(currFile.labels(j),'click train'))
            actual = 5;
        elseif(strcmp(currFile.labels(j),'pulse train'))
            actual = 6;
        elseif(strcmp(currFile.labels(j),'buzz'))
            actual = 7;
        elseif(strcmp(currFile.labels(j),'downsweep'))
            actual = 8;
        elseif(strcmp(currFile.labels(j),'beat'))
            actual = 9;
        end
        
        if best == actual
            correct_count = correct_count + 1;
        else
            incorrect_count = incorrect_count + 1;
        end
        
        %}
        %Get the timestamp of the data point
        %time = currFile.time(j);
        time = "TIME";
        
        fprintf(fileID, "%s, %d, %d\n", time, best, bestScore);
    end
end

%fprintf("Test Error: %d\n", (incorrect_count/(incorrect_count + correct_count)));
fclose(fileID);