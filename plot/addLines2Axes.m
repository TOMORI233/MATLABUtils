function addLines2Axes(varargin)
    % Description: add lines to all subplots in figures
    % Input:
    %     FigsOrAxes: figure object array or axes object array
    %     lines: a struct array of [X], [Y], [color], [width], [style], [marker] and [legend]
    %            If [X] or [Y] is left empty, then best x/y range will be
    %            used.
    %            If [X] or [Y] contains 1 element, then the line will be
    %            vertical to x or y axis.
    %            If not specified, line color will be black.
    %            If not specified, line width will be 1.
    %            If not specified, line style will be dash line("--").
    %            If specified, marker option will replace line style option.
    %            If not specified, line legend will not be shown.
    % Example:
    %     % Example 1: Draw lines to mark stimuli oneset and offset at t=0, t=1000 ms
    %     scaleAxes(Fig, "y"); % apply the same ylim to all axes
    %     lines(1).X = 0;
    %     lines(2).X = 1000;
    %     addLines2Axes(Fig, lines);
    %
    %     % Example 2: Draw a dividing line y=x for ROC
    %     addLines2Axes(Fig);

    if nargin > 0 && all(isgraphics(varargin{1}))
        FigsOrAxes = varargin{1};
        varargin = varargin(2:end);
    else
        FigsOrAxes = gcf;
    end

    mIp = inputParser;
    mIp.addRequired("FigsOrAxes", @(x) all(isgraphics(x)));
    mIp.addOptional("lines", [], @(x) isempty(x) || isstruct(x));
    mIp.parse(FigsOrAxes, varargin{:});

    lines = mIp.Results.lines;

    if isempty(lines)
        lines.X = [];
        lines.Y = [];
    end

    if strcmp(class(FigsOrAxes), "matlab.ui.Figure") || strcmp(class(FigsOrAxes), "matlab.graphics.Graphics")
        allAxes = findobj(FigsOrAxes, "Type", "axes");
    else
        allAxes = FigsOrAxes;
    end

    %% Plot lines
    for lIndex = 1:length(lines)

        for aIndex = 1:length(allAxes)
            hold(allAxes(aIndex), "on");
            X = getOr(lines(lIndex), "X");
            Y = getOr(lines(lIndex), "Y");
            legendStr = getOr(lines(lIndex), "legend");
            color     = getOr(lines(lIndex), "color",  getOr(lines(1), "color", "k"),  true);
            lineWidth = getOr(lines(lIndex), "width",  getOr(lines(1), "width", 1),    true);
            lineStyle = getOr(lines(lIndex), "style",  getOr(lines(1), "style", "--"), true);
            marker    = getOr(lines(lIndex), "marker", getOr(lines(1), "marker"));

            if numel(X) == 0
                X = get(allAxes(aIndex), "xlim");
            elseif numel(X) == 1
                X = X * ones(1, 2);
            end

            if numel(Y) == 0
                Y = get(allAxes(aIndex), "ylim");
            elseif numel(Y) == 1
                Y = Y * ones(1, 2);
            end

            if isempty(marker)
                h = plot(allAxes(aIndex), X, Y, "Color", color, "LineWidth", lineWidth, "LineStyle", lineStyle);
            else
                h = plot(allAxes(aIndex), X, Y, "Color", color, "Marker", marker, "LineStyle", "none");
            end

            if ~isempty(legendStr)
                set(h, "DisplayName", legendStr);
                legend;
            else
                set(get(get(h, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
            end
        end

    end

    return;
end
