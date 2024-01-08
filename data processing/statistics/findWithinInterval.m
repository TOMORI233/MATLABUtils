function [resVal,idx, count] = findWithinInterval(value, range, col, returnIdx)
narginchk(2 ,4);
if nargin < 3
    col = 1;
end
if nargin < 4
    returnIdx = [];
end

if size(range, 2) ~= 2
    range = range';
end

if size(range, 1) == 1
    if ~isempty(value)
        idx = find(value(:, col)>=range(1) & value(:, col)<=range(2));
        resVal = value(idx, :);
        if ~isempty(returnIdx)
            resVal = resVal(returnIdx);
        end
        count = length(idx);
    else
        idx = [];
        resVal = [];
        count = 0;
    end
else
    for rIndex = 1 : size(range, 1)
        idx{rIndex, 1} = find(value(:, col)>=range(rIndex, 1) & value(:, col)<=range(rIndex, 2));
        resVal{rIndex, 1} = value(idx{rIndex, 1}, :);
        if ~isempty(returnIdx)
            resVal{rIndex, 1} = resVal{rIndex, 1}(returnIdx);
        end
        count(rIndex) = length(idx{rIndex, 1});
    end
end
end

