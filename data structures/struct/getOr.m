function v = getOr(s, field, default, replaceEmpty)
    % getOr Returns the structure field or a default if either don't exist
    % v = getOr(s, field, [default], replaceEmpty) returns the 'field' of the 
    % structure 's' or 'default' if the structure is empty of the field does 
    % not exist. If default is not specified it defaults to []. 'field' can 
    % also be a cell array of fields, in which case it will check for all of 
    % them and return the value of the first field that exists, if any 
    % (otherwise the default value). If [replaceEmpty] is set true, then 
    % default will be used when s.(field) is empty.

    narginchk(2, 4);

    field = string(field);

    if nargin < 3
        default = [];
    end

    if nargin < 4
        replaceEmpty = false;
    end

    fieldExists = isfield(s, field);

    if any(fieldExists) && ~isempty(s)

        if ~replaceEmpty
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
