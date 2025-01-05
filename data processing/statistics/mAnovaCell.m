function [p, postHoc, h, postHoc_H] = mAnovaCell(trialData, varargin)
% Description: do one-way anova for n*1 cell, each cell contains m*1 vector
% Input:
%     trialData: data (an 1-D cell)
%     tIndex: index of data selected
%     label: the label of entire trialData
%     CriticalValueType: method of post-hoc test

% Output:
%     p: p value
%     postHoc: post-hoc multi-comparison
%     h: Testing decision of null hypothesis

mIp = inputParser;
mIp.addRequired("trialData", @(x) iscell(x));
mIp.addParameter("tIndex", 1:length(trialData), @isnumeric);
mIp.addParameter("label", (1:length(trialData))', @(x) isstring(x) | isnumeric(x));
mIp.addParameter("CriticalValueType", "tukey-kramer", @(x) any(validatestring(x, {'tukey-kramer', 'dunn-sidak', 'bonferroni', 'scheffe', 'dunnett'})));

mIp.parse(trialData, varargin{:});
tIndex = mIp.Results.tIndex;
label = mIp.Results.label;
CriticalValueType = mIp.Results.CriticalValueType;

% length validation
if length(label) ~= length(trialData)
    error("length of trialData and label do not match");
end

% select data
data = trialData(tIndex);
if ~iscolumn(data)
    data = data';
end
dataTemp = cell2mat(data);

% set tag
if isnumeric(label)
    label = string(num2cell(label));
end
tag = label(tIndex);
temp = cellfun(@(x, y) string(repmat(y, length(x), 1)), data, tag, "UniformOutput", false);
tagTemp = vertcat(temp{:});

% anova
[p, ~, stats] = anova1(dataTemp, tagTemp);
h = double(p > 0.05);

[c, ~, ~, gnames] = multcompare(stats, "Display", "off", "CriticalValueType", CriticalValueType);
cTemp = [c, double(c(:, 6) < 0.05)];

temp0 = 1 : length(tIndex);
postHocTemp = cellfun(@(x) [temp0(~ismember(temp0, x))' cTemp(any(ismember(cTemp(:, 1:2), x), 2), 6:7)], num2cell(temp0), "UniformOutput", false)';
temp = cell2mat(postHocTemp);
postHoc_H = any(temp(:, end));
minNum = cellfun(@(x) char(tag(x(find(x(:, 3) == 1, 1, "first"), 1))), postHocTemp, "UniformOutput", false);
postHoc = cell2struct([num2cell(temp0)', gnames, postHocTemp, minNum], ["idx", "group", "multiCompare", "minNum"], 2);
end