function [uniqueCA, idx] = mUniqueCell(cellRaw, varargin)
mIp = inputParser;
mIp.addRequired("cellRaw", @(x) iscell(x));
mIp.addOptional("type", "simple", @(x) any(validatestring(x, {'simple', 'largest set', 'minimum set'})));
mIp.parse(cellRaw, varargin{:});

type = mIp.Results.type;

temp = reshape(cellRaw, [], 1);
idxTemp = 1 : length(temp);
[temp, uniqIdx] = unique(string(cellfun(@(x) strjoin(mat2cellStr(sort(x)), ","), temp, "UniformOutput", false)));
idxTemp = idxTemp(uniqIdx);
temp = cellfun(@(k) str2double(strsplit(k, ",")), temp, "UniformOutput", false);
[~, index] = sortrows(cell2mat(cellfun(@(x) [x, zeros(1, max(cellfun(@length, temp) - length(x)))], temp, "UniformOutput", false)), 1:cellfun(@length, temp), "ascend");
idxTemp = idxTemp(index);
temp = temp(index);
if matches(type, "simple")
    uniqueCA = temp;
    idx = idxTemp';
elseif matches(type, "largest set")
    largest_set = ~any(cell2mat(cellfun(@(x, y) ~ismember((1:length(temp))', y) & cellfun(@(k) all(ismember(k, x)), temp), temp, num2cell(1:length(temp))', "UniformOutput", false)'), 2);
    uniqueCA = temp(largest_set);
    idx = idxTemp(largest_set)';
elseif matches(type, "minimum set")
    minimum_set = ~any(cell2mat(cellfun(@(x, y) ~ismember((1:length(temp))', y) & cellfun(@(k) all(ismember(k, x)), temp), temp, num2cell(1:length(temp))', "UniformOutput", false)'), 1)';
    uniqueCA = temp(minimum_set);
    idx = idxTemp(minimum_set)';
end
end