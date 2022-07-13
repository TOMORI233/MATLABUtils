
TANKPATH = 'E:\clickTrain\AC\HQY1\20220518';
Block = 'Block-8';
data = TDTbin2mat(fullfile(TANKPATH,Block),'TYPE',{'EPOCS'});
display(['the first sound of ' Block 'is: '  num2str(data.epocs.ordr.onset(1))]);

%% 
MERGEPATH = check_mkdir_SPR(TANKPATH,'Merge1');
load (fullfile(MERGEPATH,'mergePara.mat'));
chAll = 32;
fs = 12207.031250;

savePath = fullfile(MERGEPATH, 'th8_6');
ch = [1 3 12 23 223 26 ]; % channels index of kilosort, that means chKs = chTDT - 1;
idx = {[7 8] 6 5 4 3 [0 2]};
kiloSpikeAll = cell(max([chAll ch]),1);
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
        plot(templates(kiloClusters(index)+1, :, mod(ch(chN),200)+1));
        xticklabels('');
        yticklabels('');
        title(['Ch' num2str(ch(chN)+1) 'Idx' num2str(kiloClusters(index))]);
    end

    %     kiloSpikeTimeIdx = kiloSpikeTimeIdx(kiloSpikeTimeIdx <= max(t) * fs);
    kiloSpikeTime = double(kiloSpikeTimeIdx - 1) / fs;
    kiloSpikeAll{ch(chN)+1} = [kiloSpikeTime ch(chN)*ones(length(kiloSpikeTime),1)];
end
saveas(Fig,[savePath  '\cluster templates.jpg']);

%% split sort data into different blocks
T = cellfun(@sum,waveLength);

for blks = 1:length(BLOCKPATH)
    if blks == length(BLOCKPATH)
        t = [sum(T(1:blks-1)) inf];
    else
        t = [sum(T(1:blks-1)) sum(T(1:blks))];
    end
sortdataBuffer = cell2mat(kiloSpikeAll);
[~,selectIdx] = findWithinInterval(sortdataBuffer(:,1),t);
sortdata = sortdataBuffer(selectIdx,:);
sortdata(:,1) = sortdata(:,1) - t(1);
save([BLOCKPATH{blks} '\sortdata.mat'], 'sortdata');
end

% DataClassifyGUI





function [resVal,idx] = findWithinInterval(value,range)
    idx = find(value>range(1) & value<range(2));
    resVal = value(idx);
end
