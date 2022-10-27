function y = rowFcn(fcn, matrix, returnInCell)
    % Description: apply fcn to each row of matrix
    
    narginchk(2, 3);

    if nargin < 3
        returnInCell = false;
    end

    singleRowFcnHandle = @(fcn, matrix) @(row) fcn(matrix(row, :));
    rowFcnHandle = @(fcn, matrix) arrayfun(singleRowFcnHandle(fcn, matrix), 1:size(matrix, 1), "UniformOutput", returnInCell)';
    y = rowFcnHandle(fcn, matrix);
    return;
end