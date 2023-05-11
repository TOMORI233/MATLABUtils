function mAxe = mRaster(varargin)

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

    for index = 1:length(rasterData)
        X = rasterData(index).X;
        Y = getOr(rasterData(index), "Y", (nTrials + 1:nTrials + length(rasterData(index).X))');
        
        nTrials = nTrials + length(X);
        Y = cell2mat(rowFcn(@(x, y) repmat(y, [length(x), 1]), X, Y, "UniformOutput", false));
        X = cell2mat(cellfun(@(x) reshape(x, [length(x), 1]), X, "UniformOutput", false));
        
        color = getOr(rasterData(index), "color", "k");
        scatter(mAxe, X, Y, sz, color, "filled");
    end
    
    return;
end