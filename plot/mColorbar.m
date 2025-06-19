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
    locIdx = find(cellfun(@(x) (ischar(x) || isStringScalar(x)) && strcmpi(x, "Location"), varargin), 1);
    intervalIdx = find(cellfun(@(x) (ischar(x) || isStringScalar(x)) && strcmpi(x, "Interval"), varargin), 1);
    widthIdx = find(cellfun(@(x) (ischar(x) || isStringScalar(x)) && strcmpi(x, "Width"), varargin), 1);
    
    if strcmp(class(varargin{1}), "matlab.graphics.axis.Axes")
        ax = varargin{1};
    else
        ax = gca;
    end
    
end

if ~isempty(locIdx)
    loc = varargin{locIdx + 1};
else
    loc = "eastoutside";
end

if ~isempty(intervalIdx)
    interval = varargin{intervalIdx + 1};
else
    interval = 0.01;
end

if ~isempty(widthIdx)
    width = varargin{widthIdx+ 1};
else
    width = 0.05;
end

varargin([locIdx:locIdx + 1, intervalIdx:intervalIdx + 1, widthIdx:widthIdx + 1]) = [];

pos0 = tightPosition(ax, "IncludeLabels", true);
pos = get(ax, "Position"); % axes size

switch loc
    case "northoutside"
        cb = colorbar(varargin{:}, "Position", [pos(1), pos0(2) + pos0(4) + interval * pos(4), pos(3), width * pos(4)]);
    case "southoutside"
        cb = colorbar(varargin{:}, "Position", [pos(1), pos0(2) - interval * pos(4), pos(3), width * pos(4)]);
    case "eastoutside"
        cb = colorbar(varargin{:}, "Position", [pos0(1) + pos0(3) + interval * pos(3), pos(2), width * pos(3), pos(4)]);
    case "westoutside"
        cb = colorbar(varargin{:}, "Position", [pos0(1) - interval * pos(3), pos(2), width * pos(3), pos(4)]);
end

return;
end