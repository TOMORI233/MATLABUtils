function x = replaceVal(x, val, val0)
narginchk(2, 3);

if nargin < 3
    val0 = [];
end

if isnumeric(val0)
    val0 = mat2cell(reshape(val0, [numel(val0), 1]), ones(numel(val0), 1));
elseif isa(val0, "function_handle")
    val0 = {val0};
end

% val0 is a cell array here
if (all(cellfun(@(y) isa(y, "function_handle"), val0)) && any(cellfun(@(y) y(x), val0))) || any(cellfun(@(y) isequal(x, y), val0))
    x = val;
end
