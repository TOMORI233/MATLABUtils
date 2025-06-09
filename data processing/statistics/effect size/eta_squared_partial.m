function res = eta_squared_partial(anovatbl, k)
    % Effect size of the k-th factor in n-way ANOVA
    SS_k     = anovatbl{k + 1, 2};
    SS_error = anovatbl{end - 1, 2};
    res = SS_k / (SS_k + SS_error);
    
    return;
end