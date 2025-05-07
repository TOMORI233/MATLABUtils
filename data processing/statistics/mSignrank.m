function [p, h, stats, r] = mSignrank(X, Y, varargin)
% This function performs Wilcoxon signed-rank test between paired samples.
% For matrices, mSignrank performs tests along each column of X, and returns 
% a vector of results.

if isvector(X) && isvector(Y)
    X = X(:)';
    Y = Y(:)';
end

if ~isequal(size(X), size(Y))
    error("Samples should be paired");
end

X = X';
Y = Y';

if isequal(X, Y)
    p = ones(size(X, 1), 1);
    h = zeros(size(X, 1), 1);
    stats = struct("signedrank", num2cell(zeros(size(X, 1), 1)));
    r = nan(size(X, 1), 1);
    return;
end

% Wilcoxon signed-rank test
[p, h, stats] = rowFcn(@(x, y) signrank(x, y, varargin{:}), X, Y);

% z-value
Z = [stats.zval]';

% remove equal samples
N = rowFcn(@(x, y) sum(x ~= y), X, Y);

% effect size r
r = Z ./ sqrt(N);

return;
end