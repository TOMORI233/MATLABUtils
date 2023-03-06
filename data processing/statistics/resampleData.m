function dataResample = resampleData(data, fs0, fs)
    % Required: Signal Processing Toolbox for resample.m
    [P, Q] = rat(fs / fs0);
    dataResample = resample(data, P, Q);
    return;
end