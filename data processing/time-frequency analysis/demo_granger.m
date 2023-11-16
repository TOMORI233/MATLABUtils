ccc;

ft_setPath2Top;

rng default
rng(50)

fs = 200;
nperm = 500;
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
figure
plot(data.time{1}, data.trial{1})
legend(data.label)
xlabel('time (s)')

%%
yseed = cellfun(@(x) y(1, :), y, "UniformOutput", false);
ytarget = cellfun(@(x) y(2:end, :), y, "UniformOutput", false);
granger = mGrangerWavelet(yseed, ytarget, fs);

%% wavelet transform
[cwtres, f, coi] = cellfun(@(x) cwtMultiAll(x', fs), y, "UniformOutput", false);
f = f{1};
f = 10 * log(f);
c = 0 - f(end);
f = f + c;
coi = coi{1};
cwtres = cellfun(@(x) permute(x, [4, 3, 1, 2]), cwtres, "UniformOutput", false);
cwtres = cell2mat(cwtres); % rpt_chan_freq_time

freqdata = [];
freqdata.freq = f;
freqdata.time = t;
freqdata.dimord = 'rpt_chan_freq_time';
freqdata.cumtapcnt = ones(length(t), length(f));
freqdata.fourierspctrm = cwtres;

%% 
grangercfg = [];
freqdata.label = data.label;
grangercfg.channelcmb = cat(2, cellstr(repmat(freqdata.label{1}, [length(data.label(2:end)) 1])), cellstr(string(data.label(2:end))));
grangercfg.cmbindx = [ones(size(grangercfg.channelcmb, 1), 1), [2:size(grangercfg.channelcmb, 1) + 1]'];
gdata = ft_granger_hm(grangercfg, freqdata);

%% PT
grangerspctrm = zeros(length(data.label(2:end)) * 2, length(f), length(t), nperm + 1);
grangerspctrm(:, :, :, 1) = gdata.grangerspctrm;
for index = 1:nperm
    % trial randomization
    for chIdx = 1:size(freqdata.fourierspctrm, 2)
        freqdata.fourierspctrm(:, chIdx, :, :) = freqdata.fourierspctrm(randperm(size(freqdata.fourierspctrm, 1)), chIdx, :, :);
    end

    gdata = ft_granger_hm(grangercfg, freqdata);
    grangerspctrm(:, :, :, 1 + index) = gdata.grangerspctrm;
end
gdata.freq = exp((gdata.freq - c) / 10);
gdata.labelcmbType = {'To', 'From'};

%% 
chMean = cell2mat(cellfun(@(x) mean(x, 1), changeCellRowNum(data.trial), "UniformOutput", false));
plotTFA(chMean, fs, [], [0, 1000]);

%%
figure;
maximizeFig;

mSubplot(2, 2, 1);
idx = 1;
temp = sort(squeeze(max(grangerspctrm(idx, :, :, 2:end), [], [2 3])));
th = temp(fix(nperm * (1 - alphaVal)));
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
th = temp(fix(nperm * (1 - alphaVal)));
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
th = temp(fix(nperm * (1 - alphaVal)));
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
th = temp(fix(nperm * (1 - alphaVal)));
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
