function r = rbcc_MWU(x, y)
    % Effect size of Mann-Whitney U test (non-parametric, unpaired)
    n1 = numel(x);
    n2 = numel(y);

    [~, ~, stats] = ranksum(x, y, "method", "approximate");
    z = stats.zval;
    r = abs(z) / sqrt(n1 + n2);

    return;
end