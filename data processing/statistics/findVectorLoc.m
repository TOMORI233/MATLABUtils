function locs = findVectorLoc(X, pat, direction)
    % Find location of vector [pat] in vector [X].
    % [locs] is column vector of index numbers.
    % [X] and [pat] are either row vectors or column vectors.
    % [direction] specifies [locs] of the first or the last index of [pat].
    
    narginchk(2, 3);

    if nargin < 3
        direction = "first";
    end

    % Make [X] and [pat] row vector
    X = X(:)';
    pat = pat(:)';

    locs = strfind(X, pat)';

    if strcmpi(direction, "last")
        locs = locs + length(pat) - 1;
    end

    return;
end