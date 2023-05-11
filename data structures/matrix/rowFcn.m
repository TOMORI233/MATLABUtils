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
    mIp.addRequired("fcn", @(x) validateattributes(x, 'function_handle', {'scalar'}));
    mIp.addRequired("A", @(x) validateattributes(x, {'numeric', 'string', 'char', 'logical', 'struct'}, {'2d'}));
    bIdx = find(cellfun(@(x) strcmpi(x, 'UniformOutput'), varargin)) - 1;

    for n = 1:length(bIdx)
        eval(['B', num2str(bIdx(n)), '=varargin{', num2str(bIdx(n)), '};']);
        mIp.addOptional(eval(['"B', num2str(bIdx(n)), '"']), [], @(x) validateattributes(x, {'numeric', 'string', 'char', 'logical', 'struct'}, {'size', [size(A, 1), NaN]}));
    end

    mIp.addParameter("UniformOutput", true, @(x) isscalar(x) && (islogical(x) || ismember(x, [0, 1])));
    mIp.parse(fcn, A, varargin{:});

    %% Impl
    segIdx = ones(size(A, 1), 1);
    A = mat2cell(A, segIdx);
    varargin(bIdx) = cellfun(@(x) mat2cell(x, segIdx), varargin(bIdx), "UniformOutput", false);
    [varargout{1:nargout}] = cellfun(fcn, A, varargin{bIdx}, "UniformOutput", mIp.Results.UniformOutput);
    return;
end
