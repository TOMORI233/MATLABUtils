function res = changeCellRowNum(cellData)
    % Decription: convert a*1 cell with elements of b*n matrix to b*1 cell with elements of a*n matrix
    % Input:
    %     cellData: a*1 cell with elements of b*n numeric matrix
    % Output:
    %     res: b*1 cell with elements of a*n numeric matrix

    cellData = reshape(cellData, [numel(cellData), 1]);
    row = size(cellData{1}, 1);
    res = cellfun(@(r) cell2mat(cellfun(@(x) x(r, :), cellData, "UniformOutput", false)), mat2cell((1:row)', ones(row, 1)), "UniformOutput", false);
    
    return;
end
