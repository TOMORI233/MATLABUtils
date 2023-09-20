function h = mHist(data, edge, binSize)
    % [edge(idx) - binSize / 2, edge(idx) + binSize / 2)
    h = zeros(length(edge), 1);

    for index = 1:length(edge)
        h(index) = length(find(data >= edge(index) - binSize / 2 & data < edge(index) + binSize / 2));
    end

    return;
end
