function x = replaceVal(x, newVal, condition)
    % Replace [x] with newVal if [x] is in [condition] or satisfies condition(x).
    %
    % [x] is a scalar of any class.
    % [newVal] is any.
    % [condition] can be:
    %     - numeric scalar/vector/matrix: 1, [1,2,3], [1,2;3,4]
    %     - string scalar/vector/matrix: "a", ["a","b"], ["a","b";"c","d"]
    %     - function_handle: @isinteger, @(x) x>0
    %     - cell array composed of the above types: {1,2,3}, {"a","b"}, {@(x) x>0, @(x) mod(x,2)==0}
    %     - multiclass cell array: {1, @(x) x<0}
    %
    % Example:
    %     X = [-2, -1, 0, 1, 2];
    %     A = {"a", 1, 2, "b"};
    %
    %     % Replace X(i) with 100 if X(i) is negative or even
    %     Y1 = arrayfun(@(x) replaceVal(x, 100, {@(t) t<0, @(t) mod(t,2)==0}), X)
    %
    %     % Replace X(i) with 100 if X(i) is in [-3, -2, -1]
    %     Y2 = arrayfun(@(x) replaceVal(x, 100, [-3, -2, -1]), X)
    %     Y2_1 = arrayfun(@(x) replaceVal(x, 100, {-3, -2, -1}), X)
    %
    %     % Replace X(i) with 100 if X(i) equals 1 or is even
    %     Y3 = arrayfun(@(x) replaceVal(x, 100, {1, @(t) mod(t,2)==0}), X)
    %
    %     % Replace A{i} with 100 if A{i} is a letter
    %     B = cellfun(@(x) replaceVal(x, 100, @isletter), A, "uni", false)
    %
    %     >> Y1 = [100, 100, 100, 1, 100]
    %     >> Y2 = [100, 100, 0, 1, 2]
    %     >> Y2_1 = [100, 100, 0, 1, 2]
    %     >> Y3 = [100, -1, 100, 100, 100]
    %     >> B = {100, 1, 2, 100}
    
    narginchk(2, 3);
    
    if nargin < 3
        condition = [];
    end
    
    if isnumeric(condition)
        condition = mat2cell(reshape(condition, [numel(condition), 1]), ones(numel(condition), 1));
    elseif isa(condition, "function_handle")
        condition = {condition};
    end
    
    % condition is a cell array
    condition = reshape(condition, [numel(condition), 1]);
    
    % find function_handle in condition
    idx = cellfun(@(y) isa(y, "function_handle"), condition);
    
    % replace value
    if any(cellfun(@(y) y(x), condition(idx))) || any(cellfun(@(y) isequal(x, y), condition(~idx)))
        x = newVal;
    end
    
    return;
end