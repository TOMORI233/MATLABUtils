ccc;

[settings, opts] = config_kilosort4("n_chan_bin", 385, ...
                                    "fs", 30e3, ...
                                    "filename", fullfile(pwd, 'ZFM-02370_mini.imec0.ap.short.bin'), ...
                                    "probe_name", fullfile(pwd, 'NeuroPix1_default.mat'));
kilosort4(settings, opts);