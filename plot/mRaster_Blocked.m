function mRaster_Blocked(varargin)
if nargin > 1 && all(all(isgraphics(varargin{1})))
    FigsOrAxes = varargin{1};
    cellData   = varargin{2};
    varargin = varargin(3:end);
else
    figure;
    FigsOrAxes = gcf;
    cellData   = varargin{1};
    varargin = varargin(2:end);
end

mIp = inputParser;
mIp.addRequired("FigsOrAxes", @(x) all(isgraphics(x)));
mIp.addRequired("cellData", @iscell);
mIp.addParameter("color", "#000000");
mIp.addParameter("labelStr", []);
mIp.addParameter("window", []);
mIp.addParameter("scatterSize", 3)
mIp.parse(FigsOrAxes, cellData, varargin{:});

color = mIp.Results.color;
labelStr = mIp.Results.labelStr;
window = mIp.Results.window;
scatterSize = mIp.Results.scatterSize;

cellData = cellfun(@(x) flipud(x), cellData, "UniformOutput", false);
for i = 1:size(cellData, 2)
    dataTemp = cellData(:, i);
    spikePlot = cell2mat(cellfun(@(x, y) [x, ones(size(x))*y], mCell2mat(dataTemp), num2cell(1:sum(cellfun(@length, dataTemp)))', "UniformOutput", false));
    yLine = [0; cumsum(cellfun(@length, dataTemp))];
    yTick = mean([yLine(1:end-1), yLine(2:end)], 2);
    if ~isnumeric(color)
        scatter(spikePlot(:, 1), spikePlot(:, end), scatterSize, mHex2Dec(color(i))/255, 'filled'); hold on;
    else
        scatter(spikePlot(:, 1), spikePlot(:, end), scatterSize, mHex2Dec(color), 'filled'); hold on;
    end
end

if isempty(window); window = get(gca, "XLim"); end
for yIndex = 1 : length(yLine)-2
    plot(window, repmat(yLine(yIndex+1), 1, 2), "k-", "LineWidth", 1); hold on;
end
set(gca, "YDir", "reverse");
yticks(yTick);
if ~isempty(labelStr)
    yticklabels(labelStr);
else
    yticklabels(string(yTick));
end
xlim(window);
ylim([0, yLine(end)]);
set(gca, "box", "on");



