function cb = mColorbar(varargin)
% Create a colorbar outside the tightPosition("IncludeLabels", true)
% Use `colorbar` for input hint and modify function name to `mColorbar`

% Find "location" input
if isempty(varargin)
    idx = [];
    ax = gca;
else
    idx = cellfun(@(x) (ischar(x) || isStringScalar(x)) && strcmpi(x, "Location"), varargin);
    
    if strcmp(class(varargin{1}), "matlab.graphics.axis.Axes")
        ax = varargin{1};
    else
        ax = gca;
    end
    
end

if any(idx)
    loc = varargin{find(idx, 1) + 1};
else
    loc = "eastoutside";
end

pos0 = tightPosition(ax, "IncludeLabels", true);
pos = get(ax, "Position"); % axes size
otherParams = varargin(~idx);

switch loc
    case "northoutside"
        cb = colorbar(otherParams{:}, "Position", [pos(1), pos0(2) + pos0(4) * 1.02, pos(3), pos0(4) * 0.025]);
    case "southoutside"
        cb = colorbar(otherParams{:}, "Position", [pos(1), pos0(2) - pos0(4) * 0.075, pos(3), pos0(4) * 0.025]);
    case "eastoutside"
        cb = colorbar(otherParams{:}, "Position", [pos0(1) + pos0(3) * 1.02, pos(2), pos0(3) * 0.025, pos(4)]);
    case "westoutside"
        cb = colorbar(otherParams{:}, "Position", [pos0(1) - pos0(3) * 0.075, pos(2), pos0(3) * 0.025, pos(4)]);
end

return;
end