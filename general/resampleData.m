function dataResample = resampleData(data, fs0, fs)
    [P, Q] = rat(fs / fs0);
    dataResample = resample(data, P, Q);
    return;
end