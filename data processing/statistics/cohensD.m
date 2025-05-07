function d = cohensD(x1, x2)
    % This function computes the effect size for two paired independent 
    % samples.
    d = (mean(x1) - mean(x2)) / std(x1 - x2);
end
