ccc;

load('D:\Education\Lab\Projects\Neural correlates with duration related cognition (pre)\SN_m4\noise duration\m4c24_duration_att30dB_sort_1.mat');

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
