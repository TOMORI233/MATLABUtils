function [psth, edge, whole] = calPSTH(trials, windowPSTH, binSize, step)
    % If [trials] is a struct array, it should contain field [spike] for each trial.
    % If [trials] is a cell array, its element contains spikes of each trial.
    % If [trials] is a numeric vector, it represents spike times in one trial.
    % [psth] will be returned as a column vector.
    % [windowPSTH] is a two-element vector in millisecond.
    % [binSize] and [step] are in millisecond.

    edge = windowPSTH(1) + binSize / 2:step:windowPSTH(2) - binSize / 2; % ms

    trials = reshape(trials, [numel(trials), 1]);

    switch class(trials)
        case "cell"
            trials = cellfun(@(x) x(:), trials, "UniformOutput", false);
            temp = cat(1, trials{:});
            nTrials = length(trials);
            psth = mHist(temp, edge, binSize) / (binSize / 1000) / nTrials; % Hz
        case "struct"
            temp = arrayfun(@(x) x.spike(:), trials, "UniformOutput", false);
            psth = mHist(vertcat(temp), edge, binSize) / (binSize / 1000) / length(trials); % Hz
        case "double"
            if isvector(trials)
                psth = mHist(trials, edge, binSize) / (binSize / 1000);
            else
                error("Invalid trials input");
            end
    end
    whole = [edge', psth];
    return;
end