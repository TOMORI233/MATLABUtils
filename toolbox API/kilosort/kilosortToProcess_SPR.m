close all; clc; clear;


%% generate .bin file
TANKPATH = 'E:\clickTrain\AC\HQY1\20220526';
MergeFolder = 'Merge1';
BLOCKNUM = num2cell([6 10]);
Block = 'Block-6';
BLOCKPATH = cellfun(@(x) fullfile(TANKPATH,['Block-' num2str(x)]),BLOCKNUM,'UniformOutput',false);
MERGEPATH = fullfile(TANKPATH,MergeFolder);


data = TDTbin2mat(fullfile(TANKPATH,Block),'TYPE',{'EPOCS'});
display(['the first sound of ' Block ' is: '  num2str(data.epocs.ordr.onset(1))]);

binPath = [MERGEPATH '\Wave.bin'];
if ~exist(binPath,'file')
    TDT2binMerge(BLOCKPATH,MergeFolder);
end

%% get stimPara




%% raw wave comparison

% fid = fopen(['D:\Lab\ECoGData\data', '\Lfp1.eeg'], 'r');
% nChannels = 64;
% WaveBinData = fread(fid, [nChannels inf], 'int16');
% fclose(fid);



% selectChs = input('Input selected channels:');
% waveData = TDTbin2mat(BLOCKPATH{1},'TYPE',{'streams'},'CHANNEL',selectChs);
% % waveRaw = waveData.streams.Wave.data;
% binData = WaveBinData(selectChs,:);
%
% fs = waveData.streams.Wave.fs;
% % t = 0:1/fs:10;
% waveRaw = waveData.streams.Wave.data(:,1:length(t));
% waveBinRaw = binData(:,1:length(t));
% Fig = figure;
% maximizeFig(Fig);
% ymin = min(min(waveRaw));
% ymax = max(max(waveRaw));
%
% for ch = 1 : length(selectChs)
%     subplot(3,2,ch*2-1)
%     plot(t,waveRaw(ch,:),colorLine{ch}); hold on;
%     title(['waveform of Ch' num2str(selectChs(ch)) ]);
%     ylim([ymin ymax]);
%
%     subplot(3,2,ch*2)
%     plot(t,waveBinRaw(ch,:)*1e-6,colorLine{ch}); hold on;
%     title(['waveBin of Ch' num2str(selectChs(ch)) ]);
%     ylim([ymin ymax]);
% end



% %% Filtered data
% fid = fopen([BLOCKPATH, '\temp_wh.dat'], 'r');
% nChannels = 32;
% filteredWaveBinData = fread(fid, [nChannels inf], 'int16');
% fclose(fid);

%% kilosort
% run([fileparts(mfilename('fullpath')), '\config\configFileRat.m']);
run(['E:\OneDrive\OneDrive - zju.edu.cn\实验室\Matlab程序\MATLABUtils\kilosort\config\configFileRat.m']);
% ops.chanMap = 1:ops.Nchan; % treated as linear probe if no chanMap file
ops.chanMap = ['E:\OneDrive\OneDrive - zju.edu.cn\实验室\Matlab程序\MATLABUtils\kilosort\config\chan16_2_kilosortChanMap.mat'];
% total number of channels in your recording
ops.NchanTOT = 32;
% sample rate, Hz
ops.fs = 12207.03125;
for th2 = [6 ]
    ops.Th = [8 th2];
    savePath = fullfile(MERGEPATH, ['th', num2str(ops.Th(1))  , '_', num2str(ops.Th(2))]);
    if ~exist([savePath '\params.py'])
        mKilosort(binPath, ops, savePath);
    end
    cd(savePath);
    display(['the first sound of ' Block ' is: '  num2str(data.epocs.ordr.onset(1))]);
    %     system('phy template-gui params.py');
end
