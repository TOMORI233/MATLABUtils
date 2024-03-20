function v = getOrFull(s, default)
% Description:
%     Complete [s] with [default]. [default] is specified as a
%     struct containing some fields of [s] with default values.
%     Fields not in [default] but in [s] or not in [s] but in
%     [default] will be reserved.
%     For fields in both [s] and [default], field values in [s]
%     will be reserved.
%     For [s] as struct array, [default] should be a scalar or of
%     the same length of [s].
%     If [s] and [default] are struct arrays of the same length, 
%     [s] will be completed with [default] in corresponding indices.
%     
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

if ~isstruct(default) || ~isstruct(s)
    error("getOrFull(): inputs should be type struct");
end

if isscalar(default)
    v = arrayfun(@(x) getOrFullScalar(x, default), s);
else
    if numel(default) ~= numel(s)
        error("getOrFull(): [default] should be a scalar or of the same size as [s]");
    end
    v = arrayfun(@(x, y) getOrFullScalar(x, y), s, default);
end

return;
end

%% Impl
function v = getOrFullScalar(s, default)
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
