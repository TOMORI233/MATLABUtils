function cb = mColorbar(varargin)
% Create a colorbar outside the tightPosition("IncludeLabels", true)
% Use `colorbar` for input hint and modify function name to `mColorbar`

% Find "location"/"interval"/"width" input
if isempty(varargin)
    locIdx = [];
    intervalIdx = [];
    widthIdx = [];
    ax = gca;
else
    locIdx = cellfun(@(x) (ischar(x) || isStringScalar(x)) && strcmpi(x, "Location"), varargin);
    intervalIdx = cellfun(@(x) (ischar(x) || isStringScalar(x)) && strcmpi(x, "Interval"), varargin);
    widthIdx = cellfun(@(x) (ischar(x) || isStringScalar(x)) && strcmpi(x, "Width"), varargin);
    
    if strcmp(class(varargin{1}), "matlab.graphics.axis.Axes")
        ax = varargin{1};
    else
        ax = gca;
    end
    
end

if any(locIdx)
    idx = find(locIdx, 1);
    loc = varargin{idx + 1};
    varargin(idx:idx + 1) = [];
else
    loc = "eastoutside";
end

if any(intervalIdx)
    idx = find(intervalIdx, 1);
    interval = varargin{idx + 1};
    varargin(idx:idx + 1) = [];
else
    interval = 0.01;
end

if any(widthIdx)
    idx = find(widthIdx, 1);
    width = varargin{idx+ 1};
    varargin(idx:idx + 1) = [];
else
    width = 0.01;
end

pos0 = tightPosition(ax, "IncludeLabels", true);
pos = get(ax, "Position"); % axes size

switch loc
    case "northoutside"
        cb = colorbar(varargin{:}, "Position", [pos(1), pos0(2) + pos0(4) + interval, pos(3), width]);
    case "southoutside"
        cb = colorbar(varargin{:}, "Position", [pos(1), pos0(2) - interval, pos(3), width]);
    case "eastoutside"
        cb = colorbar(varargin{:}, "Position", [pos0(1) + pos0(3) + interval, pos(2), width, pos(4)]);
    case "westoutside"
        cb = colorbar(varargin{:}, "Position", [pos0(1) - interval, pos(2), width, pos(4)]);
end

return;
end