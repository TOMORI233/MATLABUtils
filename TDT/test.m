close all; clc;

clearvars -except data

ch = 14;

%%
data = TDTbin2mat('D:\Education\Lab\kilosort files\data\Block-4');
% data = mConvert(data, [-0.1 0.2], ch);
% TDTmat2bin(data, 'D:\Education\Lab\kilosort files\data\Block-4');

% TDT2bin('D:\Education\Lab\kilosort files\data\Block-4');

%%
% if ~exist("data", "var")
%     load("data.mat");
% end
fs = data.streams.Wave.fs;

%% kilosort
ROOTPATH = 'D:\Education\Lab\kilosort files\data\Block-4';
[spikeTimeIdx, clusterIdx, templates, spikeTemplateIdx] = parseSpikeNPY(ROOTPATH, fs);

%% mysort
sortResult = mysort(mConvert(data, [-0.1 0.2], ch), ch);

%% plot
t = 0:1/fs:200;
kiloClusters = [26 33 34 36 38];
% kiloClusters = 34;
kiloSpikeTimeIdx = [];
for index = 1:length(kiloClusters)
    kiloSpikeTimeIdx = [kiloSpikeTimeIdx; spikeTimeIdx(clusterIdx == kiloClusters(index))];
end

kiloSpikeTimeIdx = kiloSpikeTimeIdx(kiloSpikeTimeIdx <= max(t) * fs);
kiloSpikeTime = double(kiloSpikeTimeIdx - 1) / fs;

mysortSpikeTime = sortResult.spikeTimeAll(sortResult.clusterIdx == 1);
mysortSpikeTime = mysortSpikeTime(mysortSpikeTime <= max(t));

%% 
fid = fopen('D:\Education\Lab\kilosort files\data\Block-4\temp_wh.dat', 'r');
nChannels = 32;
binData = fread(fid, [nChannels inf], 'int16');
fclose(fid);

%% 
sCh = 14;
figure;
y = data.streams.Wave.data(sCh, 1:length(t));
plot(t, y, 'b');

figure;
y = binData(sCh, 1:length(t));
plot(t, y, 'r');
hold on;
plot(chan14spikeTime, 8000 * ones(length(chan14spikeTime), 1), 'g.');
plot(mysortSpikeTime, 7500 * ones(length(mysortSpikeTime), 1), 'r.');
plot(kiloSpikeTime, 7000 * ones(length(kiloSpikeTime), 1), 'b.');

%% 
sortOpts.th = 1500;
sortOpts.fs = fs;
sortOpts.waveLength = 1.5e-3;
sortOpts.scaleFactor = 1;
sortOpts.CVCRThreshold = 0.9;
sortOpts.KselectionMethod = "gap";
KmeansOpts.KArray = 1:10;
KmeansOpts.maxIteration = 100;
KmeansOpts.maxRepeat = 3;
KmeansOpts.plotIterationNum = 0;
sortOpts.KmeansOpts = KmeansOpts;

chan14sort = batchSorting(binData, 14, sortOpts);
chan14spikeTime = chan14sort.spikeTimeAll(chan14sort.spikeTimeAll <= max(t));

%% 
figure;
plot(kiloSpikeTime, 1.2 * ones(length(kiloSpikeTime), 1), 'b.', 'MarkerSize', 15, 'DisplayName', 'Kilosort');
hold on;
plot(mysortSpikeTime, ones(length(mysortSpikeTime), 1), 'ro', 'DisplayName', 'mysort (cut data)');
plot(chan14spikeTime, 0.8 * ones(length(chan14spikeTime), 1), 'go', 'DisplayName', 'mysort (filtered data)');
legend;
ylim([0 2]);