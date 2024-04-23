function syncXY(mAxe)
    % link x-y range
    narginchk(0, 1);

    if nargin < 1
        mAxe = gca;
    end

    xRange = get(mAxe, "XLim");
    yRange = get(mAxe, "YLim");
    xyRange = [min([xRange, yRange]), max([xRange, yRange])];
    set(mAxe, "XLim", xyRange);
    set(mAxe, "YLim", xyRange);
    return;
end