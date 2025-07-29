function mAxe = mRaster(varargin)
% Description: plot raster
% Input:
%     mAxe: axes target (If ignored, default = gca)
%     rasterData: raster dataset, struct vector
%         - X: x data, cell vector
%         - Y: y data (If not specified, plot trial by trial)
%         - color: scatter color (default="k")
%         - marker: marker shape (default="o")
%         - lines: lines to add to scatterplot (see addLines2Axes.m)
%     sz: scatter size (default=40)
%     border: show borders between groups (default=false)
% Example:
%     data(1).X = {[1, 2, 3, 4, 5]; []; [1.5, 2.5]}; % three trials
%     data(1).color = [1 0 0];
%     data(2).X = {[2, 4, 6]}; % one trial
%     data(2).color = [0 0 1];
%     mRaster(data, 20);

if isgraphics(varargin{1}(1), "axes")
    mAxe = varargin{1}(1);
    varargin = varargin(2:end);
else
    mAxe = gca;
end

mIp = inputParser;
mIp.addRequired("mAxe", @(x) isgraphics(x, "axes"));
mIp.addRequired("rasterData", @isstruct);
mIp.addOptional("sz", 40, @(x) validateattributes(x, {'numeric'}, {'scalar', 'positive', 'integer'}));
mIp.addParameter("border", false, @(x) isscalar(x) && islogical(x));
mIp.parse(mAxe, varargin{:})

rasterData = mIp.Results.rasterData;
sz = mIp.Results.sz;
border = mIp.Results.border;

nTrials = 0;
hold(mAxe, "on");

for index = 1:numel(rasterData)
    X = rasterData(index).X(:);

    if ~isfield(rasterData(index), "Y")
        Y = mat2cell((nTrials + 1:nTrials + numel(rasterData(index).X))', ones(numel(rasterData(index).X), 1));
        nTrials = nTrials + length(X);
        Y = cell2mat(cellfun(@(x, y) repmat(y, [length(x), 1]), X, Y, "UniformOutput", false));
        X = cellfun(@(x) x(:), X, "UniformOutput", false);
        X = cat(1, X{:});
    end

    if isempty(X) || isempty(Y)
        continue;
    end

    color = getOr(rasterData(index), "color", "k");
    marker = getOr(rasterData(index), "marker", "o");
    scatter(mAxe, X, Y, sz, "filled", ...
            "Marker", marker, ...
            "MarkerEdgeColor", "none", ...
            "MarkerFaceColor", color);

    lines = getOr(rasterData(index), "lines");
    if ~isempty(lines)
        lines = addfield(lines, "X", arrayfun(@(x) repmat(x.X, 2, 1), lines, "UniformOutput", false));
        lines = addfield(lines, "Y", repmat([min(Y), max(Y)], numel(lines), 1));
        addLines2Axes(mAxe, lines, "ConstantLine", false);
    end

    if border
        addLines2Axes(mAxe, struct("Y", max(Y) + 0.5, ...
                                   "width", 0.5, ...
                                   "style", "-", ...
                                   "color", "k"));
    end

end

set(mAxe, "XLimitMethod", "tight");
set(mAxe, "YLimitMethod", "tight");

return;
end
