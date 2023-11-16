ccc;

addpath(genpath(fileparts(mfilename("fullpath"))), "-begin");
load('D:\Education\Lab\Projects\Neural correlates with duration related cognition (pre)\SN_m4\noise duration\m4c1_duration_att30dB_sort_1.mat');

%% 
set(0, "defaultAxesFontSize", 12);

windowOnset = [0, 2000]; % ms
windowBase = [-100, 0]; % ms
th = 1e-6;

%% 
trialAll = noiseProcessFcn(epocs);
trialAll = selectSpikes(spiketime / 1000, trialAll, "trial onset", [-100, 2000]);
trialAll = addfield(trialAll, "duration", epocs.dura.data);
[~, idx] = sort([trialAll.duration], "ascend");
trialAll = trialAll(idx);

%%
figure;
maximizeFig;
mSubplot(1, 2, 1, "shape", "square-min");
rasterData.X = {trialAll.spike};
mRaster(rasterData);
xlabel('Time (ms)');
addLines2Axes(gca, struct("X", 0, "width", 2, "style", "-"));

%%
sprate = mean(calFR(trialAll, windowBase));
spikes = vertcat(trialAll.spike);
spikes = sort(spikes(spikes >= windowOnset(1) & spikes <= windowOnset(2)), "ascend");
n = 5:length(spikes);
lambda = length(trialAll) * sprate * spikes(5:end) / 1000;
P = zeros(length(n), 1);
for index = 1:length(n)
    P(index) = 1 - poisscdf(n(index) - 1, lambda(index));
end
latency = spikes(find(P < th, 1) + 4);

mSubplot(1, 2, 2, "nSize", [0.8, 0.2], "alignment", "top-center");
plot(spikes, zeros(length(spikes), 1), "k", "Marker", "|", "LineStyle", "none", "MarkerSize", 20);
xlim([0, 50]);
yticklabels('');
xlabel('Time (ms)');
ylabel('Spikes');

mSubplot(1, 2, 2, "nSize", [0.8, 0.6], "alignment", "bottom-center");
plot(spikes(5:end), P, "k", "LineWidth", 2);
xlim([0, 50]);
xlabel('Time (ms)');
ylabel('Probability');
set(gca, "YScale", "log");
addLines2Axes(gca, struct("Y", th, "width", 1.5));
title(['Latency ', num2str(latency), ' ms']);

%% fcn
function trialAll = noiseProcessFcn(epocs)
    trialOnsetTimeAll = epocs.Swep.onset * 1000; % ms

    n = length(trialOnsetTimeAll);
    temp = cell(n, 1);
    trialAll = struct('trialNum', temp, ...
                      'soundOnsetSeq', temp);

    for tIndex = 1:length(trialOnsetTimeAll)
        trialAll(tIndex).trialNum = tIndex;
        trialAll(tIndex).soundOnsetSeq = trialOnsetTimeAll(tIndex);
    end

    return;
end

function trials = selectSpikes(spktime, trials, segOption, windowSeg)
    % spktime: [spiketime, clusterind]
    % trials: n*1 struct
    % segOption: "trial onset" | "dev onset" | "push onset" | "last std"
    %            For numeric vector input, it represents segment time.
    % windowSeg: 2-element vector, in ms
    %
    % return in [trials.spike], in ms

    switch segOption
        case "trial onset"
            segTime = cellfun(@(x) x(1), {trials.soundOnsetSeq}');
        case "dev onset"
            segTime = [trials.devOnset]';
        case "push onset" % make sure pushing time of all trials not empty
    
            if length(trials) ~= length([trials.firstPush])
                error("Pushing time of all trials should not be empty");
            end
    
            segTime = [trials.firstPush]';
        case "last std"
            segTime = cellfun(@(x) x(end - 1), {trials.soundOnsetSeq}');
        otherwise
            segTime = segOption;
    end

    for index = 1:length(segTime)
        trials(index).spike = spktime(spktime(:, 1) >= (segTime(index) + windowSeg(1)) / 1000 & spktime(:, 1) <= (segTime(index) + windowSeg(2)) / 1000, :);
        trials(index).spike(:, 1) = trials(index).spike(:, 1) * 1000 - segTime(index); % return in ms
    end

    return;
end