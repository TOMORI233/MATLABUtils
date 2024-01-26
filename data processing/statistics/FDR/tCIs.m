function cis=tCIs(data,span)
%function cis=tCIs(data,span)
%
% Required Input:
%  data = observations x variables matrix
%
% Optional Input:
%  span = Probability covered by confidence interval (default: 0.95)
%
% Outputs:
%  cis = 2 x n_variable matrix indicating upper and lower bounds of
%        t-distribution based confidence intervals
%
% Author: 
% David M. Groppe
% Feinstein Institute for Medical Research
% Sept. 2014

% Future work:
%  You could likely speed this up by computing the mean and std with the same
%  optimized function.

fprintf('Running tCIs.m\n');

if nargin<2,
   span=.95; 
end

alph=1-span;

[n_obs, n_var]=size(data);
fprintf('%d variables, %d observations\n',n_var,n_obs);

critT=icdf('t',alph/2,n_obs-1);
se=std(data)/sqrt(n_obs);
mn=mean(data);
cis=zeros(2,n_var);
cis(1,:)=mn+critT*se; % Lower bound
cis(2,:)=mn-critT*se; % Upper bound
