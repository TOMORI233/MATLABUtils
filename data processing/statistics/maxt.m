function [maxVal, t] = maxt(X, T, dim)
    % return maximum value of time series data X and the corresponding time t

    narginchk(2, 3);

    if nargin < 3
        [maxVal, idx] = max(X);
    else
        [maxVal, idx] = max(X, [], dim);
    end

    t = T(idx);
    return;
end