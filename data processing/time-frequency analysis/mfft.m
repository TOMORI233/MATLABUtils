function [A, f, Aoi] = mfft(X, fs, N, dim, foi)
    % Description: return single-sided amplitude spectrum A of data X
    % Input:
    %     X: data
    %     fs: sampling frequency
    %     N: N-point fft
    %     dim: 1-along column, 2-along row
    %     foi: frequency range of interest, one- or two element vector
    % Output:
    %     A: single-sided amplitude spectrum
    %     f: frequency vector of N-point single-sided fft
    %     Aoi: amplitude of foi

    narginchk(2, 5);

    if nargin < 3
        N = [];
    end

    if nargin < 4 || isempty(dim)
        dim = 2;
    end

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