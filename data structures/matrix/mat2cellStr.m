function str = mat2cellStr(mat)
[Col, Raw] = size(mat);
    str = cellfun(@(x) num2str(x), num2cell(mat), "UniformOutput", false);
    str = reshape(str, [Col, Raw]);
end