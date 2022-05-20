function [t, f, CData, coi] = mCWT(data, fs0, cwtMethod, fs)
    % Description: downsampling and apply cwt to data
    % Input:
    %     data: a 1*n vector
    %     fs0: sample rate of data, in Hz
    %     cwtMethod: 'morse', 'morlet', 'bump' or 'STFT'
    %     fs: downsample rate, in Hz
    % Output:
    %     t: time vector, in sec
    %     f: frequency vector, in Hz
    %     CData: spectrogram mapped in t-f domain
    %     coi: cone of influence along t

    narginchk(2, 4);

    if nargin < 3
        cwtMethod = 'morlet';
    end

    if nargin < 4
        fs = 300;
    end

    [P, Q] = rat(fs / fs0);
    dataResample = resample(data, P, Q);

    switch cwtMethod
        case 'morse'
            [wt, f, coi] =cwt(dataResample, 'morse', fs);
        case 'morlet'
            [wt, f, coi] =cwt(dataResample, 'amor', fs);
        case 'bump'
            [wt, f, coi] =cwt(dataResample, 'bump', fs);   
        case 'STFT'
            spectrogram
        otherwise
            error('Invalid cwt method');
    end
    
    t = (1:length(dataResample)) / fs;
    CData = abs(wt);

    return;
end