function chErr = calchErr(trialsData)
    chErr = squeeze(SE(cat(3, trialsData{:}), 3));
    return;
end