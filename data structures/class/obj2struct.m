function s = obj2struct(obj)
    % return [s] as a struct column vector
    fieldNames = properties(class(obj));
    params = [];

    for index = 1:length(fieldNames)
        params = [params, fieldNames(index), {{obj.(fieldNames{index})}'}];
    end

    s = struct(params{:});
    return;
end