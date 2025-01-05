function EEGDataset = EEGNotch(EEGDataset, Notchfreq, Notchbelt, filterOrder)
    narginchk(1, 4);
    ft_setPath2Top;

    if nargin < 2
        Notchfreq = 50;
    end

    if nargin < 3
        Notchbelt = 1;
    end

    if nargin < 4
        filterOrder = 3;
    end    

    fs = EEGDataset.fs;
    Wn = [Notchfreq - Notchbelt, Notchfreq + Notchbelt] / (fs/2); % 归一化角频率
    [b, a] = butter(filterOrder, Wn, 'stop'); % filter
    Signal = EEGDataset.data;

    % 应用陷波滤波器
    data = cell2mat(cellfun(@(x) filtfilt(b, a, x), num2cell(Signal, 2), "UniformOutput", false));
    EEGDataset.data = data;

    return;
end