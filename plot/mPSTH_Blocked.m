function mPSTH_Blocked(varargin)
if nargin > 1 && all(all(isgraphics(varargin{1})))
    FigsOrAxes = varargin{1};
    cellData   = varargin{2};
    PSTHWin    = varargin{3};
    binsize    = varargin{4};
    binstep    = varargin{5};
    varargin   = varargin(3:end);
else
    figure;
    FigsOrAxes = gcf;
    cellData   = varargin{1};
    PSTHWin    = varargin{2};
    binsize    = varargin{3};
    binstep    = varargin{4};
    varargin   = varargin(2:end);
end

mIp = inputParser;
mIp.addRequired("FigsOrAxes", @(x) all(isgraphics(x)));
mIp.addRequired("cellData", @iscell);
mIp.addRequired("PSTHWin", @isnumeric);
mIp.addRequired("binsize", @isnumeric);
mIp.addRequired("binstep", @isnumeric);
mIp.addParameter("color", "#000000");
mIp.addParameter("labelStr", []);
mIp.parse(FigsOrAxes, cellData, varargin{:});

color = mIp.Results.color;
if isnumeric(color) && size(color, 1) ~= size(cellData, 2)
        color = color(:);
        color = reshape(repmat(color(1:3), size(cellData, 2), 1), [3, inf])';
elseif isstring(color) && length(color) ~= size(cellData, 2)
        color = repmat(color(1), size(cellData, 2));
end

labelStr = flip(mIp.Results.labelStr);

cellData = flipud(cellData);
[PSTH, t]  = cellfun(@(x) calPSTH(x, PSTHWin, binsize, binstep), cellData, "UniformOutput", false);
yStep  = max(max(cellfun(@(x) max(abs(x)), PSTH)));
for i = 1 :size(PSTH, 1)
    for j = 1 :size(PSTH, 2)
        psthPlot = PSTH{i, j} + yStep*(i-1);
        if ~isnumeric(color)
            plot(t{1}, psthPlot, "LineStyle", "-", "Color", mHex2Dec(color(j))/255); hold on;
        else
            plot(t{1}, psthPlot, "LineStyle", "-", "Color", color(j, :)); hold on;
        end
    end
end

yLine = 0+yStep:yStep:i*yStep;
yTick = yLine - yStep/2;
for yIndex = 1 : length(yLine)-1
    plot(PSTHWin, repmat(yLine(yIndex), 1, 2), "k-", "LineWidth", 1); hold on;
end
yticks(yTick);
if ~isempty(labelStr)
    yticklabels(labelStr);
else
    yticklabels(string(yTick));
end
xlim(PSTHWin);
ylim([0, yLine(end)]);
set(gca, "box", "on");



