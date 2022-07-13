close all; clc; clear;

ch = 24;
fs = 12207.031250;
t = 0:1 / fs:50;
BLOCKPATH = 'D:\Education\Lab\kilosort files\data\Block-3';

%% Load Data
trialAll = WaveExport_para_behavior(BLOCKPATH); %  behavior
trialAll = TDT2binAA(BLOCKPATH, trialAll, [-0.7 0.3]);
wave = [trialAll.wave];

%% mysort
data.streams.Wave.data = wave;
data.streams.Wave.fs = fs; % Hz
sortResult = mysort(data, ch, "reselect", "preview");
mysortSpikeTime = sortResult.spikeTimeAll(sortResult.clusterIdx == 1);
mysortSpikeTime = mysortSpikeTime(mysortSpikeTime <= max(t));

%% Filtered data sort
fid = fopen([BLOCKPATH, '\temp_wh.dat'], 'r');
nChannels = 32;
filteredWaveBinData = fread(fid, [nChannels inf], 'int16');
fclose(fid);

figure;
y = filteredWaveBinData(ch, 1:length(t));
plot(t, y, 'r');
title('Filtered Data');

sortOpts.th = input('Input th for filtered data sorting: ');
sortOpts.fs = fs;
sortOpts.waveLength = 1.5e-3;
sortOpts.scaleFactor = 0.01;
sortOpts.CVCRThreshold = 0.9;
sortOpts.KselectionMethod = "preview";
KmeansOpts.KArray = 1:10;
KmeansOpts.maxIteration = 100;
KmeansOpts.maxRepeat = 3;
KmeansOpts.plotIterationNum = 0;
sortOpts.KmeansOpts = KmeansOpts;

filteredDataSort = batchSorting(filteredWaveBinData, ch, sortOpts);
filteredDataSpikeTime = filteredDataSort.spikeTimeAll(filteredDataSort.spikeTimeAll <= max(t));

%% kilosort
run('D:\Education\Lab\MATLAB Utils\kilosort\config\configFileRat.m');

for th2 = 3:10
    ops.Th = [10 th2];
    savePath = fullfile(BLOCKPATH, ['th2_', num2str(th2)]);
    mKilosort(BLOCKPATH, ops, savePath);

    cd(savePath);
    system('phy template-gui params.py');

    NPYPATH = savePath;
    kiloClusters = input(['Input clusters of channel ', num2str(ch), ': ']);
    [spikeIdx, clusterIdx, ~, ~] = parseNPY(NPYPATH);
    kiloSpikeTimeIdx = [];

    for index = 1:length(kiloClusters)
        kiloSpikeTimeIdx = [kiloSpikeTimeIdx; spikeIdx(clusterIdx == kiloClusters(index))];
    end

    kiloSpikeTimeIdx = kiloSpikeTimeIdx(kiloSpikeTimeIdx <= max(t) * fs);
    kiloSpikeTime = double(kiloSpikeTimeIdx - 1) / fs;

    %% Plot
    Fig = figure;
    maximizeFig(Fig);
    y = wave(ch, 1:length(t));
    plot(t, y, 'b', 'DisplayName', 'Raw Wave');
    hold on;
    plot(filteredDataSpikeTime, 3.5e-4 * ones(length(filteredDataSpikeTime), 1), 'b.', 'MarkerSize', 10, 'DisplayName', 'mysort (filtered data)');
    plot(mysortSpikeTime, 2.5e-4 * ones(length(mysortSpikeTime), 1), 'r.', 'MarkerSize', 10, 'DisplayName', 'mysort (raw data)');
    plot(kiloSpikeTime, 3e-4 * ones(length(kiloSpikeTime), 1), 'g.', 'MarkerSize', 10, 'DisplayName', 'kilosort');
    title(['Channel ', num2str(ch), ' | Cluster ', num2str(kiloClusters), ' | Th [10, ', num2str(th2), ']']);
    legend;
    xlabel('Time (sec)');
    ylabel('Voltage (V)');
    xlim([0 10]);

end
