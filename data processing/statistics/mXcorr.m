function [AC, lags] = mXcorr(A, varargin)
% how much B prior to A


mIp = inputParser;
mIp.addRequired("A", @(x) validateattributes(x, {'numeric'}, {'2d'}));
mIp.addOptional("B", A, @(x) validateattributes(x, {'numeric'}, {'2d'}));
mIp.addParameter("binSize", [], @(x) validateattributes(x, {'numeric'}, {'2d'}));
mIp.addParameter("maxLag", [], @(x) validateattributes(x, {'numeric'}, {'2d'}));

mIp.parse(A, varargin{:});

B = mIp.Results.B;
binSize = mIp.Results.binSize;
maxLag = mIp.Results.maxLag;
if ~isempty(maxLag)
    if isempty(binSize)
        maxLag = 1 : length(A)-1;
    end
else
    maxLag = 1 : length(A) - 1;
end

if isempty(binSize)
    binSize = 1;
end
maxBin = min([length(A)-1, ceil(maxLag/binSize)]);
%% validation
if ~iscolumn(A)
    if ~iscolumn(A')
        return
    else
        A = A';
    end
end

if nargin < 2
    B = A;
elseif ~iscolumn(B)
    B = B';
end

if length(A) ~= length(B)
    error("The two inputs should have equal length!");
end

%% compute correlation
N = length(A);  % Total number of points in time series
AC = zeros(1, maxBin);  % Initialize autocorrelation result

% Calculate sample variance
temp   = cov(A, B);
sigma2 = abs(temp(1,2));

% Subtract mean from A to get zero-mean time series
if ~all(A==0)
    AC = cellfun(@(x) dot(A(1:N-x) - mean(A(1:N-x)), B(x+1:N) - mean(B(x+1:N))) / ((N - x) * sigma2), num2cell(1:maxBin));
%     AC = cellfun(@(x) (dot(A(1:N-x), B(x+1:N)) / (N - x) - mean(A(1:N-x)) *  mean(B(x+1:N))) / sigma2, num2cell(1:maxBin));
% for j = 1 : maxBin
%     AC(j) = dot(A(1:N-j) - mean(A(1:N-j)), B(j+1:N) - mean(B(j+1:N))) / ((N - j) * sigma2);
% end
end
lags = binSize*(1:N-1);
end
