function chErr = calchStd(trialsData)
    chErr = squeeze(std(cat(3, trialsData{:}), [], 3));
    return;
end