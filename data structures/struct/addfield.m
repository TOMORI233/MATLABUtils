function s = addfield(s, fName, fVal)
% Description: Add a new field to [s] or alter the value of an existed field
%
% [s] should be a struct array.
% [fName] is a cellstr scalar. ({'a'} | 'a' | "a")
% [fVal] should be a cell vector or 2-D matrix with the same row number of [s].
% If [fVal] is a cell array, it will be assigned to [s] element by element.
% If [fVal] is a 2-D martix, it will be assigned to [s] row by row.

mIp = inputParser;
mIp.addRequired("s", @(x) isstruct(x) && isvector(x));
mIp.addRequired("fName", @(x) isscalar(cellstr(x)));
mIp.addRequired("fVal", @(x) (iscell(x) && numel(x) == numel(s)) || (isnumeric(x) && size(x, 1) == numel(s)));
mIp.parse(s, fName, fVal);

fName = cellstr(fName);

% assign values by loops
for sIndex = 1:numel(s)
    if iscell(fVal)
        s(sIndex).(fName{1}) = fVal{sIndex};
    else
        s(sIndex).(fName{1}) = fVal(sIndex, :);
    end
end

return;
end