function [minVal, t] = mint(X, T, dim)
    % return minimum value of time series data X and the corresponding time t

    narginchk(2, 3);

    if nargin < 3
        [minVal, idx] = min(X);
    else
        [minVal, idx] = min(X, [], dim);
    end

    t = T(idx);
    return;
end