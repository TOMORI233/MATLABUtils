ccc;

fs = 1e3;
t0 = 0:1/fs:1;
x1 = sin(2*pi*100*t0);
x2 = sin(2*pi*20*t0);
y1 = [x1, zeros(1, 400), 2*x2];
y2 = [zeros(1, 200), 0.8*x1, x2];
minLen = min([length(y1), length(y2)]);
y1 = y1(1:minLen);
y2 = y2(1:minLen);
t = (0:length(y1) - 1) / fs;

%% Raw
figure;
maximizeFig;
mSubplot(1, 2, 1);
plot(t, y1, "DisplayName", "y1");
hold on;
plot(t, y2, "DisplayName", "y2");
set(gca, "XLimitMethod", "tight");
title("Shift from 100 Hz to 20 Hz");
legend;

% NP
granger = mGranger({y1}, {y2}, [t(1), t(end)]*1000, fs, "parametricOpt", "NP");
mSubplot(2, 2, 2);
plot(granger.freq, squeeze(granger.grangerspctrm(1, 2, :)), "DisplayName", "From y1 to y2");
hold on;
plot(granger.freq, squeeze(granger.grangerspctrm(2, 1, :)), "DisplayName", "From y2 to y1");
legend;
title("Nonparametric");

% P
granger = mGranger({y1}, {y2}, [t(1), t(end)]*1000, fs, "parametricOpt", "P");
mSubplot(2, 2, 4);
plot(granger.freq, squeeze(granger.grangerspctrm(1, 2, :)), "DisplayName", "From y1 to y2");
hold on;
plot(granger.freq, squeeze(granger.grangerspctrm(2, 1, :)), "DisplayName", "From y2 to y1");
legend;
title("Parametric");

%% Wavelet
% Fieldtrip
data.trial   = {y1};
data.time    = {t};
data.fsample = fs;
data.label   = {'1'};
cfg         = [];
cfg.method  = 'wavelet';
cfg.output  = 'pow';
cfg.taper   = 'hanning';
cfg.toi     = 'all';
cfg.foilim  = [0, 200];
cfg.pad     = 'nextpow2';
freq        = ft_freqanalysis(cfg, data);
figure;
imagesc("XData", t, "YData", freq.freq, "CData", squeeze(freq.powspctrm));
set(gca, "XLimitMethod", "tight");
set(gca, "YLimitMethod", "tight");

% cwt
[cwtres, f, coi] = cwtMultiAll(y1', fs);
figure;
imagesc("XData", t, "YData", f, "CData", cwtres);
set(gca, "XLimitMethod", "tight");
set(gca, "YLimitMethod", "tight");
set(gca, "YScale", "log");
hold on;
plot(t, coi, "w--", "LineWidth", 1.5);
set(gca, "YScale", "log");
yticks(2.^(0:8)');
yticklabels(num2str(2.^(0:8)'));
