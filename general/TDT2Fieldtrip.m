BLOCKPATH = 'D:\Education\Lab\monkey\EcoG\data';
dataTest = TDTbin2mat(BLOCKPATH, 'T2', 1);
sampleRate = dataTest.streams.Lfp1.fs;
channelNum = size(dataTest.streams.Lfp1.data,1);
dataFile = 'Lfp1.eeg';
markerFile = 'Lfp1.vmrk';
headerFile = 'Lfp1.vhdr';
epocsData = TDTbin2mat(BLOCKPATH,'TYPE',{'EPOCS'});
if ~exist(fullfile(BLOCKPATH,dataFile),'file')
    TDT2binECoG(BLOCKPATH);
end
mGenerateVmrk(BLOCKPATH,epocsData,dataFile,sampleRate,markerFile);
mGenerateVhdr(BLOCKPATH,dataFile,markerFile,channelNum,sampleRate,headerFile);

% filedtrip 
cfg = [];
cfg.dataset = fullfile(BLOCKPATH,headerFile);
data_eeg    = ft_preprocessing(cfg);