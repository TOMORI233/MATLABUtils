function d = cohensD2(x1, x2)
    % This function computes the effect size for two unpaired independent 
    % samples.

    % Compute means
    mean1 = mean(x1);
    mean2 = mean(x2);

    % Compute standard deviations
    std1 = std(x1, 1); % Use N instead of N-1 for population std
    std2 = std(x2, 1);

    % Compute sample sizes
    n1 = length(x1);
    n2 = length(x2);

    % Compute pooled standard deviation
    pooledStd = sqrt(((n1 - 1) * std1^2 + (n2 - 1) * std2^2) / (n1 + n2 - 2));

    % Compute Cohen's d
    d = (mean1 - mean2) / pooledStd;
end
