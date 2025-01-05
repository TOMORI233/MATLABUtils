function B = cellcat(dim, A)
    % cat cell array
    B = cat(dim, A{:});
    return;
end