function setAxeStyle(target, varargin)
narginchk(0, inf);

if nargin < 1
    target = gca;
end

if strcmp(class(target), "matlab.ui.Figure") || strcmp(class(target), "matlab.graphics.Graphics")
    target = findobj(target(:), "Type", "axes");
else
    target = target(:);
end

set(target, "TickDir", "out");
set(target, "TickLength", [0.01, 0.01]);
set(target, "FontName", "Arial");
set(target, "FontSize", 7);
set(target, "FontWeight", "bold");
set(target, "Box", "off");
set(target, "LineWidth", 0.75);
set(target, "XColor", [0, 0, 0]);
set(target, "YColor", [0, 0, 0]);

for index = 1:2:nargin - 1
    set(target, varargin{index}, varargin{index + 1});
end

return;
end