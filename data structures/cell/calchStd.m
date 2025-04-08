function chStd = calchStd(trialsData)
    chStd = squeeze(std(cat(3, trialsData{:}), [], 3, "omitnan"));
    return;
end