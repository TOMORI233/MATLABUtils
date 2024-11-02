function counts = mHist(data, edge, binSize)
    % [edge(idx) - binSize / 2, edge(idx) + binSize / 2)

    if isreal(data) && isvector(data)
        data = repmat(data(:)', [numel(edge), 1]);
        leftBorder = edge(:) - binSize / 2;
        rightBorder = edge(:) + binSize / 2;
        res = data >= leftBorder & data < rightBorder;
        counts = sum(res, 2);
    else
        error("data should be a vector");
    end

    return;
end
