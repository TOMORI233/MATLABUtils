
%% get stimPara
ch = [1];
BLOCKPATH = 'E:\clickTrain\MGB\RatC220325\Block-8';
data =  TDTbin2mat(BLOCKPATH, 'TYPE', {'epocs'});
clickTrainOnset = data.epocs.tril.onset;
clickTrainOffset = data.epocs.tril.onset +1.6;
ICI = data.epocs.ICIs.data;
stimVal = num2cell([clickTrainOnset  clickTrainOffset ICI]); 
stimField = {'clickTrainOnset','clickTrainOffset','ICI'};
stimPara = easyStruct(stimField,stimVal);

wavePlotWin = [0 16]; % sec
dataBuffer =  TDTbin2mat(BLOCKPATH, 'TYPE', {'streams'},'STORE','Wave','T1', wavePlotWin(1), 'T2', wavePlotWin(2));
wave = double(dataBuffer.streams.Wave.data);
fs = dataBuffer.streams.Wave.fs;


%% Filtered data 
fid = fopen([BLOCKPATH, '\temp_wh.dat'], 'r');
nChannels = 32;
filteredWaveBinData = fread(fid, [nChannels inf], 'int16');
fclose(fid);

%% compare rawdata and filtered data
t = 0:1/fs:(size(wave,2)-1)/fs;

figure
subplot(2,1,1)

plot(t,wave(ch,:),'b-'); hold on;
plot(t,5e-8*filteredWaveBinData(ch,1:length(t)),'r-'); hold on;

