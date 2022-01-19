function data = mConvert(data, mWindow, channels, noiseAmp)
    narginchk(2, 5);

    allChannels = 1:size(data.streams.Wave.data, 1);

    if nargin == 2
        channels = allChannels;
        noiseAmp = 1e-5; % V
    elseif nargin == 3
        noiseAmp = 1e-5; % V
    end

    if isempty(channels) || isequal(channels, 0)
        channels = allChannels;
    end

    allChannels(channels) = [];
    otherChannnels = allChannels;

    waves = data.streams.Wave.data; % V
    onsetTime = data.epocs.Stim.onset; % sec
    fs = data.streams.Wave.fs; % Hz

    mWaitbar = waitbar(0, 'Starting to fill other channels with white noise');

    if ~isempty(otherChannnels)
        waves(otherChannnels, :) = repmat(wgn(1, size(waves, 2), 0) * noiseAmp, length(otherChannnels), 1);
    end

    waitbar(1 / 2, mWaitbar, 'Starting to fill selected channels with white noise');
    
    range = 1:roundn((onsetTime(1) + mWindow(1)) * fs, 0);
    waves(channels, range) = wgn(length(channels), length(range), 0) * noiseAmp;

    for index = 2:length(onsetTime) - 1
        range = roundn((onsetTime(index - 1) + mWindow(2)) * fs, 0):roundn((onsetTime(index) + mWindow(1)) * fs, 0);
        waves(channels, range) = wgn(length(channels), length(range), 0) * noiseAmp;
    end

    range = min([roundn((onsetTime(end) + mWindow(2)) * fs, 0), size(waves, 2)]):size(waves, 2);
    waves(channels, range) = wgn(length(channels), length(range), 0) * noiseAmp;
    waitbar(1, mWaitbar, 'Done');

    data.streams.Wave.data = waves;
    
    close(mWaitbar);

    return;
end