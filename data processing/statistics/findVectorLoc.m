function locs = findVectorLoc(X, pat, n, direction)
    % Find location of vector [pat] in vector [X].
    % [locs] is row vector of index numbers.
    % [X] and [pat] are either row vectors or column vectors.
    % If [n] is not specified or left empty, return all index numbers.
    % [direction] specifies [locs] of the first or the last index of [pat].
    
    narginchk(2, 4);

    if nargin < 3 || isempty(n)
        n = length(X) - length(pat);
    end

    if nargin < 4
        direction = "first";
    end

    % Make [X] and [pat] column vector
    X = reshape(X, [numel(X), 1]);
    pat = reshape(pat, [numel(pat), 1]);

    locs = find(arrayfun(@(idx) isequal(X(idx:idx + length(pat) - 1), pat), (1:length(X) - length(pat))'), n);

    if strcmpi(direction, "last")
        locs = locs + length(pat) - 1;
    end

    return;
end