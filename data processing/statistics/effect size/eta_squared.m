function res = eta_squared(anovatbl)
    % Effect size of one-way ANOVA
    SS_between  = anovatbl{2,2};  % Sum of squares between groups
    SS_total    = anovatbl{4,2};    % Total sum of squares
    res = SS_between / SS_total;  % Eta squared
    
    return;
end