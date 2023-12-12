function trialsData = cutData(trialsData, fs, windowOld, windowNew)
    % [windowOld] and [windowNew] are in ms
    % [fs] is in Hz

    tIdx = fix((windowNew(1) - windowOld(1)) / 1000 * fs):fix((windowNew(2) - windowOld(1)) / 1000 * fs);
    trialsData = cellfun(@(x) x(:, tIdx), trialsData, "UniformOutput", false);
    return;
end