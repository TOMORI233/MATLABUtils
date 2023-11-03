function psth = calPSTH(trials, windowPSTH, binSize, step)
    % [trials] should contain field [spike], which is a column vector
    % [psth] will be returned as a column vector
    % [windowPSTH] is a two-element vector in millisecond
    % [binSize] and [step] are in millisecond

    edge = windowPSTH(1) + binSize / 2:step:windowPSTH(2) - binSize / 2; % ms

    switch class(trials)
        case "cell"
            trials = cellfun(@(x) reshape(x, [numel(x), 1]), trials, "UniformOutput", false);
            psth = mHist(cell2mat(reshape(trials, [numel(trials), 1])), edge, binSize) / (binSize / 1000) / length(trials); % Hz
        case "struct"
            psth = mHist(vertcat(trials.spike), edge, binSize) / (binSize / 1000) / length(trials); % Hz
    end

    return;
end