

path = 'E:\clickTrain\AC\AC\RatA\20220412\Block-12'; %处理别的数据的时候把这条注释掉，用下面的！！！
%% raw wave comparison
selectChs = input('Input selected channels:');
waveData = TDTbin2mat(path,'TYPE',{'streams'},'CHANNEL',selectChs);
fs = waveData.streams.Wave.fs;
t = 0:1/fs:10;
waveRaw = waveData.streams.Wave.data(:,1:length(t));
Fig = figure;
maximizeFig(Fig);
ymin = min(min(waveRaw));
ymax = max(max(waveRaw));
colorLine = {'r-','b-','k-'};
for ch = 1 : length(selectChs)
    subplot(3,1,ch)
    plot(t,waveRaw(ch,:),colorLine{ch}); hold on;
    title(['waveform of Ch' num2str(selectChs(ch)) ]);
    ylim([ymin ymax]);
end
%% sort
clusters = input('Input cluster numbers:');
for ch = 1:length(selectChs)
    waveData = TDTbin2mat(path,'TYPE',{'streams'},'CHANNEL',selectChs(ch));
    sortRes{selectChs(ch)} = mysort(waveData,[],'reselect',clusters(ch));
end


 