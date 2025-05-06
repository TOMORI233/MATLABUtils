function [A, f, Aoi, Phase] = mfft(X, fs, varargin)
% Description: return single-sided amplitude spectrum A of data X
% Input:
%     X: data (a vector or a 2-D matrix)
%     fs: sampling frequency, Hz
%     N: N-point fft (default: data length)
%     dim: which dimension of data to perform fft along.
%          dim=1 for data of [nSample, nCh].
%          dim=2 for data of [nCh, nSample](default).
%          If [X] is a vector, [dim] input does not work.
%     foi: frequency range of interest, one- or two-element vector
% Output:
%     A: single-sided amplitude spectrum
%     f: frequency vector of N-point single-sided fft
%     Aoi: amplitude of foi

mIp = inputParser;
mIp.addRequired("X", @(x) validateattributes(x, 'numeric', {'real', '2d'}));
mIp.addRequired("fs", @(x) validateattributes(x, 'numeric', {'scalar', 'positive'}));
mIp.addOptional("N", [], @(x) isempty(x) || (isscalar(x) && x > 0 && x == mod(x, 1)));
mIp.addOptional("dim", 2, @(x) ismember(x, [1, 2]));
mIp.addOptional("foi", [], @(x) validateattributes(x, 'numeric', {'2d', 'increasing', 'positive', "<=", fs/2}));
mIp.parse(X, fs, varargin{:});
N = mIp.Results.N;
dim = mIp.Results.dim;
foi = mIp.Results.foi;

if isvector(X)
    X = reshape(X, [1, length(X)]);
else
    X = permute(X, [3 - dim, dim]);
end

if isempty(N)
    % N = 2 ^ nextpow2(size(X, 2));
    N = floor(size(X, 2) / 2) * 2;
end

N = floor(N / 2) * 2;
Y = fft(X, N, 2);
A = abs(Y(:, 1:N / 2 + 1) / size(X, 2));
A(:, 2:end - 1) = 2 * A(:, 2:end - 1);
f = linspace(0, fs / 2, N / 2 + 1);
Phase = angle(Y(:, 1:N / 2 + 1));

if nargin < 5
    Aoi = [];
else

    if isscalar(foi)
        [~, idx] = min(abs(f - foi));
    
        if f(idx) < foi
            Aoi = (A(:, idx) + A(:, min(idx + 1, length(f)))) / 2;
        elseif f(idx) > foi
            Aoi = (A(:, idx) + A(:, max(idx - 1, 1))) / 2;
        else
            Aoi = A(:, idx);
        end

    elseif numel(foi) == 2
        idx = find(f > foi(1) & f < foi(2));

        if ~isempty(idx)
            idx(1) = max([idx(1) - 1, 1]);
            idx(2) = min([idx(2) + 1, length(f)]);
            Aoi = mean(A(:, idx), 2);
        else
            error("No data matched");
        end

    else
        error("Invalid frequency of interest");
    end

end

A = permute(A, [3 - dim, dim]);
Phase = permute(Phase, [3 - dim, dim]);
return;
end