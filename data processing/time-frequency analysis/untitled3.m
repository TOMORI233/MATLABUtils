ccc;

dataAC = load("D:\Education\Lab\Projects\ECOG\ECOG process\7-10Freq\batch\Active\CC\Population\PE\AC_PE_Data.mat");
dataPFC = load("D:\Education\Lab\Projects\ECOG\ECOG process\7-10Freq\batch\Active\CC\Population\PE\AC_PE_Data.mat");
fs = dataAC.fs;

%%
granger = mGranger(dataAC.trialsECOG(1:10), dataPFC.trialsECOG(1:10), dataAC.windowPE, fs, "parametricOpt", "NP");

%%
figure;
imagesc("XData", granger.time, "YData", granger.freq, "CData", squeeze(granger.grangerspctrm(1, 2, :, :)));

%%
tic;
temp = dataAC.trialsECOG(1:100);
[cwtres1, f, coi] = cellfun(@(x) cwtMultiAll_mex(x', fs), temp, "UniformOutput", false);
cwtres1 = cellfun(@gather, cwtres1, "UniformOutput", false);
f = gather(f{1});
coi = gather(coi{1});
toc;

t = linspace(windowPE(1), windowPE(2), 651);

res = cellfun(@(x) x(:, :, 1), cwtres1, "UniformOutput", false);
res = cell2mat(cellfun(@(x) mean(x, 1), changeCellRowNum(res), "UniformOutput", false));
figure;
imagesc("XData", t, "YData", f, "CData", res);
hold on;
plot(t, coi, "w--", "LineWidth", 1.5);
set(gca, "YScale", "log");
yticks(2.^(0:7)');
yticklabels(num2str(2.^(0:7)'));
set(gca, "YLim", [-inf, 128]);
set(gca, "XLimitMethod", "tight");
set(gca, "YLimitMethod", "tight");
