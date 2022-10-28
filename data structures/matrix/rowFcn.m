function varargout = rowFcn(fcn, A, varargin)
    % Description: apply fcn to each row of matrix
    % Input:
    %     fcn: function handle, function to apply to each row
    %     A: a 2-D matrix or a vector
    %     B1,...,Bn: other matrixes
    %     "UniformOutput": true/false
    % Output:
    %     Ouputs of fcn with nRows=size(A, 1)

    mInputParser = inputParser;
    mInputParser.addRequired("fcn", @(x) validateattributes(x, 'function_handle', {'numel', 1}));
    mInputParser.addRequired("A", @(x) validateattributes(x, 'numeric', {'2d'}));

    for n = 1:sum(cellfun(@isnumeric, varargin))
        eval(['B', num2str(n), '=varargin{', num2str(n), '};']);
        mInputParser.addOptional(eval(['"B', num2str(n), '"']), [], @(x) validateattributes(x, 'numeric', {'size', [size(A, 1), NaN]}));
    end

    mInputParser.addParameter("UniformOutput", true, @islogical);
    mInputParser.parse(fcn, A, varargin{:});

    singleRowFcnHandle = @(fcn, A, varargin) @(row) fcn(A(row, :), varargin{:}(row, :));
    rowFcnHandle = @(fcn, A, varargin) arrayfun(singleRowFcnHandle(fcn, A, varargin{:}), 1:size(A, 1), "UniformOutput", mInputParser.Results.UniformOutput);
    [varargout{1:nargout}] = rowFcnHandle(fcn, A, varargin{cellfun(@isnumeric, varargin)});
    varargout = cellfun(@(x) x', varargout, "UniformOutput", false);
    return;
end