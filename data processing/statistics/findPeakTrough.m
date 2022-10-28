function [peakIdx, troughIdx] = findPeakTrough(data, dim)
    narginchk(1, 2);

    if nargin < 2
        dim = 2;
    end

    data = permute(data, [3 - dim, dim]);
    [nCh, nSample] = size(data);

    peakIdx = false(nCh, nSample);
    troughIdx = false(nCh, nSample);

    for cIndex = 1:nCh
        temp = false(1, nSample);
        temp(find(diff(sign(diff(data(cIndex, :)))) == -2) + 1) = true;
        peakIdx(cIndex, :) = temp;

        temp = false(1, nSample);
        temp(find(diff(sign(diff(data(cIndex, :)))) == 2) + 1) = true;
        troughIdx(cIndex, :) = temp;
    end

    return;
end
