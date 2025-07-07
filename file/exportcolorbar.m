function exportcolorbar(cRange, SAVEPATH, varargin)
mIp = inputParser;
mIp.addRequired("cRange", @(x) validateattributes(x, {'numeric'}, {'numel', 2, 'increasing'}));
mIp.addRequired("SAVEPATH", @(x) isStringScalar(x) || ischar(x));
mIp.addOptional("Colormap", 'jet', @(x) isStringScalar(x) || ischar(x) || (isreal(x) && isequal(size(x), [256, 3])));
mIp.addParameter("ShowZero", true, @(x) isscalar(x) && islogical(x));
mIp.addParameter("HideTicks", false, @(x) isscalar(x) && islogical(x));
mIp.addParameter("Resolution", 600, @(x) validateattributes(x, {'numeric'}, {'positive', 'integer', 'scalar'}));
mIp.parse(cRange, SAVEPATH, varargin{:});
colorMap = mIp.Results.Colormap;
ShowZero = mIp.Results.ShowZero;
HideTicks = mIp.Results.HideTicks;
Resolution = mIp.Results.Resolution;

Fig = figure("WindowState", "maximized");
ax = mSubplot(Fig, 1, 1, 1);
cb = colorbar(ax, "Location", "eastoutside");
cb.FontSize = 14;
cb.FontWeight = "bold";
clim(ax, cRange);

if ShowZero && cRange(1) < 0 && cRange(2) > 0
    cb.Ticks = [cRange(1), 0, cRange(2)];
end

if HideTicks
    cb.Ticks = [];
end

colormap(ax, colorMap);
set(ax, "Visible", "off");
exportgraphics(ax, SAVEPATH, "Resolution", Resolution);
close(Fig);

return;
end