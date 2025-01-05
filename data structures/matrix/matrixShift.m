function Y = matrixShift(X, N, dim)
% Shift 2-D matrix [X] by [N] points and pad with zeros
% N > 0: up/right
% N < 0: down/left

if dim == 1
    % column by column
    X = X';
    Y = rowFcn(@(x) vectorShift(x, N), X, "UniformOutput", false);
    Y = cat(1, Y{:})';
elseif dim == 2
    % row by row
    Y = rowFcn(@(x) vectorShift(x, N), X, "UniformOutput", false);
    Y = cat(1, Y{:});
else
    error("Invalid dimension");
end

return;
end