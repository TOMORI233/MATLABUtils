function fr = calFR(trials, windowFR)
    % [trials] should contain field [spike]
    % [fr] will be returned as a column vector
    % [windowFR] is a two-element vector in millisecond

    fr = arrayfun(@(x) length(x.spike >= windowFR(1) & x.spike <= windowFR(2)) / (diff(windowFR) / 1000), trials);

    return;
end