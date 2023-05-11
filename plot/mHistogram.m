function [H, N, edges] = mHistogram(varargin)
    % mHistogram(X)
    % mHistogram(X, edges)
    % mHistogram(..., "width", barWidthVal)
    % mHistogram(..., "Color", colorsCellArray)
    % mHistogram(..., "DisplayName", legendStrCellArray)
    % mHistogram(..., "BinWidth", binWidthVal)
    % mHistogram(..., "BinMethod", methodName)
    % [H, N, edges] = mHistogram(...)
    %
    % Input data X can be a double vector, a double matrix or a cell vector.
    % If X is a matrix, each row of X is a group.
    % If X is a cell vector, each element contains a group of data (a double vector).
    % Colors and legends (in cell vector) can be specified for each group.
    % Example:
    %     x1 = [2 2 3 4];
    %     x2 = [1 2 6 8];
    %     X = [x1; x2];
    %     % For x1,x2 different in size use X = [{x1}; {x2}}];
    %     [H, N, edges] = mHistogram(X, "BinWidth", 1, ...
    %                                   "Color", {[1 0 0], [0 0 1]}, ...
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

    % Convert X to cell vector
    if strcmp(class(X), "double")

        if isvector(X)
            X = {reshape(X, [1, numel(X)])};
        else
            X = mat2cell(X, ones(size(X, 1), 1));
        end

    end

    if ~isempty(colors) && numel(colors) ~= numel(X)
        error("Number of colors should be the same as the data group number");
    end

    if ~isempty(legendStrs) && numel(legendStrs) ~= numel(X)
        error("Number of legend strings should be the same as the data group number");
    end
    
    if isempty(edges)
        X_All = cell2mat(cellfun(@(x) reshape(x, [numel(x), 1]), X, "UniformOutput", false));

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