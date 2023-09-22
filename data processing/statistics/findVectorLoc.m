function locs = findVectorLoc(X, pat, n)
    % Find location of vector [pat] in vector [X].
    % [locs] is row vector of index numbers.
    % [X] and [pat] are either row vectors or column vectors.
    % If [n] is not specified, return all index numbers.
    
    narginchk(2, 3);

    if nargin < 3
        locs = find(arrayfun(@(idx) isequal(X(idx:idx + length(pat) - 1), pat), 1:length(X) - length(pat)));
    else
        locs = find(arrayfun(@(idx) isequal(X(idx:idx + length(pat) - 1), pat), 1:length(X) - length(pat)), n);
    end

    return;
end