function y = genRiseFallEdge(y, fs, rfTime, rfOpt)
    % Time in sec
    % Frequency in Hz
    % y: [nCh, nSample]

    narginchk(3, 4);

    if isvector(y)
        y = y(:)';
    end

    if rfTime == 0
        return;
    end

    if nargin < 4
        rfOpt = "both";
    end
    
    nRF = fix(rfTime * fs);

    switch rfOpt
        case "rise"
            y(:, 1:nRF) = y(:, 1:nRF) .* (sin(pi * (0:1 / (nRF - 1):1) - pi / 2) + 1) / 2;
        case "fall"
            y(:, end - nRF + 1:end) = y(:, end - nRF + 1:end) .* (sin(pi * (0:1 / (nRF - 1):1) + pi / 2) + 1) / 2;
        case "both"
            y(:, 1:nRF) = y(:, 1:nRF) .* (sin(pi * (0:1 / (nRF - 1):1) - pi / 2) + 1) / 2;
            y(:, end - nRF + 1:end) = y(:, end - nRF + 1:end) .* (sin(pi * (0:1 / (nRF - 1):1) + pi / 2) + 1) / 2;
        otherwise
            error("Invalid rfOpt");
    end

    return;
end