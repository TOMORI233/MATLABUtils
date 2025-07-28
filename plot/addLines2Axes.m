function addLines2Axes(varargin)
% Description: add lines to all subplots in figures
% Input:
%     FigsOrAxes: figure object array or axes object array
%     lines: a struct array of [X],          % default = []
%                              [Y],          % default = []
%                              [color],      % default = "k"
%                              [width],      % default = 1
%                              [style],      % default = "--"
%                              [marker],     % default = "none"
%                              [markerSize], % default = 6
%                              [legend],     % default = []
%                              [label],      % default = [], for ConstantLine
%                              [labelHorizontalAlignment], % default = 'right' (|'center'|'left')
%                              [labelVerticalAlignment],   % default = 'top' (|'middle'|'bottom')
%                              [labelOrientation],         % default = 'aligned' (|'horizontal')
%                              and other namevalue pairs: valid to function plot
%     ConstantLine: if set true (default), use xline/yline to create
%                   vertical/horizontal lines when [X] or [Y] is left empty.
%     Layer: 'top' (default) or 'bottom', layer to plot lines.
%     ignoreInvisible: if set true, invisible axes in the target figure
%                      will be excluded from drawing (default=true)
% Notice:
%     If [X] or [Y] is left empty, then best x/y range will be used.
%     If [X] or [Y] contains 1 element, then the line will be vertical to x or y axis.
%     If not specified, line legend will not be shown.
% Example:
%     % Example 1: Draw lines to mark stimuli oneset and offset at t=0, t=1000 ms
%     addLines2Axes(Fig, struct("X", {0; 1000}));
%
%     % Example 2: Draw a dividing line y=x for ROC in current axes
%     syncXY(gca); % synchronize x&y range first
%     addLines2Axes(gca);

if nargin > 0 && all(isgraphics(varargin{1}))
    FigsOrAxes = varargin{1};
    varargin = varargin(2:end);
else
    FigsOrAxes = gcf;
end

mIp = inputParser;
mIp.addRequired("FigsOrAxes", @(x) all(isgraphics(x)));
mIp.addOptional("lines", [], @(x) isempty(x) || isstruct(x));
mIp.addParameter("ConstantLine", true, @(x) islogical(x) && isscalar(x));
mIp.addParameter("Layer", "top", @(x) any(validatestring(x, {'top', 'bottom'})));
mIp.addParameter("ignoreInvisible", true, @(x) isscalar(x) && islogical(x));
mIp.parse(FigsOrAxes, varargin{:});

lines = mIp.Results.lines;
ConstantLineOpt = mIp.Results.ConstantLine;
Layer = mIp.Results.Layer;
ignoreInvisible = mIp.Results.ignoreInvisible;

if isempty(lines)
    lines.X = [];
    lines.Y = [];
end

if strcmp(class(FigsOrAxes), "matlab.ui.Figure") || strcmp(class(FigsOrAxes), "matlab.graphics.Graphics")
    allAxes = findobj(FigsOrAxes, "Type", "axes");
else
    allAxes = FigsOrAxes;
end

if ignoreInvisible
    % exclude invisible axes
    allAxes(cellfun(@(x) eq(x, matlab.lang.OnOffSwitchState.off), {allAxes.Visible}')) = [];
end

%% Plot lines
for lIndex = 1:length(lines)

    for aIndex = 1:length(allAxes)
        hold(allAxes(aIndex), "on");
        X = getOr(lines(lIndex), "X");
        Y = getOr(lines(lIndex), "Y");
        legendStr  = getOr(lines(lIndex), "legend");
        color      = getOr(lines(lIndex), "color",      getOr(lines(1), "color", "k"),     true);
        lineWidth  = getOr(lines(lIndex), "width",      getOr(lines(1), "width", 1),       true);
        lineStyle  = getOr(lines(lIndex), "style",      getOr(lines(1), "style", "--"),    true);
        marker     = getOr(lines(lIndex), "marker",     getOr(lines(1), "marker", "none"), true);
        markerSize = getOr(lines(lIndex), "markerSize", getOr(lines(1), "markerSize", 6),  true);
        % for constant line
        label                    = getOr(lines(lIndex), "label");
        labelHorizontalAlignment = getOr(lines(lIndex), "labelHorizontalAlignment", getOr(lines(1), "labelHorizontalAlignment", "right"), true);
        labelVerticalAlignment   = getOr(lines(lIndex), "labelVerticalAlignment",   getOr(lines(1), "labelVerticalAlignment", "top"),     true);
        labelOrientation         = getOr(lines(lIndex), "labelOrientation",         getOr(lines(1), "labelOrientation", "aligned"),       true);

        % other namevalue pairs
        allParams = string(fieldnames(lines(lIndex)));
        builtinParams = ["X", "Y", "color", "width", "style", "marker", "markerSize", "legend", "label", ...
                         "labelHorizontalAlignment", "labelVerticalAlignment", "labelOrientation"];
        otherParams = allParams(~contains(allParams, builtinParams));
        params = {};
        for pIndex = 1:length(otherParams)
            params = [params, cellstr(otherParams{pIndex}), {lines(lIndex).(otherParams{pIndex})}];
        end

        if isempty(X) && isscalar(Y) % yline
            if ConstantLineOpt
                h = yline(allAxes(aIndex), Y, "Color", color, ...
                                              "LineWidth", lineWidth, ...
                                              "LineStyle", lineStyle, ...
                                              "Label", label, ...
                                              "LabelHorizontalAlignment", labelHorizontalAlignment, ...
                                              "LabelVerticalAlignment", labelVerticalAlignment, ...
                                              "LabelOrientation", labelOrientation, ...
                                              params{:});
            else
                X = get(allAxes(aIndex), "XLim");
                Y = repmat(Y, 1, 2);
                h = plot(allAxes(aIndex), X, Y, "Color", color, ...
                                                "Marker", marker, ...
                                                "MarkerSize", markerSize, ...
                                                "LineWidth", lineWidth, ...
                                                "LineStyle", lineStyle, ...
                                                params{:});
            end
        elseif isempty(Y) && isscalar(X) % xline
            if ConstantLineOpt
                h = xline(allAxes(aIndex), X, "Color", color, ...
                                              "LineWidth", lineWidth, ...
                                              "LineStyle", lineStyle, ...
                                              "Label", label, ...
                                              "LabelHorizontalAlignment", labelHorizontalAlignment, ...
                                              "LabelVerticalAlignment", labelVerticalAlignment, ...
                                              "LabelOrientation", labelOrientation, ...
                                              params{:});
            else
                Y = get(allAxes(aIndex), "YLim");
                X = repmat(X, 1, 2);
                h = plot(allAxes(aIndex), X, Y, "Color", color, ...
                                                "Marker", marker, ...
                                                "MarkerSize", markerSize, ...
                                                "LineWidth", lineWidth, ...
                                                "LineStyle", lineStyle, ...
                                                params{:});
            end
        elseif isempty(X) && isempty(Y) % diagonal
            X = get(allAxes(aIndex), "XLim");
            Y = get(allAxes(aIndex), "YLim");
            h = plot(allAxes(aIndex), X, Y, "Color", color, ...
                                            "Marker", marker, ...
                                            "MarkerSize", markerSize, ...
                                            "LineWidth", lineWidth, ...
                                            "LineStyle", lineStyle, ...
                                            params{:});
        else % custom
            h = plot(allAxes(aIndex), X, Y, "Color", color, ...
                                            "Marker", marker, ...
                                            "MarkerSize", markerSize, ...
                                            "LineWidth", lineWidth, ...
                                            "LineStyle", lineStyle, ...
                                            params{:});
        end

        if ~isempty(legendStr)
            set(h, "DisplayName", legendStr);
            legend;
        else
            setLegendOff(h);
        end

        uistack(h, Layer);
    end

end

return;
end
