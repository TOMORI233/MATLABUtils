function [CData, f, coi] = cwtMulti(data, fs, fRange)
    [nSample, nTrial] = size(data);
    CData = zeros(nSample, nTrial);

    [~, f, coi] =cwt(data(:, 1), 'amor', fs);
    fIdx(1) = max([1, find(f < fRange(1), 1) - 1]);
    fIdx(2) = min([length(f), find(f > fRange(2), 1, "last") + 1]);
    fIdx = unique(fIdx);

    parfor index = 1:nTrial
        wt = cwt(data(:, index), 'amor', fs);
        CData(:, index) = mean(abs(wt(fIdx, :)), 1);
    end

    return;
end