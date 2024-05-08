function varargout = mHistogram(varargin)
% mHistogram(X)
% mHistogram(X, edges)
% mHistogram(..., "width", barWidthVal)
% mHistogram(..., "LineWidth", barEdgeLineWidthVal)
% mHistogram(..., "EdgeColor", colorsCellArray | "none")
% mHistogram(..., "FaceColor", colorsCellArray | "none")
% mHistogram(..., "DisplayName", legendStrCellArray)
% mHistogram(..., "BinWidth", binWidthVal)
% mHistogram(..., "BinMethod", methodName)
% [H, N, edges] = mHistogram(...)
%
% Input data X can be a double vector, a double matrix or a cell vector.
% If X is a matrix, each row of X is a group.
% If X is a cell vector, each element contains a group of data (a double vector).
% Colors and legends (in cell vector) can be specified for each group.
%
% Output H is a bar array, N is histcount, edges is bin edges.
%
% Example:
%     x1 = [2 2 3 4];
%     x2 = [1 2 6 8];
%     X = [x1; x2];
%     % For x1,x2 different in size use X = [{x1}; {x2}}];
%     [H, N, edges] = mHistogram(X, "BinWidth", 1, ...
%                                   "FaceColor", {[1 0 0], [0 0 1]}, ...
%                                   "DisplayName", {'condition 1', 'condition 2'});

if strcmp(class(varargin{1}), "matlab.graphics.Graphics")
    mAxe = varargin{1};
    varargin = varargin(2:end);
else
    mAxe = gca;
end

mIp = inputParser;
mIp.addRequired("X", @(x) validateattributes(x, {'numeric', 'cell'}, {'2d'}));
mIp.addOptional("edges", [], @(x) validateattributes(x, {'numeric'}, {'vector'}));
mIp.addParameter("width", 0.8, @(x) validateattributes(x, {'numeric'}, {'>', 0, '<=', 1}));
mIp.addParameter("LineWidth", 0.5, @(x) validateattributes(x, {'numeric'}, {'positive'}));
mIp.addParameter("FaceColor", [], @(x) iscell(x) || (isscalar(x) && strcmpi(x, "none")));
mIp.addParameter("EdgeColor", [], @(x) iscell(x) || (isscalar(x) && strcmpi(x, "none")));
mIp.addParameter("DisplayName", [], @(x) iscell(x));
mIp.addParameter("BinWidth", [], @(x) validateattributes(x, {'numeric'}, {'scalar', 'positive'}));
mIp.addParameter("BinMethod", "auto", @(x) any(validatestring(x, {'auto', 'scott', 'fd', 'integers', 'sturges', 'sqrt'})));
mIp.parse(varargin{:});

X = mIp.Results.X;
edges = mIp.Results.edges;
width = mIp.Results.width;
LineWidth = mIp.Results.LineWidth;
FaceColors = mIp.Results.FaceColor;
EdgeColors = mIp.Results.EdgeColor;
legendStrs = mIp.Results.DisplayName;
BinWidth = mIp.Results.BinWidth;
BinMethod = mIp.Results.BinMethod;

if isnumeric(X)
    % Convert X to cell vector
    if isvector(X)
        X = {X(:)'};
    else
        % divide by rows
        X = mat2cell(X, ones(size(X, 1), 1));
    end

elseif iscell(X)

    if ~any(cellfun(@(x) isvector(x) && isnumeric(x), X))
        error("Each data group in X should be a numeric vector");
    end

end

if isscalar(FaceColors) && strcmpi(FaceColors, "none")
    FaceColors = repmat({'none'}, numel(X), 1);
end

if isscalar(EdgeColors) && strcmpi(EdgeColors, "none")
    EdgeColors = repmat({'none'}, numel(X), 1);
end

if ~isempty(FaceColors) && numel(FaceColors) ~= numel(X)
    error("Number of face colors should be the same as the data group number");
end

if ~isempty(EdgeColors) && numel(EdgeColors) ~= numel(X)
    error("Number of edge colors should be the same as the data group number");
end

if ~isempty(legendStrs) && numel(legendStrs) ~= numel(X)
    error("Number of legend strings should be the same as the data group number");
end

if isempty(edges)
    % trans cell array X into a numeric column vector
    X_All = cell2mat(cellfun(@(x) x(:), X(:), "UniformOutput", false));

    if isempty(BinWidth)
        [~, edges] = histcounts(X_All, "BinMethod", BinMethod);
    else
        [~, edges] = histcounts(X_All, "BinWidth", BinWidth);
    end

end

N = zeros(numel(X), length(edges) - 1);
for index = 1:numel(X)
    N(index, :) = histcounts(X{index}, edges);
end

H = bar(mAxe, edges(1:end - 1) + mode(diff(edges)) / 2, N, width, "grouped", "LineWidth", LineWidth);
for index = 1:length(H)

    if ~isempty(FaceColors) && ~isempty(FaceColors{index})
        H(index).FaceColor = FaceColors{index};
    end

    if ~isempty(EdgeColors) && ~isempty(EdgeColors{index})
        H(index).EdgeColor = EdgeColors{index};
    end

    if ~isempty(legendStrs) && ~isempty(char(legendStrs{index}))
        H(index).DisplayName = legendStrs{index};
    else
        setLegendOff(H(index));
    end

end

if ~isempty(legendStrs)
    legend(mAxe);
end

if nargout == 1
    varargout{1} = H;
elseif nargout == 2
    varargout{2} = N;
elseif nargout == 3
    varargout{3} = edges;
elseif nargout > 3
    error("Too many outputs");
end

return;
end