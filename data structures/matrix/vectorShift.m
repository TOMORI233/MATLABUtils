function Y = vectorShift(X, N)
    % N > 0: up/right
    % N < 0: down/left
    % Shift vector [X] by [N] points and pad with zeros

    [nRows, nCols] = size(X);
    X = X(:);
    
    if N > 0
        Y = [zeros(N, 1); X(1:numel(X) - N)];
    elseif N < 0
        N = -N;
        Y = [X(N + 1:numel(X)); zeros(N, 1)];
    else
        Y = X;
    end

    if nRows < nCols % row vector
        Y = Y';
    end

    return;
end