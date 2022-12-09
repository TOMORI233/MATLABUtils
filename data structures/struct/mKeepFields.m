function [s] = mKeepFields(s, fields)

% KEEPFIELDS makes a selection of the fields in a structure
%
% Use as
%   s = keepfields(s, fields);
if isempty(s)
   % this prevents problems if s is an empty double, i.e. []
  return
end
fields = string(fields);
fields = setdiff(string(fieldnames(s)), fields);
for i=1:numel(fields)
  s = rmfield(s, fields(i));
end
