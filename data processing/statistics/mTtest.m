function [h, p] = mTtest(x, y, varargin)
% Description: do T test, if two vectors have same length, do ttest, else, do ttest2.
% Input:
%     x/y: data1/data2
%     tail: do one-tailed or two-tailed test (left/right)
%     alpha: significance level

% Output:
%     h: Testing decision of null hypothesis
%     p: p value


mIp = inputParser;
mIp.addRequired("x", @isnumeric);
mIp.addRequired("y", @isnumeric);
mIp.addParameter("Tail", "both", @(x) any(validatestring(x, {'both', 'left', 'right'})));
mIp.addParameter("Alpha", 0.05, @isnumeric);

mIp.parse(x, y, varargin{:});
Tail = mIp.Results.Tail;
Alpha = mIp.Results.Alpha;

if length(x) == length(y)
    [h, p] = ttest(x, y, "Tail", Tail, "Alpha", Alpha); % right:check if x > y; left:check if x < y
else
    [h, p] = ttest2(x, y, "Tail", Tail, "Alpha", Alpha); % right:check if x > y; left: check if x < y
end
