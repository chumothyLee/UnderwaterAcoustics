[net_bn, info_bn] = cnn_fishcalls(...
  'expDir', 'data/fishcalls-bnorm', 'batchNormalization', true);

% [net_fc, info_fc] = cnn_fishcalls(...
%   'expDir', 'data/fishcalls-baseline', 'batchNormalization', false);

figure(1) ; clf ;
subplot(1,2,1) ;
%semilogy(info_fc.val.objective', 'o-') ; hold all ;

%old line --> semilogy(info_bn.val.objective', '+--') ;

%start new stuff
objective = []
for i = 1:length(info_bn.val)
   objective = [objective info_bn.val(i).objective]
end
semilogy(objective, '+--')

%end new stuff


xlabel('Training samples [x 10^3]'); ylabel('energy') ;
grid on ;
h=legend('BSLN', 'BNORM') ;
set(h,'color','none');
title('objective') ;
subplot(1,2,2) ;
%plot(info_fc.val.error', 'o-') ; hold all ;
% old line --> plot(info_bn.val.error', '+--') ;
%new code
top1err = []
for i = 1:length(info_bn.val)
   top1err = [top1err info_bn.val(i).top1err]
end
plot(top1err, '+--') ;
%end new code
h=legend('BSLN-val','BSLN-val-5','BNORM-val','BNORM-val-5') ;
grid on ;
xlabel('Training samples [x 10^3]'); ylabel('error') ;
set(h,'color','none') ;
title('error') ;
drawnow ;