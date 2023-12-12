function chMean = calchMean(trialsData)
    chMean = squeeze(mean(cat(3, trialsData{:}), 3));
    return;
end