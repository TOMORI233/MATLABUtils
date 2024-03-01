function [trialsData, window] = cutData(trialsData, windowOld, windowNew)
    % [windowOld] and [windowNew] are in ms

    if windowNew(2) > windowOld(2)
        warning('New time window exceeds data range. Limit to upper range.');
        windowNew(2) = windowOld(2);
    end

    if isa(trialsData, "double") % For single trial input
        t = linspace(windowOld(1), windowOld(2), size(trialsData, 2));
        tIdx = find(t >= windowNew(1), 1):find(t >= windowNew(2), 1);
        trialsData = trialsData(:, tIdx);
    elseif isa(trialsData, "cell")
        idx = find(~cellfun(@isempty, trialsData));
        t = linspace(windowOld(1), windowOld(2), size(trialsData{idx(1)}, 2));
        tIdx = find(t >= windowNew(1), 1):find(t >= windowNew(2), 1);
        trialsData(idx) = cellfun(@(x) x(:, tIdx), trialsData(idx), "UniformOutput", false);
    else
        error("Invalid data type");
    end

    window = [t(tIdx(1)), t(tIdx(end))];

    return;
end