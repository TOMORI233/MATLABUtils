BLOCKPATH  = "H:\SPR Paper\Three statistical scales\TANK\DDZ\ddz20240304\Block-4";
protocol   = "ThreeStatistics";
sitePos    = "A45L15_AC";
MATPATH    = "..\MAT Data";
temp = strsplit(BLOCKPATH, "\");
monkeyName = temp(end-2);
date = temp(end-1);
%%
data = TDTbin2mat(char(BLOCKPATH));
sortData = mysort(data, 1, "reselect", "preview");

% plotSSEorGap(sortData);
% plotPCA(sortData, [1 2 3]);
% plotWave(sortData);
% plotSpikeAmp(sortData);

dataCopy = data;
clear data;
mkdir(fullfile(MATPATH, monkeyName, "CTL_New", protocol, strcat(date, "_", sitePos)));
% export spike data
data.epocs    = dataCopy.epocs;
data.spikeRaw.snips = dataCopy.snips;
data.sortdata = [sortData.spikeTimeAll(sortData.clusterIdx ~=0), (sortData.clusterIdx(sortData.clusterIdx ~=0) - 1)*1000 + 1];
data.spkWave  = [];
save(fullfile(MATPATH, monkeyName, "CTL_New", protocol, strcat(date, "_", sitePos), "spkData.mat"), "data", "-mat");

% export lfp data
data.epocs    = dataCopy.epocs;
data.lfp      = dataCopy.streams.Llfp;
data.lfp.data = data.lfp.data(1, :);
data.lfp.channels = 1;
save(fullfile(MATPATH, monkeyName, "CTL_New", protocol, strcat(date, "_", sitePos), "lfpData.mat"), "data", "-mat");

close all
