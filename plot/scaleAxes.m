function varargout = scaleAxes(varargin)
% scaleAxes(axisName)
% scaleAxes(axisName, axisRange)
% scaleAxes(axisName, axisRange, cutoffRange)
% scaleAxes(axisName, axisRange, cutoffRange, symOpt)
% scaleAxes(axisName, autoScale, cutoffRange, symOpt)
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
%     uiOpt: "show" or "hide", call a UI control for scaling (default="hide")
%     ignoreInvisible: if set true, invisible axes in the target figure
%                      will be excluded from scaling (default=true)
%     autoTh: threshold for auto scaling (default=0.01)
%             To reserve all values within current axis range, set autoTh=0
% Output:
%     axisRange: axis limits applied

if nargin > 0 && all(isgraphics(varargin{1}), "all")
    FigsOrAxes = varargin{1};
    varargin = varargin(2:end);
else
    FigsOrAxes = gcf;
end

autoScale = "off";

if length(varargin) > 1

    if isequal(varargin{2}, "on") || isequal(varargin{2}, "off")
        autoScale = varargin{2};
        varargin(2) = [];
    end

end

mIp = inputParser;
mIp.addRequired("FigsOrAxes", @(x) all(isgraphics(x), "all"));
mIp.addOptional("axisName", "y", @(x) any(validatestring(x, {'x', 'y', 'z', 'c'})));
mIp.addOptional("axisRange", [], @(x) validateattributes(x, 'numeric', {'2d', 'increasing'}));
mIp.addOptional("cutoffRange0", [], @(x) validateattributes(x, 'numeric', {'2d', 'increasing'}));
mIp.addOptional("symOpts0", [], @(x) any(validatestring(x, {'none', 'min', 'max', 'positive', 'negative'})));
mIp.addParameter("cutoffRange", [], @(x) validateattributes(x, 'numeric', {'2d', 'increasing'}));
mIp.addParameter("symOpt", [], @(x) any(validatestring(x, {'none', 'min', 'max', 'positive', 'negative'})));
mIp.addParameter("uiOpt", "hide", @(x) any(validatestring(x, {'show', 'hide'})));
mIp.addParameter("ignoreInvisible", true, @(x) isscalar(x) && islogical(x));
mIp.addParameter("autoTh", 0.01, @(x) validateattributes(x, {'numeric'}, {'scalar', 'real', '<=' 1, '>=', 0}));
mIp.parse(FigsOrAxes, varargin{:});

axisName = mIp.Results.axisName;
axisRange = mIp.Results.axisRange;
cutoffRange = getOr(mIp.Results, "cutoffRange0", mIp.Results.cutoffRange, true);
symOpt = getOr(mIp.Results, "symOpts0", mIp.Results.symOpt, true);
uiOpt = mIp.Results.uiOpt;
ignoreInvisible = mIp.Results.ignoreInvisible;
autoTh = mIp.Results.autoTh;

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
    allAxes = findobj(FigsOrAxes(:), "Type", "axes");
else
    allAxes = FigsOrAxes(:);
end

if ignoreInvisible
    % exclude invisible axes
    allAxes(cellfun(@(x) eq(x, matlab.lang.OnOffSwitchState.off), {allAxes.Visible}')) = [];
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
        xRange = get(allAxes(1), "XLim");

        % search for all children in axes
        children = get(allAxes, "Children");

        if isscalar(allAxes)
            children = {children};
        end
        
        tempX = cellfun(@(x) arrayfun(@(y) get(y, "XData"), x, "UniformOutput", false, "ErrorHandler", @mErrorFcn), children, "UniformOutput", false);
        tempY = cellfun(@(x) arrayfun(@(y) get(y, "YData"), x, "UniformOutput", false, "ErrorHandler", @mErrorFcn), children, "UniformOutput", false);
        tempX = cat(1, tempX{:});
        tempY = cat(1, tempY{:});
        tempX = cellfun(@(x) x(:), tempX, "UniformOutput", false);
        tempY = cellfun(@(x) x(:), tempY, "UniformOutput", false);
        tempX = cat(1, tempX{:});
        tempY = cat(1, tempY{:});
        tempY = tempY(tempX >= xRange(1) & tempX <= xRange(2));
        if ~isempty(tempY)
            limTemp = [min(tempY), max(tempY)];
            axisLimMin = limTemp(1) - diff(limTemp) * autoTh;
            axisLimMax = limTemp(2) + diff(limTemp) * autoTh;
        end

    end

    if strcmpi(axisName, "c")
        xRange = get(allAxes(1), "XLim");
        yRange = get(allAxes(1), "YLim");
        temp = getObjVal(allAxes, "image", ["XData", "YData", "CData"]);

        if ~isempty(temp)
            temp = arrayfun(@(x) x.CData(x.YData >= yRange(1) & x.YData <= yRange(2), x.XData >= xRange(1) & x.XData <= xRange(2)), temp, "UniformOutput", false);
            temp = cellfun(@(x) x(:), temp, "UniformOutput", false);
            temp = cat(1, temp{:});
            temp(isnan(temp)) = [];
            temp = sort(temp, "ascend");
            maxBinCount = numel(temp) / 100;
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
            axisLimMin = xi(find(f >= autoTh, 1));
            axisLimMax = xi(find(f >= 1 - autoTh, 1));
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
if ~isempty(symOpt) && ~strcmpi(symOpt, "none")

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
        warning("Axis range are all positive or negative");
    end

end

%% Set axis range
for aIndex = 1:length(allAxes)

    if length(unique(axisRange)) > 1
        set(allAxes(aIndex), axisLimStr, axisRange);
    else
        warning('No suitable range found.');
    end

end

%% Call scaleAxes UI
if strcmpi(uiOpt, "show")
    scaleAxesApp(allAxes, axisName, double(axisRange), double([axisRange(1) - 0.25 * diff(axisRange), axisRange(2) + 0.25 * diff(axisRange)]));
    drawnow;
end

if nargout == 1
    varargout{1} = axisRange;
elseif nargout > 1
    error("scaleAxes(): the number of output should be no greater than 1");
end

return;
end