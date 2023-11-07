ccc;

fs = 1e3;
t0 = 0:1/fs:1;
y = [2*sin(2*pi*100*t0), 5*sin(2*pi*20*t0)];
t = (0:length(y) - 1) / fs;

figure;
plot(t, y);

data.trial   = {y};
data.time    = {t};
data.fsample = fs;
data.label   = {'1'};

cfg           = [];
cfg.method    = 'wavelet';
cfg.taper     = 'hanning';
cfg.toi       = 'all';
freq          = ft_freqanalysis(cfg, data);

[cwtres, f, coi] = cwtMultiAll(y', fs);
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