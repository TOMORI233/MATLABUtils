function trueOrFalse = isCellByCol(data)
    if ~iscell(data)
        trueOrFalse = false;
        return
    else
        [row, col] = size(data);
        temp = cellfun(@class, data', 'UniformOutput', false);
        if length(unique(temp)) == 1
            trueOrFalse = true;
        else
            uniqueClass = cellfun(@unique, array2VectorCell(temp), 'UniformOutput', false);
         trueOrFalse =  all(cellfun(@length, uniqueClass) == 1);
        end
    end
end