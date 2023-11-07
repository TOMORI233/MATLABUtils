function [cwtres, f, coi] = cwtMultiAll(data, fs)
    % Apply cwt to multi-channel data and return spectrum within specified frequency range.
    % It can be encoded by gpucoder for parallel computation. See mGpucoder.m

    [nSample, nTrial] = size(data);
    [~, f, coi] = cwt(data(:, 1), 'amor', fs);
    cwtres = nan(nSample, length(f), nTrial);

    parfor tIndex = 1:nTrial
        cwtres(:, :, tIndex) = abs(cwt(data(:, tIndex), 'amor', fs));
    end

    return;
end