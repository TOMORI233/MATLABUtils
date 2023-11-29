function [cwtres, f, coi] = cwtMultiAll(data, fs)
    % Apply cwt to multi-channel data. The result is returned in a nTrial*nFreq*nTime
    % complex double matrix.
    % This procedure is for cross-spectral density matrix computation in 
    % nonparametric computation of granger causality.
    %
    % It can be encoded by gpucoder for parallel computation. See mGpucoder.m

    [nSample, nTrial] = size(data);
    [~, f, coi] = cwt(data(:, 1), 'amor', fs);
    cwtres = complex(nan(nTrial, length(f), nSample));

    parfor tIndex = 1:nTrial
        cwtres(tIndex, :, :) = cwt(data(:, tIndex), 'amor', fs);
    end

    return;
end