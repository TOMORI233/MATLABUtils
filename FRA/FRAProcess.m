function [result, windowParams, normalizationSettings] = FRAProcess(data, windowParams, normalizationSettings, sortData, cIndex)
    narginchk(3, 5);

    %% Parameter settings
    windowParams.window = getOr(windowParams, 'window', [0, 100]); % ms
    window = windowParams.window;

    %% Information extraction
    onsetTimeAll = data.epocs.Swep.onset * 1000; % ms
    freqAll = data.epocs.vair.data; % Hz
    attAll = data.epocs.var2.data; % absolute attenuation, dB

    if nargin == 3
        spikeTimeAll = data.snips.eNeu.ts * 1000; % ms
    elseif nargin == 4
        spikeTimeAll = sortData.spikeTimeAll * 1000; % ms
    elseif nargin == 5
        spikeTimeAll = sortData.spikeTimeAll(ismember(sortData.clusterIdx, cIndex)) * 1000; % ms
    end

    %% Categorizations
    % By sound onset time and window
    for trialIndex = 1:length(onsetTimeAll)
        trialAll(trialIndex, 1).freq = freqAll(trialIndex);
        trialAll(trialIndex, 1).att = attAll(trialIndex);
        trialAll(trialIndex, 1).spike = spikeTimeAll(spikeTimeAll >= onsetTimeAll(trialIndex) + window(1) & spikeTimeAll < onsetTimeAll(trialIndex) + window(2)) - onsetTimeAll(trialIndex);
    end

    % By freq
    freqUnique = unique(freqAll);

    for fIndex = 1:length(freqUnique)
        result(fIndex, 1).freq = freqUnique(fIndex);
        trials = trialAll([trialAll.freq] == freqUnique(fIndex), 1);

        % By attenuation
        attUnique = sort(unique([trials.att]), "ascend");

        for aIndex = 1:length(attUnique)
            temp(aIndex, 1).amp = abs(roundn(attUnique(aIndex) - attUnique(end), 0)) + 10; % relative attenuation
            temp(aIndex, 1).spikes = {trials([trials.att] == attUnique(aIndex), 1).spike}';
        end

        result(fIndex, 1).trials = temp;
        clearvars temp
    end

    return;
end
