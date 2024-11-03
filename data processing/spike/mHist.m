function counts = mHist(data, edge, binSize)
    % [edge(idx) - binSize / 2, edge(idx) + binSize / 2)

    if isempty(data)
        counts = zeros(length(edge), 1);
        return;
    end

    if isreal(data) && isvector(data)
        leftBorder = edge(:) - binSize / 2;
        rightBorder = edge(:) + binSize / 2;

        try
            % O(1)
            data = repmat(data(:)', [numel(edge), 1]);
            res = data >= leftBorder & data < rightBorder;
            counts = sum(res, 2);
        catch
            % large data
            % O(n)
            counts = zeros(length(edge), 1);

            for index = 1:length(edge)
                counts(index) = sum(data(:) >= leftBorder(index) & data(:) < rightBorder(index));
            end

        end

    else
        error("data should be a vector");
    end

    return;
end
