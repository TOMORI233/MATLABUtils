function mAxe = mRaster(varargin)
    % Description: plot raster
    % Input:
    %     mAxe: axes target (If ignored, default = gca)
    %     rasterData: raster dataset, struct vector
    %         - X: x data, cell vector
    %         - Y: y data (If not specified, plot trial by trial)
    %         - color: scatter color
    %     sz: scatter size (default = 40)
    % Example:
    %     data(1).X = {[1, 2, 3, 4, 5]; [1.5, 2.5]}; % two trials
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
    mIp.parse(mAxe, varargin{:})

    rasterData = mIp.Results.rasterData;
    sz = mIp.Results.sz;

    nTrials = 0;
    hold(mAxe, "on");

    for index = 1:numel(rasterData)
        X = reshape(rasterData(index).X, [numel(rasterData(index).X), 1]);

        if ~isfield(X, "Y")
            Y = (nTrials + 1:nTrials + length(rasterData(index).X))';
            nTrials = nTrials + length(X);
            Y = cell2mat(rowFcn(@(x, y) repmat(y, [length(x), 1]), X, Y, "UniformOutput", false));
            X = cell2mat(cellfun(@(x) reshape(x, [length(x), 1]), X, "UniformOutput", false));
        end

        color = getOr(rasterData(index), "color", "k");
        scatter(mAxe, X, Y, sz, color, "filled");
    end

    return;
end
