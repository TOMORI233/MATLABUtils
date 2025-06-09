function r = rbcc_Wilcoxon(x, y)
    % Rank-biserial correlation coefficient of Wilcoxon signed rank test 
    % (non-parametric, paired)
    x = x(:);
    y = y(:);

    [~, ~, stats] = signrank(x, y, "method", "approximate");

    N = sum(x ~= y);
    r = stats.zval / sqrt(N);
end