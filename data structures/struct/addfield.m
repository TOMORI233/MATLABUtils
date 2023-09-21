function s = addfield(s, fName, fVal)
    % Description: Add a new field to [s]
    %
    % [s] should be a column struct array.
    % [fVal] should be a column array of cell or 2-D matrix and have the same length of [s].
    % If [fVal] is a cell array, it will be assigned to [s] element by element.
    % If [fVal] is a 2-D martix, it will be assigned to [s] row by row.

    % assign values by loops
    for sIndex = 1:length(s)
        if iscell(fVal)
            s(sIndex).(fName) = fVal{sIndex};
        else
            s(sIndex).(fName) = fVal(sIndex, :);
        end
    end

    return;
end