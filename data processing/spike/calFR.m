function fr = calFR(trials, windowFR)
    % If [trials] is a struct array, it should contain field [spike] for each trial.
    % If [trials] is a cell array, its element contains spikes of each trial.
    % If [trials] is a numeric vector, it is a spike vector.
    % [fr] will be returned as a column vector.
    % [windowFR] is a two-element vector in millisecond.

    trials = trials(:);
    
    switch class(trials)
        case "single"
            fr = sum(trials >= windowFR(1) & trials <= windowFR(2)) / diff(windowFR) * 1000;
        case "double"
            fr = sum(trials >= windowFR(1) & trials <= windowFR(2)) / diff(windowFR) * 1000;
        case "cell"
            fr = cellfun(@(x) sum(x >= windowFR(1) & x <= windowFR(2)) / diff(windowFR) * 1000, trials);
        case "struct"
            fr = arrayfun(@(x) sum(x.spike >= windowFR(1) & x.spike <= windowFR(2)) / diff(windowFR) * 1000, trials);
    end

    return;
end