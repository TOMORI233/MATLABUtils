function [uniqueCA, idx] = mUniqueCell(cellRaw, varargin)
mIp = inputParser;
mIp.addRequired("cellRaw", @(x) iscell(x));
mIp.addOptional("type", "simple", @(x) any(validatestring(x, {'simple', 'largest set', 'minimum set'})));
mIp.parse(cellRaw, varargin{:});

type = mIp.Results.type;

temp = reshape(cellRaw, [], 1);
idxTemp = 1 : length(temp);
temp = cellfun(@sort, temp(cellfun(@length, temp) > 1), "UniformOutput", false);
[temp, uniqIdx] = unique(string(cellfun(@(x) strjoin(mat2cellStr(x), ","), temp, "UniformOutput", false)));
idxTemp = idxTemp(uniqIdx);
temp = cellfun(@(k) str2double(strsplit(k, ",")), temp, "UniformOutput", false);

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