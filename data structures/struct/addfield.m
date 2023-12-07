function s = addfield(s, fName, fVal)
    % Description: Add a new field to [s] or alter the value of an existed field
    %
    % [s] should be a column struct array.
    % [fVal] should be a column array of cell or 2-D matrix and have the same length of [s].
    % If [fVal] is a cell array, it will be assigned to [s] element by element.
    % If [fVal] is a 2-D martix, it will be assigned to [s] row by row.

    mIp = inputParser;
    mIp.addRequired("s", @(x) isstruct(x) && isvector(x));
    mIp.addRequired("fName", @(x) (isstring(x) && isscalar(x)) || (ischar(x) && isscalar(cellstr(x))));
    mIp.addRequired("fVal", @(x) (iscell(x) && numel(x) == numel(s)) || (ndims(x) == 2 && size(x, 1) == numel(s)));
    mIp.parse(s, fName, fVal);

    % assign values by loops
    for sIndex = 1:numel(s)
        if iscell(fVal)
            s(sIndex).(fName) = fVal{sIndex};
        else
            s(sIndex).(fName) = fVal(sIndex, :);
        end
    end

    return;
end