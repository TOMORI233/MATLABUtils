function r = rbcc(x, y)
    % rank-biserial correlation coefficient of Wilcoxon signed rank test

    x = x(:);
    y = y(:);

    [~, ~, stats] = signrank(x, y, "method", "approximate");

    N = sum(x ~= y);
    r = stats.zval / sqrt(N);
end