ccc;

ft_setPath2Top;

rng default
rng(50)

fs = 200;
nperm = 10;
alphaVal = 0.01;

cfg             = [];
cfg.ntrials     = 500;
cfg.triallength = 1;
cfg.fsample     = fs;
cfg.nsignal     = 3;
cfg.method      = 'ar';

cfg.params(:,:,1) = [ 0.8    0    0 ;
                        0  0.9  0.5 ;
                      0.4    0  0.5];

cfg.params(:,:,2) = [-0.5    0    0 ;
                        0 -0.8    0 ;
                        0    0 -0.2];

cfg.noisecov      = [ 0.3    0    0 ;
                        0    1    0 ;
                        0    0  0.2];

data              = ft_connectivitysimulation(cfg);

cfg         = [];
cfg.order   = 5;
cfg.toolbox = 'bsmart';
mdata       = ft_mvaranalysis(cfg, data);
cfg         = [];
cfg.method  = 'mvar';
mfreq       = ft_freqanalysis(cfg, mdata); 
cfg           = [];
cfg.method    = 'granger';
grangerP      = ft_connectivityanalysis(cfg, mfreq);
figure;
cfg           = [];
cfg.parameter = 'grangerspctrm';
cfg.zlim      = [0 1];
ft_connectivityplot(cfg, grangerP);

cfg           = [];
cfg.method    = 'mtmfft';
cfg.taper     = 'dpss';
cfg.output    = 'fourier';
cfg.tapsmofrq = 2;
freq          = ft_freqanalysis(cfg, data);
cfg           = [];
cfg.method    = 'granger';
grangerNP     = ft_connectivityanalysis(cfg, freq);
figure;
cfg           = [];
cfg.parameter = 'grangerspctrm';
cfg.zlim      = [0 1];
ft_connectivityplot(cfg, grangerNP);

figure
for row=1:3
    for col=1:3
        subplot(3,3,(row-1)*3+col);
        plot(grangerP.freq, squeeze(grangerP.grangerspctrm(row,col,:)))
        ylim([0 1])
    end
end

%%
y = data.trial';
t = data.time{1};
figure;
plot(data.time{1}, data.trial{1});
legend(data.label);
xlabel('time (s)');

chMean = cell2mat(cellfun(@(x) mean(x, 1), changeCellRowNum(data.trial), "UniformOutput", false));
plotTFA(chMean, fs, [], [0, 1000]);

%% wavelet granger causality
yseed = cellfun(@(x) x(1, :), y, "UniformOutput", false);
ytarget = cellfun(@(x) x(2:end, :), y, "UniformOutput", false);
gdata = mGrangerWavelet(yseed, ytarget, fs, nperm);
grangerspctrm = gdata.grangerspctrm;

%%
figure;
maximizeFig;

mSubplot(2, 2, 1);
idx = 1;
temp = sort(squeeze(max(grangerspctrm(idx, :, :, 2:end), [], [2 3])));
th = temp(ceil(nperm * (1 - alphaVal)));
temp = squeeze(grangerspctrm(idx, :, :, 1) .* (grangerspctrm(idx, :, :, 1) > th));
imagesc("XData", gdata.time, "YData", gdata.freq, "CData", temp);
set(gca, "YScale", "log");
yticks([0, 2.^(0:nextpow2(max(gdata.freq)) - 1)]);
set(gca, "XLimitMethod", "tight");
set(gca, "YLimitMethod", "tight");
title('From signal001 to signal002');

mSubplot(2, 2, 2);
idx = 3;
temp = sort(squeeze(max(grangerspctrm(idx, :, :, 2:end), [], [2 3])));
th = temp(ceil(nperm * (1 - alphaVal)));
temp = squeeze(grangerspctrm(idx, :, :, 1) .* (grangerspctrm(idx, :, :, 1) > th));
imagesc("XData", gdata.time, "YData", gdata.freq, "CData", temp);
set(gca, "YScale", "log");
yticks([0, 2.^(0:nextpow2(max(gdata.freq)) - 1)]);
set(gca, "XLimitMethod", "tight");
set(gca, "YLimitMethod", "tight");
title('From signal001 to signal003');

mSubplot(2, 2, 3);
idx = 2;
temp = sort(squeeze(max(grangerspctrm(idx, :, :, 2:end), [], [2 3])));
th = temp(ceil(nperm * (1 - alphaVal)));
temp = squeeze(grangerspctrm(idx, :, :, 1) .* (grangerspctrm(idx, :, :, 1) > th));
imagesc("XData", gdata.time, "YData", gdata.freq, "CData", temp);
set(gca, "YScale", "log");
yticks([0, 2.^(0:nextpow2(max(gdata.freq)) - 1)]);
set(gca, "XLimitMethod", "tight");
set(gca, "YLimitMethod", "tight");
title('From signal002 to signal001');

mSubplot(2, 2, 4);
idx = 4;
temp = sort(squeeze(max(grangerspctrm(idx, :, :, 2:end), [], [2 3])));
th = temp(ceil(nperm * (1 - alphaVal)));
temp = squeeze(grangerspctrm(idx, :, :, 1) .* (grangerspctrm(idx, :, :, 1) > th));
imagesc("XData", gdata.time, "YData", gdata.freq, "CData", temp);
set(gca, "YScale", "log");
yticks([0, 2.^(0:nextpow2(max(gdata.freq)) - 1)]);
set(gca, "XLimitMethod", "tight");
set(gca, "YLimitMethod", "tight");
title('From signal003 to signal001');

colormap('jet');
% scaleAxes("c");
colorbar('position', [1 - 0.03, 0.1, 0.5 * 0.03, 0.8]);
