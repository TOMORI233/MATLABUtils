close all; clc;

% clearvars -except data

ch = 24;
fs = 12207.031250;

%% Load Data
trialAll = WaveExport_para_behavior('D:\Education\Lab\kilosort files\data\Block-3');%  behavior
trialAll = TDT2binAA('D:\Education\Lab\kilosort files\data\Block-3', trialAll, [-0.7 0.3]);
wave = [trialAll.wave];

%% kilosort
% kilosort;

ROOTPATH = 'D:\Education\Lab\kilosort files\data\Block-3';
[spikeIdx, clusterIdx, templates, spikeTemplateIdx] = parseSpikeNPY(ROOTPATH);

%% mysort
data.streams.Wave.data = wave;
data.streams.Wave.fs = fs; % Hz
sortResult = mysort(data, ch, "reselect", "preview");

%% plot
t = 0:1/fs:10;
kiloClusters = 27;
kiloSpikeTimeIdx = [];
for index = 1:length(kiloClusters)
    kiloSpikeTimeIdx = [kiloSpikeTimeIdx; spikeIdx(clusterIdx == kiloClusters(index))];
end

kiloSpikeTimeIdx = kiloSpikeTimeIdx(kiloSpikeTimeIdx <= max(t) * fs);
kiloSpikeTime = double(kiloSpikeTimeIdx - 1) / fs;

mysortSpikeTime = sortResult.spikeTimeAll(sortResult.clusterIdx == 1);
mysortSpikeTime = mysortSpikeTime(mysortSpikeTime <= max(t));

%% 
fid = fopen('D:\Education\Lab\kilosort files\data\Block-3\temp_wh.dat', 'r');
nChannels = 32;
filteredWaveBinData = fread(fid, [nChannels inf], 'int16');
fclose(fid);

%%
fid = fopen('D:\Education\Lab\kilosort files\data\Block-3\Wave.bin', 'r');
waveBinData = fread(fid, [nChannels inf], 'int16');
fclose(fid);

%% 
sortOpts.th = 900;
sortOpts.fs = fs;
sortOpts.waveLength = 1.5e-3;
sortOpts.scaleFactor = 1;
sortOpts.CVCRThreshold = 0.9;
sortOpts.KselectionMethod = "preview";
KmeansOpts.KArray = 1:10;
KmeansOpts.maxIteration = 100;
KmeansOpts.maxRepeat = 3;
KmeansOpts.plotIterationNum = 0;
sortOpts.KmeansOpts = KmeansOpts;

filteredDataSort = batchSorting(filteredWaveBinData, 14, sortOpts);
filteredDataSpikeTime = filteredDataSort.spikeTimeAll(filteredDataSort.spikeTimeAll <= max(t));

%% 
figure;
y = wave(ch, 1:length(t));
plot(t, y, 'b', 'DisplayName', 'Raw Wave');

% figure;
% y = filteredWaveBinData(ch, 1:length(t));
% plot(t, y, 'r');
hold on;
% plot(filteredDataSpikeTime, 3e-4 * ones(length(filteredDataSpikeTime), 1), 'b.', 'DisplayName', 'filtered Data sort');
plot(mysortSpikeTime, 2.5e-4 * ones(length(mysortSpikeTime), 1), 'r.', 'DisplayName', 'raw wave sort');
plot(kiloSpikeTime, 3e-4 * ones(length(kiloSpikeTime), 1), 'g.', 'DisplayName', 'kilosort');
legend;

%% 
figure;
plot(kiloSpikeTime, ones(length(kiloSpikeTime), 1), 'b.', 'MarkerSize', 15, 'DisplayName', 'Kilosort');
hold on;
plot(mysortSpikeTime, ones(length(mysortSpikeTime), 1), 'ro', 'DisplayName', 'mysort (cut data)');
plot(filteredDataSpikeTime, ones(length(filteredDataSpikeTime), 1), 'go', 'DisplayName', 'mysort (filtered data)');
legend;
ylim([0.5 3.5]);