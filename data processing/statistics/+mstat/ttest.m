function [p, stats, effectSize, bf10] = ttest(x, y, varargin)
% Paired t-test between two independent samples [x] and [y].
% [x] and [y] are vectors of the same length.

[bf10, p, ~, stats] = bf.ttest(x, y, varargin{:});
effectSize = cohensD(x, y);

return;
end