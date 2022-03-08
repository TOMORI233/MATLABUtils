function result = NormalizeFR(data, normalizationSettings)
    result = [];

    edge = normalizationSettings.baselineWindow; % ms
    binSize = edge(2) - edge(1); % ms
    spike = cell2mat(data.raster);

    baselineFR = length(find(spike >= edge(1) & spike <= edge(2))) / length(data.raster) / (binSize / 1000);

    result = data.FR / baselineFR;

    return;

end
