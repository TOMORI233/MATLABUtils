function res = insertRows(X, rows)
    % insert 0 in y at specified rows
    nRows = size(X, 1) + numel(rows);
    res = zeros(nRows, size(X, 2));
    rowIdx = 1;

    for index = 1:nRows

        if ~ismember(index, rows)
            res(index, :) = X(rowIdx, :);
            rowIdx = rowIdx + 1;
        end

    end

    return;
end