function varargout = rowFcn_beta(fcn, A, varargin)
    % NOT RECOMMENDED - Please use rowFcn instead
    % Description: apply fcn to each row of matrix (based on arrayfun)
    % Input:
    %     fcn: function handle, function to apply to each row
    %     A: a 2-D matrix or a vector
    %     B1,...,Bn: other matrixes
    %     "UniformOutput": true/false
    % Output:
    %     Ouputs of fcn with nRows=size(A, 1)

    %% Validation
    mIp = inputParser;
    mIp.addRequired("fcn", @(x) validateattributes(x, 'function_handle', {'numel', 1}));
    mIp.addRequired("A", @(x) validateattributes(x, 'numeric', {'2d'}));
    for n = 1:sum(cellfun(@isnumeric, varargin))
        eval(['B', num2str(n), '=varargin{', num2str(n), '};']);
        mIp.addOptional(eval(['"B', num2str(n), '"']), [], @(x) validateattributes(x, 'numeric', {'size', [size(A, 1), NaN]}));
    end
    mIp.addParameter("UniformOutput", true, @islogical);
    mIp.parse(fcn, A, varargin{:});

    %% Impl
    commaSeparateIndexing = @(C, idx) struct("output", cellfun(@(x) x(idx, :), C, "UniformOutput", false));
    singleRowFcnHandle = @(fcn, A, varargin) @(row) fcn(A(row, :), commaSeparateIndexing(varargin, row).output);
    rowFcnHandle = @(fcn, A, varargin) arrayfun(singleRowFcnHandle(fcn, A, varargin{:}), 1:size(A, 1), "UniformOutput", mIp.Results.UniformOutput);
    [varargout{1:nargout}] = rowFcnHandle(fcn, A, varargin{cellfun(@isnumeric, varargin)});
    varargout = cellfun(@(x) x', varargout, "UniformOutput", false);
    return;
end