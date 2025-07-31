function h = addWaveErr(varargin)

if isgraphics(varargin{1}(1), "axes")
    ax = varargin{1}(1);
    varargin = varargin(2:end);
else
    ax = gca;
end

mIp = inputParser;
mIp.addRequired("ax", @(x) isgraphics(x, "axes"));
mIp.addRequired("t", @(x) validateattributes(x, 'numeric', {'vector', 'increasing'}));
mIp.addRequired("Y", @(x) validateattributes(x, 'numeric', {'vector', 'real'}));
mIp.addRequired("E", @(x) validateattributes(x, 'numeric', {'vector', 'real'}));
mIp.addOptional("C", "k");
mIp.parse(ax, varargin{:});

t = mIp.Results.t;
Y = mIp.Results.Y;
E = mIp.Results.E;
C = validatecolor(mIp.Results.C);

y1 = Y(:)' + E(:)';
y2 = Y(:)' - E(:)';
hold(ax, "on");
h = fill([t, fliplr(t)], [y1, fliplr(y2)], C, "EdgeAlpha", '0', "FaceAlpha", '0.3');
setLegendOff(h);

return;
end