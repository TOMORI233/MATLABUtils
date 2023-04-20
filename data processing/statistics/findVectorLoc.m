function loc = findVectorLoc(X, pat)
    loc = find(arrayfun(@(idx) isequal(X(idx:idx + length(pat) - 1), pat), 1:length(X) - length(pat)), 1);
    return;
end