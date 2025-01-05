function smooth_signal = mGaussionSmth(signal, sigma, size, dim, side)
% if dim = 1, smooth by col; else smooth by row
    if numel(signal) == length(signal)
        smooth_signal = mGaussionFilter(signal, sigma, size, side);
    else
        smooth_signal = cell2mat(cellfun(@(x) mGaussionFilter(x, sigma, size, side), num2cell(signal, dim), "UniformOutput", false));
    end