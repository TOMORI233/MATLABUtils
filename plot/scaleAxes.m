function axisRange = scaleAxes(varargin)
% scaleAxes(axisName)
% scaleAxes(axisName, axisRange)
% scaleAxes(axisName, axisRange, cutoffRange)
% scaleAxes(axisName, axisRange, cutoffRange, symOpt)
% scaleAxes(axisName, autoScale, axisRange, ...)
% scaleAxes(..., namevalueOptions)
% scaleAxes(FigsOrAxes, ...)
% axisRange = scaleAxes(...)
%
% Description: apply the same scale settings to all subplots in figures
% Input:
%     FigsOrAxes: figure object array or axis object array
%     axisName: axis name - "x", "y", "z" or "c"
%     autoScale: "on" or "off"
%     axisRange: axis limits, specified as a two-element vector. If
%                given value -Inf or Inf, or left empty, the best range
%                will be used.
%     cutoffRange: if axisRange exceeds cutoffRange, axisRange will be
%                  replaced by cutoffRange.
%     symOpt: symmetrical option - "min" or "max"
%     type: "line" or "hist" for y scaling (default="line")
%     uiOpt: "show" or "hide", call a UI control for scaling (default="hide")
% Output:
%     axisRange: axis limits applied

if nargin > 0 && all(isgraphics(varargin{1}))
    FigsOrAxes = varargin{1};
    varargin = varargin(2:end);
else
    FigsOrAxes = gcf;
end

autoScale = "off";

if length(varargin) > 1

    if isequal(varargin{2}, "on")
        autoScale = "on";
        varargin(2) = [];
    end

end

mIp = inputParser;
mIp.addRequired("FigsOrAxes", @(x) all(isgraphics(x)));
mIp.addOptional("axisName", "y", @(x) any(validatestring(x, {'x', 'y', 'z', 'c'})));
mIp.addOptional("axisRange", [], @(x) validateattributes(x, 'numeric', {'2d', 'increasing'}));
mIp.addOptional("cutoffRange0", [], @(x) validateattributes(x, 'numeric', {'2d', 'increasing'}));
mIp.addOptional("symOpts0", [], @(x) any(validatestring(x, {'min', 'max'})));
mIp.addParameter("cutoffRange", [], @(x) validateattributes(x, 'numeric', {'2d', 'increasing'}));
mIp.addParameter("symOpt", [], @(x) any(validatestring(x, {'min', 'max', 'positive', 'negative'})));
mIp.addParameter("type", "line", @(x) any(validatestring(x, {'line', 'hist'})));
mIp.addParameter("uiOpt", "hide", @(x) any(validatestring(x, {'show', 'hide'})));
mIp.parse(FigsOrAxes, varargin{:});

axisName = mIp.Results.axisName;
axisRange = mIp.Results.axisRange;
cutoffRange = getOr(mIp.Results, "cutoffRange0", mIp.Results.cutoffRange, true);
symOpt = getOr(mIp.Results, "symOpts0", mIp.Results.symOpt, true);
type = mIp.Results.type;
uiOpt = mIp.Results.uiOpt;

if strcmpi(axisName, "x")
    axisLimStr = "xlim";
elseif strcmpi(axisName, "y")
    axisLimStr = "ylim";
elseif strcmpi(axisName, "z")
    axisLimStr = "zlim";
elseif strcmpi(axisName, "c")
    axisLimStr = "clim";
else
    error("Wrong axis name input");
end

if strcmp(class(FigsOrAxes), "matlab.ui.Figure") || strcmp(class(FigsOrAxes), "matlab.graphics.Graphics")

    allAxes = findobj(FigsOrAxes, "Type", "axes");
else
    allAxes = FigsOrAxes;
end

%% Best axis range
axisLim = get(allAxes(1), axisLimStr);
axisLimMin = axisLim(1);
axisLimMax = axisLim(2);

for aIndex = 2:length(allAxes)
    axisLim = get(allAxes(aIndex), axisLimStr);

    if axisLim(1) < axisLimMin
        axisLimMin = axisLim(1);
    end

    if axisLim(2) > axisLimMax
        axisLimMax = axisLim(2);
    end

end

if strcmpi(autoScale, "on")

    if strcmpi(axisName, "y")
        XLim = get(allAxes(1), "xlim");

        if strcmpi(type, 'line')
            temp = getObjVal(FigsOrAxes, "line", ["XData", "YData"], "LineStyle", "-");
            if ~isempty(temp)
                temp = cellfun(@(x, y) y(x >= XLim(1) & x <= XLim(2)), {temp.XData}', {temp.YData}', "UniformOutput", false);
                limTemp = [min(cell2mat(cellfun(@min, temp, "uni", false))), max(cell2mat(cellfun(@max, temp, "uni", false)))];
                axisLimMin = limTemp(1) - diff(limTemp) * 0.05;
                axisLimMax = limTemp(2) + diff(limTemp) * 0.05;
            end
        else % Histogram
            temp = getObjVal(FigsOrAxes, "Histogram", ["BinEdges", "Values"]);
            if ~isempty(temp)
                [temp.XData] = temp.BinEdges;
                [temp.YData] = temp.Values;
                temp = rmfield(temp, ["BinEdges", "Values"]);
                XData = arrayfun(@(x) x.XData(1:end - 1), temp, "UniformOutput", false);
                [temp.XData] = XData{:};
                temp = cellfun(@(x, y) y(x >= XLim(1) & x <= XLim(2))', {temp.XData}', {temp.YData}', "UniformOutput", false);
                limTemp = [min(cell2mat(temp)), max(cell2mat(temp))];
                axisLimMin = max([limTemp(1) - diff(limTemp) * 0.05, 0]);
                axisLimMax = limTemp(2) + diff(limTemp) * 0.05;
            end
        end

    end

    if strcmpi(axisName, "c")
        XLim = get(allAxes(1), "xlim");
        temp = getObjVal(FigsOrAxes, "image", ["XData", "CData"]);

        if ~isempty(temp)
            temp = sort(cell2mat(cellfun(@(x, y) reshape(y(:, linspace(x(1), x(end), size(y, 2)) >= XLim(1) & linspace(x(1), x(end), size(y, 2)) <= XLim(2)), [], 1), {temp.XData}', {temp.CData}', "UniformOutput", false)));
            maxBinCount = length(temp) / 100;
            binCount = [inf, inf];
            binN = 10;
            while any(binCount > maxBinCount)
                binN = binN * 10;
                if binN >= 1e6
                    [binCount, xi] = ksdensity(temp, linspace(min(temp), max(temp), 1e4));
                    break;
                end
                [binCount, xi] = histcounts(temp, linspace(min(temp), max(temp), binN));
            end
            f = mapminmax(cumsum(binCount), 0, 1);
            axisLimMin = xi(find(f >= 0.01, 1));
            axisLimMax = xi(find(f >= 0.99, 1));
        end

    end

end

bestRange = [min([axisLimMin, axisLimMax]), max([axisLimMin, axisLimMax])];

if isempty(axisRange)
    axisRange = bestRange;
else

    if axisRange(1) == -inf
        axisRange(1) = bestRange(1);
    end

    if axisRange(2) == inf
        axisRange(2) = bestRange(2);
    end

end

%% Cutoff axis range
if isempty(cutoffRange)
    cutoffRange = [-inf, inf];
end

if axisRange(1) < cutoffRange(1)
    axisRange(1) = cutoffRange(1);
end

if axisRange(2) > cutoffRange(2)
    axisRange(2) = cutoffRange(2);
end

%% Symmetrical axis range
if ~isempty(symOpt)

    switch symOpt
        case "min"
            temp = min(abs(axisRange));
        case "max"
            temp = max(abs(axisRange));
        case "positive"
            temp = abs(max(axisRange(axisRange > 0)));
        case "negative"
            temp = abs(min(axisRange(axisRange < 0)));
        otherwise
            error("Invalid symmetrical option input");
    end

    if ~isempty(temp)
        axisRange = [-temp, temp];
    else
        error("Axis range are all positive or negative");
    end

end

%% Set axis range
for aIndex = 1:length(allAxes)

    if length(unique(axisRange)) > 1
        set(allAxes(aIndex), axisLimStr, axisRange);
    else
        set(allAxes(aIndex), axisLimStr, [-1, 1] * min(abs(axisLim)));
    end

end

if strcmpi(uiOpt, "show")
    scaleAxesApp(allAxes, axisName, axisRange, [axisRange(1) - 0.25 * diff(axisRange), axisRange(2) + 0.25 * diff(axisRange)]);
end

return;
end