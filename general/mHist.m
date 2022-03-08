function h = mHist(data, edge, binSize)
    h = [];

    for index = 1:length(edge)
        h = [h; length(find(data >= edge(index) - binSize / 2 & data < edge(index) + binSize / 2))];
    end

    return;
end
