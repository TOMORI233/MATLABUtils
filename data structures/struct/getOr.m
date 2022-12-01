function v = getOr(s, field, default, emptyOpt)
%   getOr Returns the structure field or a default if either don't exist
%   v = getOr(s, field, [default]) returns the 'field' of the structure 's'
%   or 'default' if the structure is empty of the field does not exist. If
%   default is not specified it defaults to []. 'field' can also be a cell
%   array of fields, in which case it will check for all of them and return
%   the value of the first field that exists, if any (otherwise the default
%   value).
narginchk(2, 4);

if nargin < 3
    default = [];
end

if nargin < 4
    emptyOpt = false;
end

field = string(field);
fieldExists = isfield(s, field);

if any(fieldExists)
    if ~emptyOpt
        v = s.(field(find(fieldExists, 1)));
    else
        if all(cellfun(@isempty, {s.(field)}))
            v = default;
        else
            v = s.(field(find(fieldExists, 1)));
        end
    end
else
    v = default;
end

end
