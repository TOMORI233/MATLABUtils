function res = insertRows(X, rows, val)
    % To insert [val] in X at specified rows.

    narginchk(2, 3);

    if nargin < 3
        val = 0;
    end

    if ~(isscalar(val) && isnumeric(val))
        error("[val] should be a numeric scalar");
    end

    nRows = size(X, 1) + numel(rows);
    res = ones(nRows, size(X, 2)) * val;
    rowIdx = 1;

    for index = 1:nRows

        if ~ismember(index, rows)
            res(index, :) = X(rowIdx, :);
            rowIdx = rowIdx + 1;
        end

    end

    return;
end