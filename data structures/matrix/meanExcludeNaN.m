function res = meanExcludeNaN(data, dim)
    temp = num2cell(data, dim);
    res = cell2mat(cellfun(@(x) mean(x(~isnan(x) & ~isinf(x))), temp, "UniformOutput", false));
end