function res = changeCellRowNum(cellData)
    cellData = reshape(cellData, [numel(cellData), 1]);
    row = size(cellData{1}, 1);
    res = cellfun(@(r) cell2mat(cellfun(@(x) x(r, :), cellData, "UniformOutput", false)), mat2cell((1:row)', ones(row, 1)), "UniformOutput", false);
    return;
end