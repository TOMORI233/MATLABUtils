function b = mRepFields(a, cells, fields)

% COPYFIELDS copies a selection of the fields from one structure to another
%
% Use as
%   b = copyfields(a, b, fields);
fields = string(fields);
if ~iscolumn(a)
    a = a';
end
if isempty(a)
  % this prevents problems if a is an empty double, i.e. []
  return
end

if isempty(cells)
  % this prevents problems if a is an empty double, i.e. []
  b = mKeepFields(a, fields);
  return
end
cellRaw = struct2cell(a)';
fieldsRaw = string(fieldnames(a));
[~, ia, ib] = intersect(string(fieldnames(a)), fields);
cellRaw(:, ia) = cells(:, ib);
b = cell2struct(cellRaw, fieldsRaw, 2);


