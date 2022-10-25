function y = SE(x, dim)
    narginchk(1, 2);

    if nargin < 2

        if isvector(x)
            y = std(x) / sqrt(length(x));
            return;
        else
            dim = 1;
        end

    end

    if isa(dim, "double")
        nX = size(x, dim);
    elseif strcmp(dim, "all")
        nX = numel(x);
    else
        error("Invalid dim input");
    end

    y = std(x, [], dim) / sqrt(nX);
    return;
end