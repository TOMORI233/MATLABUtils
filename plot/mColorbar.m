function cb = mColorbar(varargin)
% Create a colorbar outside the tightPosition("IncludeLabels", true)
% Use `colorbar` for input hint and modify function name to `mColorbar`

% Find "location" input
idx = cellfun(@(x) (ischar(x) || isStringScalar(x)) && strcmpi(x, "Location"), varargin);

if any(idx)
    loc = varargin{find(idx, 1) + 1};

    if strcmp(class(varargin{1}), "matlab.graphics.axis.Axes")
        ax = varargin{1};
    else
        ax = gca;
    end

    pos0 = tightPosition(ax, "IncludeLabels", true);
    pos = get(ax, "Position"); % axes size
    otherParams = varargin(~idx);

    switch loc
        case "northoutside"
            cb = colorbar(otherParams{:}, "Position", [pos(1), pos0(2) + pos0(4) * 1.05, pos(3), pos0(4) * 0.05]);
        case "southoutside"
            cb = colorbar(otherParams{:}, "Position", [pos(1), pos0(2) - pos0(4) * 0.1, pos(3), pos0(4) * 0.05]);
        case "eastoutside"
            cb = colorbar(otherParams{:}, "Position", [pos0(1) + pos0(3) * 1.05, pos(2), pos0(3) * 0.05, pos(4)]);
        case "westoutside"
            cb = colorbar(otherParams{:}, "Position", [pos0(1) - pos0(3) * 0.1, pos(2), pos0(3) * 0.05, pos(4)]);
    end
end

return;
end