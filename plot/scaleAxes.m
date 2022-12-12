function axisRange = scaleAxes(varargin)
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
%     symOpts: symmetrical option - "min" or "max"
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
mIp.addOptional("cutoffRange", [], @(x) validateattributes(x, 'numeric', {'2d', 'increasing'}));
mIp.addOptional("symOpts", [], @(x) any(validatestring(x, {'min', 'max'})));
mIp.parse(FigsOrAxes, varargin{:});

axisName = mIp.Results.axisName;
axisRange = mIp.Results.axisRange;
cutoffRange = mIp.Results.cutoffRange;
symOpts = mIp.Results.symOpts;


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

if  strcmpi(autoScale, "on")
    if strcmpi(axisName, "y")
        XLim = get(allAxes(1), "xlim");
        temp = getObjVal(FigsOrAxes, "line", ["XData", "YData"], "LineStyle", "-");
        if ~isempty(temp)
            temp = cellfun(@(x, y) y(x >= XLim(1) & x <= XLim(2)), {temp.XData}', {temp.YData}', "UniformOutput", false);
            limTemp = [min(cellfun(@min, temp)), max(cellfun(@max, temp))];
            axisLimMin = limTemp(1) - diff(limTemp) * 0.05;
            axisLimMax = limTemp(2) + diff(limTemp) * 0.05;
        end
    end

    if strcmpi(axisName, "c")
        XLim = get(allAxes(1), "xlim");
        temp = getObjVal(FigsOrAxes, "image", ["XData", "CData"]);
        if ~isempty(temp)
            temp = sort(cell2mat(cellfun(@(x, y) reshape(y(:, linspace(x(1), x(end), size(y, 2)) >= XLim(1) & linspace(x(1), x(end), size(y, 2)) <= XLim(2)), [], 1), {temp.XData}', {temp.CData}', "UniformOutput", false)));
            [f, xi] = ksdensity(temp, linspace(min(temp), max(temp), 200), 'Function', 'cdf', 'BoundaryCorrection', 'reflection');
            f = mapminmax(f, 0, 1);
            axisLimMin = xi(find(f >= 0.02, 1));
            axisLimMax = xi(find(f >= 0.98, 1));

        end
    end
    axisRange = [min([axisLimMin, axisLimMax]), max([axisLimMin, axisLimMax])];

else
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
    if ~isempty(symOpts)

        switch symOpts
            case "min"
                temp = min(abs(axisRange));
            case "max"
                temp = max(abs(axisRange));
            otherwise
                error("Invalid symmetrical option input");
        end

        axisRange = [-temp, temp];
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

return;
end
