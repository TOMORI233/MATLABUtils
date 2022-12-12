function addLegend2Fig(Fig, legendStr, varargin)

%% Validate input
mInputParser = inputParser;
mInputParser.addRequired("Fig", @(x) all(isgraphics(x)));
mInputParser.addRequired("legendStr",  @(x) all(isstring(x)));
mInputParser.addOptional("legendSize", [0.9, 0.05], @(x) validateattributes(x, {'numeric'}, {'2d'}));
mInputParser.addOptional("legendPos", "top", @(x) any(validatestring(x, {'left', 'right', 'bottom', 'top'})));

mInputParser.parse(Fig, legendStr, varargin{:});
legendSize = mInputParser.Results.legendSize;
legendPos = mInputParser.Results.legendPos;

orderLine(Fig, "LineStyle", "--", "bottom");

for fIndex = 1 : length(Fig)
    Fig(fIndex).Units = "normalized";
    Axes = findobj(Fig(fIndex), "Type", "axes");
    axesPos = cell2mat({Axes.Position}');
    temp = diff(unique(axesPos(:, 2)));
    Axes_and_Margin_X = temp(1);
    temp = diff(unique(axesPos(:, 1)));
    Axes_and_Margin_Y = temp(1);
    posTemp = axesPos;
    switch string(legendPos)
        case "left"
            Space = legendSize(1)+0.01;
            temp = linspace(Space+min(axesPos(:, 1)), max(axesPos(:, 1))+Axes_and_Margin_X, length(unique(axesPos(:, 1)))+1)';
            posTemp(:, 1) = flip(repmat(temp(1:end-1), length(unique(axesPos(:, 1))), 1));
            posTemp(:, 3)  = posTemp(:, 3) /Axes_and_Margin_X * abs(diff(temp(1:2)));
            for aIndex = 1 : length(Axes)
                Axes(aIndex).Position = posTemp(aIndex, :);
            end
            AxesLegend = subplot( "position", [0.005, (1-legendSize(2))/2, legendSize(1), legendSize(2)]);
        case "right"
            Space = legendSize(1)+0.01;
            temp = linspace(min(axesPos(:, 1)), max(axesPos(:, 1))+Axes_and_Margin_X - Space, length(unique(axesPos(:, 1)))+1)';
            posTemp(:, 1) = flip(repmat(temp(1:end-1), length(unique(axesPos(:, 1))), 1));
            posTemp(:, 3)  = posTemp(:, 3) /Axes_and_Margin_X * abs(diff(temp(1:2)));
            for aIndex = 1 : length(Axes)
                Axes(aIndex).Position = posTemp(aIndex, :);
            end
            AxesLegend = subplot( "position", [1-0.005-legendSize(1), (1-legendSize(2))/2, legendSize(1), legendSize(2)]);
        case "top"
            Space = legendSize(2)+0.01;
            temp = linspace(min(axesPos(:, 2)), max(axesPos(:, 2))+Axes_and_Margin_Y -Space, length(unique(axesPos(:, 2)))+1);
            posTemp(:, 2) = reshape(repmat(temp(1:end-1), length(unique(axesPos(:, 2))), 1), [], 1);
            posTemp(:, 4)  = posTemp(:, 4) /Axes_and_Margin_Y * abs(diff(temp(1:2)));
            for aIndex = 1 : length(Axes)
                Axes(aIndex).Position = posTemp(aIndex, :);
            end
            AxesLegend = subplot( "position", [0.5-legendSize(1)/2, 1-1.01 * legendSize(2), legendSize(1), legendSize(2)]);
        case "bottom"
            Space = legendSize(2)+0.01;
            temp = linspace(Space+min(axesPos(:, 2)), max(axesPos(:, 2))+Axes_and_Margin_Y, length(unique(axesPos(:, 2)))+1);
            posTemp(:, 2) = reshape(repmat(temp(1:end-1), length(unique(axesPos(:, 2))), 1), [], 1);
            posTemp(:, 4)  = posTemp(:, 4) /Axes_and_Margin_Y * abs(diff(temp(1:2)));
            for aIndex = 1 : length(Axes)
                Axes(aIndex).Position = posTemp(aIndex, :);
            end
            AxesLegend = subplot( "position", [0.5-legendSize(1)/2, 0.005, legendSize(1), legendSize(2)]);
    end

    set(AxesLegend, "Visible", "off");
    for dIndex = 1 : length(legendStr)
        Axes(1).Children(end-dIndex).DisplayName = legendStr(dIndex);
    end
    legend(AxesLegend, flip(Axes(1).Children(1 : end-1)), "NumColumns", ceil(length(legendStr)), "FontSize", 10);

end
end