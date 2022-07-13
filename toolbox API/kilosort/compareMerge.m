


% fid = fopen([BLOCKPATH, '\Wave.bin'], 'r');
% nChannels = 32;
% WaveBinData = fread(fid, [nChannels inf], 'int16');
% fclose(fid);
%

blockPath = 'E:\clickTrain\AC\RatC220318\Block-9';

load(fullfile(blockPath,"\th2_3\sortdata.mat"));
sortDATA = sortdata(sortdata(:,2) == 14,:);


load(fullfile(blockPath,"sortdata.mat"));
sortdata = sortdata(sortdata(:,2) == 14,:);

Fig = figure;
maximizeFig(Fig)
plot(sortdata(:,1), 0.1*ones(size(sortdata,1),1),'g.','DisplayName','merged'); hold on 
plot(sortDATA(:,1), 0.2*ones(size(sortDATA,1),1),'b.','DisplayName','merged'); hold on 
xlim([0 10])
ylim([-1 1])

sortDATA(end,1) - sortdata(end,1)