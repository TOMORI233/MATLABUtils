
BLOCKPATH = 'E:\clickTrain\AC\RatC220318\Block-9';

chAll = 32;
fs = 12207.031250;
kiloSpikeAll = cell(chAll,1);
savePath = fullfile(BLOCKPATH, ['th2_', num2str(3)]);
ch = [14 ]; % channels index of kilosort, that means chKs = chTDT - 1;
idx = {27};
NPYPATH = savePath;

[spikeIdx, clusterIdx, templates, spikeTemplateIdx] = parseNPY(NPYPATH);

nTemplates = size(templates, 1);
%% Plot template
Fig = figure;
maximizeFig(Fig);
plotIdx = 0;
for chN = 1:length(ch)
%     kiloClusters = input(['Input clusters of channel ', num2str(chN), ': ']);
    kiloClusters = idx{chN};

    kiloSpikeTimeIdx = [];
    
    for index = 1:length(kiloClusters)
        kiloSpikeTimeIdx = [kiloSpikeTimeIdx; spikeIdx(clusterIdx == kiloClusters(index))];
        plotIdx = plotIdx + 1; 
        subplot(8, ceil(nTemplates / 8), plotIdx);
        plot(templates(kiloClusters(index)+1, :, ch(chN)+1));
        xticklabels('');
        yticklabels('');
        title(['Ch' num2str(ch(chN)) 'Idx' num2str(kiloClusters(index))]);
    end

    %     kiloSpikeTimeIdx = kiloSpikeTimeIdx(kiloSpikeTimeIdx <= max(t) * fs);
    kiloSpikeTime = double(kiloSpikeTimeIdx - 1) / fs;
    kiloSpikeAll{ch(chN)} = [kiloSpikeTime ch(chN)*ones(length(kiloSpikeTime),1)];
end

%% split sort data into different blocks
sortdata = cell2mat(kiloSpikeAll);
save([savePath '\sortdata.mat'], 'sortdata');


DataClassifyGUI
