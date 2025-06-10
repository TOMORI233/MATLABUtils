function [p, stats, effectSize, bf10] = ttest2(x, y, varargin)
% Two-sample t-test between two independent samples [x] and [y].
% [x] and [y] are vectors, not necessary of the same size.

[bf10, p, ~, stats] = bf.ttest2(x, y, varargin{:});
effectSize = cohensD2(x, y);

return;
end