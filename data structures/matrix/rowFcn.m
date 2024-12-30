function varargout = rowFcn(fcn, A, varargin)
% Description: apply fcn along the first dimension of [A] (based on cellfun)
% Notice:
%     Inputs can be all data type valid for mat2cell().
%     Cell arrays can also be segmented by mat2cell().
% Input:
%     fcn: function handle, function to apply to each row
%     A: a N-D data of any type
%     B1,...,Bn: same as [A]
%     "UniformOutput": true/false (default=true)
%     "ErrorHandler": function handle of error
% Output:
%     When "UniformOutput" is set false, return size(A,1)*1 cell with results of fcn(a,...)
%     When "UniformOutput" is set true, return size(A,1)*1 vector
% Example:
%     C = rowFcn(@mFcn, A, B, "UniformOutput", false);

%% Validation
mIp = inputParser;
mIp.addRequired("fcn", @(x) validateattributes(x, 'function_handle', {'scalar'}));
mIp.addRequired("A");

if isempty(find(cellfun(@(x) all(strcmpi(x, "UniformOutput") | strcmpi(x, "ErrorHandler")), varargin), 1))
    bIdx = 1:length(varargin);
else
    bIdx = 1:find(cellfun(@(x) all(strcmpi(x, "UniformOutput") | strcmpi(x, "ErrorHandler")), varargin), 1) - 1;
end

for n = 1:length(bIdx)
    eval(['B', num2str(bIdx(n)), '=varargin{', num2str(bIdx(n)), '};']);
    mIp.addOptional(eval(['"B', num2str(bIdx(n)), '"']), [], @(x) size(x, 1) == size(A, 1));
end

mIp.addParameter("UniformOutput", true, @(x) isscalar(x) && (islogical(x) || ismember(x, [0, 1])));
mIp.addParameter("ErrorHandler", [], @(x) isscalar(x) && isa(x, "function_handle"));
mIp.parse(fcn, A, varargin{:});

%% Impl
segIdx = ones(size(A, 1), 1);
A = mat2cell(A, segIdx);
varargin(bIdx) = cellfun(@(x) mat2cell(x, segIdx), varargin(bIdx), "UniformOutput", false);
if isempty(mIp.Results.ErrorHandler)
    [varargout{1:nargout}] = cellfun(fcn, ...
                                     A, varargin{bIdx}, ...
                                     "UniformOutput", mIp.Results.UniformOutput);
else
    [varargout{1:nargout}] = cellfun(fcn, ...
                                     A, varargin{bIdx}, ...
                                     "UniformOutput", mIp.Results.UniformOutput, ...
                                     "ErrorHandler", mIp.Results.ErrorHandler);
end

return;
end
