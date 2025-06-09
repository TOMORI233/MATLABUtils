function d = cohensD(x1, x2)
    % Effect size for two paired independent samples (paired t-test).
    d = (mean(x1) - mean(x2)) / std(x1 - x2);
end
