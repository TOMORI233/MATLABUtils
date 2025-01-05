function smooth_signal = mGaussionFilter(signal, sigma, size,side)
 % Check if the signal is a column vector, if not transpose it
    signalTemp = signal;
    if ~iscolumn(signalTemp)
        signal = signal';
    end
    
    % Calculate the number of elements to pad on each side
    n = ceil((size - 1) / 2);
    signal_padded = padarray(signal, n, 'symmetric');
    
    % Create the Gaussian kernel based on the specified side
    if strcmpi(side, 'left')
        kernel = normpdf(-2*n:0, 0, sigma);
    elseif strcmpi(side, 'right')
        kernel = normpdf(0:2*n, 0, sigma);
    elseif strcmpi(side, 'both')
        kernel = normpdf(-n:n, 0, sigma);
    else
        error('Side must be "left", "right", or "both"');
    end
    
    kernel = kernel ./ sum(kernel); % Normalize the kernel
    
    % Apply the convolution with the adjusted kernel
    smooth_signal = conv(signal_padded, kernel, 'same');
    
    % Ensure the length of the output matches the original signal length
    smooth_signal = smooth_signal(n + 1:end - n);
    
    % Transpose the result if the input was a row vector
    if ~iscolumn(signalTemp)
        smooth_signal = smooth_signal';
    end
end