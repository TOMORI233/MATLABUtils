function chMean = calchMean(trialsData)
    % chMean = cell2mat(cellfun(@(x) mean(x, 1), changeCellRowNum(trialsData), "UniformOutput", false));
    chMean = squeeze(mean(cat(3, trialsData{:}), 3));
    return;
end