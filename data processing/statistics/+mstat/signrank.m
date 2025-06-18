function [p, stats, effectSize, bf10] = signrank(x, y, varargin)
% Wilcoxon signed rank test for paired samples [x] and [y].
% [x] and [y] are vectors of the same length.

x = x(:);
y = y(:);

if isequal(x, y)
    p = 1;
    stats = struct("signedrank", 0);
    effectSize = nan;
    return;
end

idx = find(matches(varargin, 'method', 'IgnoreCase', true));
if ~isempty(idx)
    varargin = [varargin(1:idx - 1), varargin(idx + 1:end)];
end

[p, ~, stats] = signrank(x, y, 'method', 'approximate', varargin{:});

% remove equal samples
N = sum(x ~= y);

% effect size r
effectSize = stats.zval ./ sqrt(N);

% Bayesian factor
bf10 = nan;

return;
end