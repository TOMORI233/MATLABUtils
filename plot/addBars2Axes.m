function varargout = addBars2Axes(varargin)
% Description:
%     This function adds significant areas to axes (vertical bars).
% Input:
%     - ax: target axes (default: gca)
%     - xval: X values, real vector
%     - color: color of bars (default: "k")
%     - alpha: Face alpha value of bars (default: 0.1)
% Output:
%     - h: bar object

if isgraphics(varargin{1}, "axes")
    ax = varargin{1};
    varargin = varargin(2:end);
else
    ax = gca;
end

mIp = inputParser;
mIp.addRequired("ax", @(x) all(isgraphics(x)));
mIp.addRequired("xval", @(x) isvector(x) & isreal(x));
mIp.addOptional("color", "k", @(x) true);
mIp.addOptional("alpha", 0.1, @(x) validateattributes(x, {'numeric'}, {'scalar', '<=', 1, ">=", 0}));
mIp.parse(ax, varargin{:});

xval = mIp.Results.xval;
color = validatecolor(mIp.Results.color);
FaceAlpha = mIp.Results.alpha;

if isempty(xval)
    varargout{1} = [];
    return;
end

children = get(ax, "Children");
xdata = [];
for index = 1:length(children)
    try
        temp = get(children(index), "XData");
        xdata = [xdata; temp(:)];
    end
end
xdata = unique(xdata);

yRange = get(ax, "YLim");
width = min(diff(xdata));

if yRange(1) >= 0 % all positive
    h = bar(ax, xval, ones(numel(xval), 1) * yRange(2), width, "FaceColor", color, "FaceAlpha", FaceAlpha, "EdgeColor", "none");
elseif yRange(2) <= 0 % all negative
    h = bar(ax, xval, ones(numel(xval), 1) * yRange(1), width, "FaceColor", color, "FaceAlpha", FaceAlpha, "EdgeColor", "none");
else
    h(1) = bar(ax, xval, ones(numel(xval), 1) * yRange(1), width, "FaceColor", color, "FaceAlpha", FaceAlpha, "EdgeColor", "none");
    h(2) = bar(ax, xval, ones(numel(xval), 1) * yRange(2), width, "FaceColor", color, "FaceAlpha", FaceAlpha, "EdgeColor", "none");
end

setLegendOff(h);

if nargout == 1
    varargout{1} = h;
elseif nargout > 1
    error("Unspecified output arg");
end

return;
end