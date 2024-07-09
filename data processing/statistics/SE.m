function y = SE(x, varargin)
    % Return standard error of [x] along [dim]

    mIp = inputParser;
    mIp.addRequired("x");
    mIp.addOptional("dim", [], @(x) isscalar(x) && (strcmpi(x, 'all') || (x > 0 && fix(x) == x)));
    mIp.addOptional("omitnan", "omitnan", @(x) strcmpi(x, 'omitnan'));
    mIp.parse(x, varargin{:})

    dim = mIp.Results.dim;
    omitnan = strcmpi(mIp.Results.omitnan, 'omitnan');

    if isempty(dim)
        if omitnan
            stdVal = std(x, [], "omitnan");
            nX = sum(~isnan(x));
        else
            stdVal = std(x);
            nX = sum(ones(size(x)));
        end
    else
        if omitnan
            stdVal = std(x, [], dim, "omitnan");
            nX = sum(~isnan(x), dim);
        else
            stdVal = std(x, [], dim);
            nX = sum(ones(size(x)), dim);
        end
    end
    
    y = stdVal ./ sqrt(nX);
    return;
end