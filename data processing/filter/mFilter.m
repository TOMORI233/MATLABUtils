function data = mFilter(data, fs, varargin)
    % This function provides a general zero-phase filter for multi-channel
    % data based on matlab built-in functions `butter`, `filtfilt` and 
    % `designNotchPeakIIR` (MATLAB ver > R2023b).
    %
    % If frequency not specified, corresponding filter will not be applied.
    % 
    % Input:
    %     data: [nch, nsample]
    %     fs: sample rate, unit: Hz
    %     namevalue pairs:
    %         - "fhp": high-pass filter cutoff frequency, scalar, unit: Hz
    %         - "flp": low-pass filter cutoff frequency, scalar, unit: Hz
    %         - "fnotch": notch filter stop frequency, vector, unit: Hz
    %         - "order": order of Butterworth filter, int scalar (default: 3)
    %         - "BW": band-width of notch filter, unit: Hz (default: 1)

    mIp = inputParser;
    mIp.addRequired("data", @(x) validateattributes(x, {'numeric'}, {'2d'}));
    mIp.addRequired("fs", @(x) validateattributes(x, {'numeric'}, {'scalar', 'positive'}));
    mIp.addParameter("fhp", [], @(x) validateattributes(x, {'numeric'}, {'scalar', 'positive', '<', fs / 2}));
    mIp.addParameter("flp", [], @(x) validateattributes(x, {'numeric'}, {'scalar', 'positive', '<', fs / 2}));
    mIp.addParameter("fnotch", [], @(x) validateattributes(x, {'numeric'}, {'vector', 'positive', '<', fs / 2}));
    mIp.addParameter("order", 3, @(x) validateattributes(x, {'numeric'}, {'scalar', 'integer', 'positive'}));
    mIp.addParameter("BW", 1, @(x) validateattributes(x, {'numeric'}, {'scalar', 'positive'}));
    mIp.parse(data, fs, varargin{:});

    order = mIp.Results.order;
    BW = mIp.Results.BW;
    fhp = mIp.Results.fhp;
    flp = mIp.Results.flp;
    fnotch = mIp.Results.fnotch;

    % Nyquist frequency
    fnyq = fs / 2;

    % To avoid function name conflit
    butter = path2func(fullfile(matlabroot, "toolbox/signal/signal/butter.m"));
    filtfilt = path2func(fullfile(matlabroot, "toolbox/signal/signal/filtfilt.m"));

    % Convert data to [nsample, nch]
    data = data';

    % Notch
    for fIndex = 1:length(fnotch)
        [b, a] = designNotchPeakIIR(Response = "notch", ...
                                    CenterFrequency = fnotch(fIndex) / fnyq, ...
                                    Bandwidth = BW / fnyq, ...
                                    FilterOrder = 2);
        data = filtfilt(b, a, data);
    end

    % High-pass
    if ~isempty(fhp)
        [b, a] = butter(order, fhp / fnyq, "high");
        data = filtfilt(b, a, data);
    end

    % Low-pass
    if ~isempty(flp)
        [b, a] = butter(order, flp / fnyq, "low");
        data = filtfilt(b, a, data);
    end

    data = data';

    return;
end