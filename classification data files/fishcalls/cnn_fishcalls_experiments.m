fprintf("calling cnn_fishcalls \n");
[net_bn, info_bn] = cnn_fishcalls(...
  'expDir', 'data/fishcalls-bnorm', 'batchNormalization', true);

% [net_fc, info_fc] = cnn_fishcalls(...
%   'expDir', 'data/fishcalls-baseline', 'batchNormalization', false);

figure(1) ; clf ;
subplot(1,2,1) ;
%semilogy(info_fc.val.objective', 'o-') ; hold all ;

semilogy(info_bn.val.objective', '+--') ;

%start new stuff
%I'm trying to get a classification
%test = imread('example_jetski.jpg');
%test = imresize(single(test), net_bn.meta.normalization.imageSize(1:2));
%test = test - net_bn.meta.normalization.averageImage;

run ../matconvnet-1.0-beta18/matlab/vl_setupnn
%prenet = load('../matconvnet-1.0-beta18/imagenet-vgg-f.mat');
%im = imread('example_jetski.jpg');
%im_ = imresize(single(im), prenet.meta.normalization.imageSize(1:2)) ; 
%im_ =  im_ - prenet.meta.normalization.averageImage ;
%res = vl_simplenn(prenet, im_);

%test = banana

test = load('image_data4_3.mat') ;
test = test.currData;
%test = test - net_bn.meta.normalization.averageImage
res = vl_simplenn(net_bn, test');
fprintf("hopefully predicted: %d", res);
test = banana
%end new stuff


xlabel('Training samples [x 10^3]'); ylabel('energy') ;
grid on ;
h=legend('BSLN', 'BNORM') ;
set(h,'color','none');
title('objective') ;
subplot(1,2,2) ;
%plot(info_fc.val.error', 'o-') ; hold all ;
plot(info_bn.val.error', '+--') ;
%new code
%top1err = [];
%for i = 1:length(info_bn.val)
%   top1err = [top1err info_bn.val(i).top1err];
%end
%plot(top1err, '+--') ;
%end new code
h=legend('BSLN-val','BSLN-val-5','BNORM-val','BNORM-val-5') ;
grid on ;
xlabel('Training samples [x 10^3]'); ylabel('error') ;
set(h,'color','none') ;
title('error') ;
drawnow ;