function res = changeCellRowNum(cellData)
    % Decription: convert a*1 cell with elements of b*n matrix to b*1 cell with elements of a*n matrix
    % Notice: cellData will be reshape into column vector before converting.
    % Input:
    %     cellData: a A*1 or 1*A cell vector with elements of an B*N numeric matrix (or a 2-D cell array 
    %               which is NOT RECOMMENDED).
    % Output:
    %     res: a B*1 cell vector with elements of an A*N numeric matrix
    % Example:
    %     X = {[10,  11,  12; ...
    %           100, 101, 102]; ...
    %          [20,  21,  22; ...
    %           200, 201, 202]; ...
    %          [30,  31,  32; ...
    %           300, 301, 302]};
    %     Y = changeCellRowNum(X) returns
    %     >> Y = {[10, 11, 12; ...
    %              20, 21, 22; ...
    %              30, 31, 32]; ...
    %             [101, 101, 102; ...
    %              200, 201, 202; ...
    %              300, 301, 302]}

    cellData = reshape(cellData, [numel(cellData), 1]);
    a = length(cellData);
    b = size(cellData{1}, 1);
    n = size(cellData{1}, 2);

    % O(N^2), T(1)
    % res = cellfun(@(r) cell2mat(cellfun(@(x) x(r, :), cellData, "UniformOutput", false)), mat2cell((1:b)', ones(b, 1)), "UniformOutput", false);

    % O(1), T(N^2)
    temp = cat(3, cellData{:});
    temp = permute(temp, [1, 3, 2]);
    res = cellfun(@squeeze, mat2cell(temp, ones(b, 1), a, n), "UniformOutput", false);

    return;
end
