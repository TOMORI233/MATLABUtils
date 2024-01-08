function smooth_signal = mGaussionFilter(signal, sigma, size)
signalTemp = signal;
if ~iscolumn(signalTemp)
    signal = signal';
end
n=ceil((size-1)/2);
signal = padarray(signal, n, "symmetric");

kernel = normpdf(-n:n, 0, sigma);
if mod(size, 2) == 0
    kernel = kernel(2:end);
    kernel = kernel./sum(kernel);
    smooth_signal = conv(signal, kernel, 'same');
    smooth_signal = smooth_signal(n:end-n-1);
else
    kernel = kernel./sum(kernel);
    smooth_signal = conv(signal, kernel, 'same');
    smooth_signal = smooth_signal(n+1:end-n);
end
if ~iscolumn(signalTemp)
    smooth_signal = smooth_signal';
end