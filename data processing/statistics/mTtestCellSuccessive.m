function [H, P] = mTtestCellSuccessive(trialData, varargin)
% Description: do T test, if two vectors have same length, do ttest, else, do ttest2.
% Input:
%     trialData: 1-D cell vector
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

X = trialData(1 : end-1);
Y = trialData(2 : end);
[H, P] = cellfun(@(x, y) mTtest(x, y, "Tail", Tail, "Alpha", Alpha), X, Y, "UniformOutput", false);
H = cell2mat(H);
P = cell2mat(P);
