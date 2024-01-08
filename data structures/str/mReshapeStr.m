function out = mReshapeStr(str, bSize)
    out = cellfun(@(x) string(reshape(char(x), bSize, [])')', str, "UniformOutput", false)';
end