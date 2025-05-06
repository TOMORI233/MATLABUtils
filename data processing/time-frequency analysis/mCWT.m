function [t, f, CData, coi] = mCWT(data, fs, cwtMethod, fsD, freqLimits)
% WARNING: This function is obsolete. Please use cwtAny instead.
warning("Function mCWT is obsolete. Please use cwtAny instead.");
% 
% Description: downsampling and apply cwt to data
% Input:
%     data: 1*n double vector
%     fs: raw sample rate of data, in Hz
%     cwtMethod: 'morse', 'morlet', 'bump' or 'STFT'
%     fsD: downsample rate, in Hz
%     freqLimits: frequency range of cwt (restrict f)
% Output:
%     t: time vector, in sec
%     f: frequency vector, in Hz
%     CData: spectrogram mapped in t-f domain
%     coi: cone of influence along t
% Example:
%     % Plot color map and coi of cwt
%     [T, F, CData, coi] = mCWT(data, fs, 'morlet', fs, [0, 256]);
%     figure;
%     imagesc('XData', T * 1000, 'YData', F, 'CData', CData);
%     colormap("jet");
%     hold on;
%     plot(T * 1000, coi, 'w--', 'LineWidth', 0.6);

narginchk(2, 5);

if ~(isrow(data) && isa(data, "double"))
    error("Input data should be a double row vector");
end

if nargin < 3
    cwtMethod = 'morlet';
end

if nargin < 4
    fsD = [];
end

if nargin < 5
    freqLimits = [0, 256];
end

if ~isempty(fsD) && fsD ~= fs
    [P, Q] = rat(fsD / fs);
    dataResample = resample(data, P, Q);
else
    fsD = fs;
    dataResample = data;
end

dataResample = double(dataResample);

switch cwtMethod
    case 'morse'
        [wt, f, coi] =cwt(dataResample, 'morse', fsD, 'FequencyLimits', freqLimits);
    case 'morlet'
        [wt, f, coi] =cwt(dataResample, 'amor', fsD, 'FequencyLimits', freqLimits);
    case 'bump'
        [wt, f, coi] =cwt(dataResample, 'bump', fsD, 'FequencyLimits', freqLimits);   
    case 'STFT'
        spectrogram(dataResample); % use hanning window
        return;
    otherwise
        error('Invalid cwt method');
end

t = (1:length(dataResample)) / fsD;
CData = abs(wt);

return;
end