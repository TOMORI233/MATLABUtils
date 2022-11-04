function [A, f, Aoi] = mfft(X, fs, varargin)
    % Description: return single-sided amplitude spectrum A of data X
    % Input:
    %     X: data
    %     fs: sampling frequency, Hz
    %     N: N-point fft (default: data length)
    %     dim: 1 for data of [nSample, nCh], 2 for data of [nCh, nSample] (default: 2)
    %     foi: frequency range of interest, one- or two-element vector
    % Output:
    %     A: single-sided amplitude spectrum
    %     f: frequency vector of N-point single-sided fft
    %     Aoi: amplitude of foi

    mIp = inputParser;
    mIp.addRequired("X", @(x) validateattributes(x, 'numeric', {'2d'}));
    mIp.addRequired("fs", @(x) validateattributes(x, 'numeric', {'numel', 1, 'positive'}));
    mIp.addOptional("N", [], @(x) validateattributes(x, 'numeric', {'numel', 1, 'positive', 'integer'}));
    mIp.addOptional("dim", 2, @(x) ismember(x, [1, 2]));
    mIp.addOptional("foi", [], @(x) validateattributes(x, 'numeric', {'2d', 'increasing', 'positive', "<=", fs/2}));
    mIp.parse(X, fs, varargin{:});
    N = mIp.Results.N;
    dim = mIp.Results.dim;
    foi = mIp.Results.foi;

    X = permute(X, [3 - dim, dim]);
    Y = fft(X, N, 2);

    if isempty(N)
        N = floor(length(X) / 2) * 2;
    end

    A = abs(Y(:, 1:N / 2 + 1) / size(X, 2));
    A(:, 2:end - 1) = 2 * A(:, 2:end - 1);
    f = linspace(0, fs / 2, N / 2 + 1);

    if nargin < 5
        Aoi = [];
    else

        if numel(foi) == 1
            [~, idx] = min(abs(f - foi));
        
            if f(idx) < foi
                Aoi = (A(:, idx) + A(:, min(idx + 1, length(f)))) / 2;
            elseif f(idx) > foi
                Aoi = (A(:, idx) + A(:, max(idx - 1, 1))) / 2;
            else % v == 0
                Aoi = A(:, idx);
            end

        elseif numel(foi) == 2
            idx = find(f > foi(2), 1, "last") + 1:find(f < foi(1), 1) - 1;

            if ~isempty(idx)
                Aoi = mean(A(:, idx), 2);
            else
                error("No data matched");
            end

        else
            error("Invalid frequency of interest");
        end

    end

    A = permute(A, [3 - dim, dim]);
    return;
end