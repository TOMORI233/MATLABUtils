function [p, stats, effectSize, bf10] = ranksum(x, y, varargin)
% Wilcoxon rank sum test (Mann-Whitney U test)
% [x] and [y] are vectors, not necessary of the same size.

idx = find(matches(varargin, 'method', 'IgnoreCase', true));
if ~isempty(idx)
    varargin = [varargin(1:idx - 1), varargin(idx + 1:end)];
end

[p, ~, stats] = ranksum(x, y, "method", "approximate", varargin{:});
effectSize = abs(stats.zval) / sqrt(numel(x) + numel(y));

bf10 = nan;

return;
end
