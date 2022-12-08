function varargout = rowFcn(fcn, A, varargin)
    % Description: apply fcn to each row of matrix (based on cellfun)
    % Input:
    %     fcn: function handle, function to apply to each row
    %     A: a 2-D matrix or a vector
    %     B1,...,Bn: other matrixes
    %     "UniformOutput": true/false
    % Output:
    %     Ouputs of fcn with nRows=size(A, 1)
    % Example:
    %     C = rowFcn(@mFcn, A, B, "UniformOutput", false);

    %% Validation
    mIp = inputParser;
    mIp.addRequired("fcn", @(x) validateattributes(x, 'function_handle', {'numel', 1}));
    mIp.addRequired("A", @(x) validateattributes(x, {'numeric', 'string', 'char', 'cell'}, {'2d'}));
    bIdx = find(cellfun(@isnumeric, varargin));

    for n = 1:length(bIdx)
        eval(['B', num2str(bIdx(n)), '=varargin{', num2str(bIdx(n)), '};']);
        mIp.addOptional(eval(['"B', num2str(bIdx(n)), '"']), [], @(x) validateattributes(x, 'numeric', {'size', [size(A, 1), NaN]}));
    end

    mIp.addParameter("UniformOutput", true, @islogical);
    mIp.parse(fcn, A, varargin{:});

    %% Impl
    segIdx = ones(size(A, 1), 1);
    A = mat2cell(A, segIdx);
    varargin(bIdx) = cellfun(@(x) mat2cell(x, segIdx), varargin(bIdx), "UniformOutput", false);
    [varargout{1:nargout}] = cellfun(fcn, A, varargin{bIdx}, "UniformOutput", mIp.Results.UniformOutput);
    return;
end
