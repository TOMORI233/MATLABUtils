function addSpecialTicks(varargin)
% addSpecialTick(ax, axisName, vals, labelStrs)

if strcmp(class(varargin{1}), "matlab.graphics.axis.Axes")
    ax = varargin{1};
    varargin = varargin(2:end);
else
    ax = gca;
end

axisName = upper(varargin{1});
vals = varargin{2};

if numel(varargin) < 3
    labelStrs = cellstr(num2str(vals(:)));
else
    labelStrs = cellstr(varargin{3});
end

if numel(vals) ~= numel(labelStrs)
    error("The number of labels does not match the number of special ticks");
end

for index = 1:numel(vals)
    tickVals = get(ax, strcat(axisName, "Tick"));
    tickLabels = get(ax, strcat(axisName, "TickLabels"));

    idx = find(tickVals > vals(index), 1);

    if ~isempty(idx)
        tickVals = [tickVals(1:idx - 1), vals(index), tickVals(idx:end)];
        tickLabels = [tickLabels(1:idx - 1); labelStrs(index); tickLabels(idx:end)];
    else
        tickVals = [tickVals, vals(index)];
        tickLabels = [tickLabels; labelStrs(index)];
    end

    set(ax, strcat(axisName, "Tick"), tickVals);
    set(ax, strcat(axisName, "TickLabels"), tickLabels);
end

return;
end