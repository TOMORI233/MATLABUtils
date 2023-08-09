function testRes = tTestCertainCell(trialData, varargin)
% Description: compare a certain  if they are significantlly different
% Input:
%     trialData: 1-D cell vector
%     numSel: index selected 
%     tail: do one-tailed or two-tailed test (left/right)
%     alpha: significance level

% Output:
%     h: Testing decision of null hypothesis
%     p: p value

mIp = inputParser;
mIp.addRequired("trialData", @iscell);
mIp.addParameter("Tail", "both", @(x) any(validatestring(x, {'both', 'left', 'right'})));
mIp.addParameter("Alpha", 0.05, @isnumeric);

mIp.parse(trialData, varargin{:});
Tail = mIp.Results.Tail;
Alpha = mIp.Results.Alpha;

for tIndex = 1 : length(trialData) 
    tIdx = trialData{tIndex, 1}(:, 2);
    [H1, P1] = cellfun(@(x) mTtest(x(ismember(x(:, 2), tIdx), 1), trialData{tIndex, 1}(:, 1), "Tail", Tail, "Alpha", Alpha), trialData(1:tIndex), "UniformOutput", false);
    [H2, P2] = cellfun(@(x) mTtest(trialData{tIndex, 1}(:, 1), x(ismember(x(:, 2), tIdx), 1), "Tail", Tail, "Alpha", Alpha), trialData(tIndex+1:end), "UniformOutput", false);
%     [H1, P1] = cellfun(@(x) mTtest(x(:, 1), trialData{tIndex, 1}(:, 1), "Tail", Tail, "Alpha", Alpha), trialData(1:tIndex), "UniformOutput", false);
%     [H2, P2] = cellfun(@(x) mTtest(trialData{tIndex, 1}(:, 1), x(:, 1), "Tail", Tail, "Alpha", Alpha), trialData(tIndex+1:end), "UniformOutput", false);
    testRes(tIndex).H = cell2mat([H1; H2]);
    testRes(tIndex).P = cell2mat([P1; P2]);
end
end

