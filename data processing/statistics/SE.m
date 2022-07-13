function y = SE(x, dim)
    narginchk(1, 2);

    if nargin < 2
        dim = 1;
    end

    [a, b, c] = size(x);

    if b == 1 && c == 1
        nX = a;
    else
        nX = size(x, dim);
    end

    y = std(x, 0, dim) / sqrt(nX);
    return;
end