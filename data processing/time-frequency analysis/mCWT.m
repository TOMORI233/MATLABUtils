function [t, f, CData, coi] = mCWT(data, fs0, cwtMethod, fs, freqLimits)
    % Description: downsampling and apply cwt to data
    % Input:
    %     data: a 1*n vector
    %     fs0: sample rate of data, in Hz
    %     cwtMethod: 'morse', 'morlet', 'bump' or 'STFT'
    %     fs: downsample rate, in Hz
    %     freqLimits: frequency range of cwt (restrict f)
    % Output:
    %     t: time vector, in sec
    %     f: frequency vector, in Hz
    %     CData: spectrogram mapped in t-f domain
    %     coi: cone of influence along t
    % Example:
    %     % Plot color map and coi of cwt
    %     [t, f, CData, coi] = mCWT(data, fs0, 'morlet', fs, [0, 256]);
    %     figure;
    %     imagesc('XData', t * 1000, 'YData', f, 'CData', CData);
    %     colormap("jet");
    %     hold on;
    %     plot(t * 1000, coi, 'w--', 'LineWidth', 0.6);

    narginchk(2, 5);

    if nargin < 3
        cwtMethod = 'morlet';
    end

    if nargin < 4
        fs = 300;
    end

    if nargin < 5
        freqLimits = [0, 256];
    end

    [P, Q] = rat(fs / fs0);
    dataResample = resample(data, P, Q);

    switch cwtMethod
        case 'morse'
            [wt, f, coi] =cwt(dataResample, 'morse', fs, 'FequencyLimits', freqLimits);
        case 'morlet'
            [wt, f, coi] =cwt(dataResample, 'amor', fs, 'FequencyLimits', freqLimits);
        case 'bump'
            [wt, f, coi] =cwt(dataResample, 'bump', fs, 'FequencyLimits', freqLimits);   
        case 'STFT'
            spectrogram
        otherwise
            error('Invalid cwt method');
    end
    
    t = (1:length(dataResample)) / fs;
    CData = abs(wt);

    return;
end