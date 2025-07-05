function exportcolorbar(cRange, SAVEPATH, varargin)
mIp = inputParser;
mIp.addRequired("cRange", @(x) validateattributes(x, {'numeric'}, {'numel', 2, 'increasing'}));
mIp.addRequired("SAVEPATH", @(x) isStringScalar(x) || ischar(x));
mIp.addOptional("Colormap", 'jet', @(x) isStringScalar(x) || ischar(x) || (isreal(x) && isequal(size(x), [256, 3])));
mIp.addParameter("ShowZero", true, @(x) isscalar(x) && islogical(x));
mIp.parse(cRange, SAVEPATH, varargin{:});
colorMap = mIp.Results.Colormap;
ShowZero = mIp.Results.ShowZero;

Fig = figure("WindowState", "maximized");
ax = mSubplot(Fig, 1, 1, 1);
cb = colorbar(ax, "Location", "eastoutside");
cb.FontSize = 14;
cb.FontWeight = "bold";
clim(ax, cRange);

cb.Ticks = [];
% if ShowZero && cRange(1) < 0 && cRange(2) > 0
%     cb.Ticks = [cRange(1), 0, cRange(2)];
% end

colormap(ax, colorMap);
set(ax, "Visible", "off");
exportgraphics(ax, SAVEPATH, "Resolution", 600);
close(Fig);

return;
end