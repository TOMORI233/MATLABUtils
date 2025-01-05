function [h, p] = mSpikeBootTest(spikeCounts1, spikeCounts2, iteration, alpha)
% Return h and p of non-parameter test for either two groups of cell
% data or fring rate data
% Input:
% [data1|data2]:
%       [data1] and [data2] should be vectors for firing rate or spike counts
%       across trials
% [iteration]
%       times for permutation, default: 1e4
% [alpha]
%       default: 0.05
narginchk(2, 4)
if nargin< 3
    iteration = 1e4;
end
if nargin < 4
    alpha = 0.05;
end
if ~strcmp(class(spikeCounts1), class(spikeCounts2)) || ~isnumeric(spikeCounts1)
    error("inputs should be vectors");
end


% 计算实际观测值的均值差
observedDiff = mean(spikeCounts1) - mean(spikeCounts2);
bootDiffs = zeros(1, iteration);

for i = 1:iteration
    resample1 = datasample(spikeCounts1, length(spikeCounts1)); % 有放回采样
    resample2 = datasample(spikeCounts2, length(spikeCounts2)); % 有放回采样
    bootDiffs(i) = mean(resample1) - mean(resample2);
end

% 计算 p 值
p = mean(abs(bootDiffs) >= abs(observedDiff)); % 双尾检验
if p < alpha
    h = 1;
else
    h = 0;
end
end
