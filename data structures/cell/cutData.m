function trialsData = cutData(trialsData, windowOld, windowNew)
    % [windowOld] and [windowNew] are in ms

    t = linspace(windowOld(1), windowOld(2), size(trialsData{1}, 2));
    tIdx = find(t >= windowNew(1), 1):find(t >= windowNew(2), 1);
    trialsData = cellfun(@(x) x(:, tIdx), trialsData, "UniformOutput", false);

    return;
end