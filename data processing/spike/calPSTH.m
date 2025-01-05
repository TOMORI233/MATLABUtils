function [psth, edge, whole, frRaw] = calPSTH(trials, windowPSTH, binSize, step)
    % If [trials] is a struct array, it should contain field [spike] for each trial.
    % If [trials] is a cell array, its element contains spikes of each trial.
    % [psth] will be returned as a column vector.
    % [windowPSTH] is a two-element vector in millisecond.
    % [binSize] and [step] are in millisecond.

    edge = windowPSTH(1) + binSize / 2:step:windowPSTH(2) - binSize / 2; % ms

    trials = reshape(trials, [numel(trials), 1]);
    if any(cellfun(@ndims, trials) > 1)
        trials = cellfun(@(x) x(:, 1), trials, "UniformOutput", false);
    end

    switch class(trials)
        case "cell"
            trials = cellfun(@(x) x(:), trials, "UniformOutput", false);
            frRaw = cell2mat(cellfun(@(x) mHist(x, edge, binSize), trials, "UniformOutput", false)') * 1000 / binSize;
            temp = cat(1, trials{:});
            nTrials = length(trials);
            psth = mHist(temp, edge, binSize) / (binSize / 1000) / nTrials; % Hz
        case "struct"
            temp = arrayfun(@(x) reshape(x.spike, [numel(x.spike), 1]), trials, "UniformOutput", false);
            frRaw = cell2mat(cellfun(@(x) mHist(x, edge, binSize), temp, "UniformOutput", false)') * 1000 / binSize;
            psth = mHist(vertcat(temp), edge, binSize) / (binSize / 1000) / length(trials); % Hz
    end
    whole = [edge', psth];
    return;
end