function [res, Fig] = mIFFT(signal, fs, randSeq)
narginchk(2, 3);
if isvector(signal)
    signal = signal';
end
N = length(signal); % Number of samples
N = floor(N / 2) * 2;

% fft
FFT = fft(signal, N, 2);
A_X = abs(FFT(:, 1:N / 2 + 1) / size(signal, 2));
A_X(:, 2:end - 1) = 2 * A_X(:, 2:end - 1);

% ifft
if nargin < 3
    signal_new = ifft(abs(FFT).*exp(1j*rand(1,N)*2*pi),'symmetric');
else
    signal_new = ifft(abs(FFT).*exp(1j*randSeq(1:N)*2*pi),'symmetric');
end
FFT_new = fft(signal_new, N, 2); % FFT of the ifft signal
A_X_new = abs(FFT_new(:, 1:N / 2 + 1) / size(signal_new, 2));
A_X_new(:, 2:end - 1) = 2 * A_X_new(:, 2:end - 1);

% frequency vector of N-point single-sided fft
f = linspace(0, fs / 2, N / 2 + 1);

% group signals and spectral result
res(1).info = "raw";
res(1).wave = signal;
res(1).tWave = (0 : N-1)/fs;
res(1).fft = A_X;
res(1).f = f;
res(2).info = "ifft";
res(2).wave = signal_new;
res(2).tWave = (0 : N-1)/fs;
res(2).fft = A_X_new;
res(2).f = f;
% check waveform and fft
Fig = figure;
subplot(2,2,1)
plot(f, A_X);
subplot(2,2,2)
plot(res(1).tWave, signal);
subplot(2,2,3)
plot(f, A_X); hold on
plot(f, A_X_new, 'r-');

subplot(2,2,4)
plot(res(2).tWave, signal_new)







