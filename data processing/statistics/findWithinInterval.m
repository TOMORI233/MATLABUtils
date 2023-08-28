function [resVal,idx, count] = findWithinInterval(value, range, col)
narginchk(2,3);
if nargin < 3
    col = 1;
end
if size(range, 2) ~= 2
    range = range';
end

if size(range, 1) == 1
    if ~isempty(value)
        idx = find(value(:, col)>=range(1) & value(:, col)<=range(2));
        resVal = value(idx, :);
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
        count(rIndex) = length(idx{rIndex, 1});
    end
end
end

