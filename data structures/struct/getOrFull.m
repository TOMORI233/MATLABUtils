function v = getOrFull(s, default)
    % Description: Complete [s] with [default]. [default] is specified as 
    %              the struct containing all fields of [s] with default values.

    if ~isa(default, "struct")
        error("default should be a struct containing full parameters");
    end

    fieldNamesAll = fieldnames(default);

    for fIndex = 1:length(fieldNamesAll)
        v.(fieldNamesAll{fIndex}) = getOr(s, fieldNamesAll{fIndex}, default.(fieldNamesAll{fIndex}));
    end

    if ~isempty(s)
        fieldNamesS = fieldnames(s);
    
        for fIndex = 1:length(fieldNamesS)
            v.(fieldNamesS{fIndex}) = s.(fieldNamesS{fIndex});
        end

    end
    
    return;
end