
testDirectory = 'test_data';
outputFile = 'test.csv';

%get the network
[net_bn, info_bn] = cnn_fishcalls(...
  'expDir', 'data/fishcalls-bnorm', 'batchNormalization', true);

run ../matconvnet-1.0-beta18/matlab/vl_setupnn

%get the directory and the indices of the files
files = dir(testDirectory);
fileIndex = find(~[files.isdir]);

%dlmwrite(outputFile, ["time", "label", "degree of confidence"],...
%         'delimiter',',','-append'); 

for i=1:length(fileIndex)
    
    %currFile is the current .mat filename
    currFile = files(fileIndex(i)).name;
    
    %continue if not a .mat file
    if currFile(end-3:end) ~= '.mat'
        continue
    end

    %load the file, and extract the data and time label
    testPoint = load(currFile);
    data = testPoint.currData;
    time = testPoint.currTimeInfo;
    
    %format data for the neural network to process
    data = vec2mat(data, 204);
    data = single(data);
    
    %get the prediction probabilities
    net_bn.layers{end}.type = 'softmax';
    res = vl_simplenn(net_bn, data);
    
    %get the degree of confidence and the prediction
    scores = squeeze(gather(res(end).x));
    [bestScore, best] = max(scores);
    
    dlmwrite(outputFile, [best, bestScore], 'delimiter',',',...
            '-append');
    
end


    