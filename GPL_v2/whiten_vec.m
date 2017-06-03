function [spc,mu]=whiten_vec(sp);

[ks]=base3x(sp);
qs=sp(ks);
mu=mean(qs')';
spc=sp-mu;
