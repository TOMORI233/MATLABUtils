function res = SEExcludeNaN(data, dim)
    temp = num2cell(data, dim);
    res = cell2mat(cellfun(@(x) SE(x(~isnan(x))), temp, "UniformOutput", false));
end