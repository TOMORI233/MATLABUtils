function v = getOrFull(s, default)
    % Description:
    % Complete [s] with [default]. [default] is specified as a 
    % struct containing some fields of [s] with default values.
    % Fields not in [default] but in [s] or not in [s] but in 
    % [default] will be reserved.
    % For fields in both [s] and [default], field values in [s] 
    % will be reserved.
    % Example:
    %     A = struct("a1", 1, "a2", 2);
    %     B = struct("a1", 11, "a3", 3);
    %
    %     C = getOrFull(A, B) returns
    %     >> C.a1 = 1
    %     >> C.a2 = 2
    %     >> C.a3 = 3
    %
    %     D = getOrFull(B, A) returns
    %     >> D.a1 = 11
    %     >> D.a2 = 2
    %     >> D.a3 = 3

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
