function b = mCopyFields(a, b, fields)

% COPYFIELDS copies a selection of the fields from one structure to another
%
% Use as
%   b = copyfields(a, b, fields);
fields = string(fields);
if isempty(a)
  % this prevents problems if a is an empty double, i.e. []
  return
end

if isempty(b)
  % this prevents problems if a is an empty double, i.e. []
  b = mKeepFields(a, fields);
  return
end

fields = intersect(string(fieldnames(a)), fields);
for i=1:numel(fields)
  b.(fields(i)) = a.(fields(i));
end
