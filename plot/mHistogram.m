function H = mHistogram(varargin)
    % Input data X can be a vector or a matrix.
    % If X is a matrix, each row of X is a group.
    % Colors (in cell vector) and legends (in string vector) can be specified for each group.

    if strcmp(class(varargin{1}), "matlab.graphics.Graphics")
        mAxe = varargin{1};
        varargin = varargin(2:end);
    else
        mAxe = gca;
    end

    mIp = inputParser;
    mIp.addRequired("X", @(x) validateattributes(x, {'numeric'}, {'2d'}));
    mIp.addOptional("edges", [], @(x) validateattributes(x, {'numeric'}, {'vector'}));
    mIp.addParameter("width", 0.8, @(x) validateattributes(x, {'numeric'}, {'>', 0, '<=', 1}));
    mIp.addParameter("Color", [], @(x) iscell(x));
    mIp.addParameter("DisplayName", [], @(x) iscell(x));
    mIp.addParameter("BinWidth", [], @(x) validateattributes(x, {'numeric'}, {'scalar', 'positive'}));
    mIp.addParameter("BinMethod", "auto", @(x) any(validatestring(x, {'auto', 'scott', 'fd', 'integers', 'sturges', 'sqrt'})));
    mIp.parse(varargin{:});

    X = mIp.Results.X;
    edges = mIp.Results.edges;
    width = mIp.Results.width;
    colors = mIp.Results.Color;
    legendStrs = mIp.Results.DisplayName;
    BinWidth = mIp.Results.BinWidth;
    BinMethod = mIp.Results.BinMethod;

    if isvector(X)
        X = reshape(X, [1, numel(X)]);
    end

    if ~isempty(colors) && numel(colors) ~= size(X, 1)
        error("Number of colors should be the same as the data group number");
    end

    if ~isempty(legendStrs) && numel(legendStrs) ~= size(X, 1)
        error("Number of legend strings should be the same as the data group number");
    end
    
    if isempty(edges)

        if isempty(BinWidth)
            [~, edges] = histcounts(X, "BinMethod", BinMethod);
        else
            [~, edges] = histcounts(X, "BinWidth", BinWidth);
        end

    end

    N = zeros(size(X, 1), length(edges) - 1);
    for index = 1:size(X, 1)
        N(index, :) = histcounts(X(index, :), edges);
    end

    H = bar(mAxe, edges(1:end - 1) + mode(diff(edges)) / 2, N, width, "grouped", "EdgeColor", "none");
    for index = 1:length(H)
        
        if ~isempty(colors) && ~isempty(colors{index})
            H(index).FaceColor = colors{index};
        end

        if ~isempty(legendStrs) && ~isempty(char(legendStrs{index}))
            H(index).DisplayName = legendStrs{index};
        else
            setLegendOff(H(index));
        end

    end

    legend(mAxe);
    return;
end