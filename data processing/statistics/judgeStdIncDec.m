function [H, P] = judgeStdIncDec(trialData, varargin)
% Description: for two neighbor cells, test if they are significantlly different
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

XX = cellfun(@(x, y) [x(ismember(x(:, 2), y(:, 2)), :)], X, Y, "UniformOutput", false);

[H, P] = cellfun(@(x, y) mTtest(x(:, 1), y(:,1), "Tail", Tail, "Alpha", Alpha), XX, Y, "UniformOutput", false);
H = cell2mat(H);
P = cell2mat(P);
