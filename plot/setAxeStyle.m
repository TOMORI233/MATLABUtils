function setAxeStyle(ax)
narginchk(0, 1);

if nargin < 1
    ax = gca;
end

set(ax, "TickDir", "out");
set(ax, "TickLength", [0.01, 0.01]);
set(ax, "FontName", "Arial");
set(ax, "FontSize", 14);
set(ax, "FontWeight", "bold");
set(ax, "Box", "off");
set(ax, "LineWidth", 2);
set(ax, "XColor", [0, 0, 0]);
set(ax, "YColor", [0, 0, 0]);

return;
end