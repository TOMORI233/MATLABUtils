function [latency, P, spikes, index] = calLatency_Dual(trials, windowOnset, windowBase, windowPost, th, nStart, tTh, minLatency)
% calLatency_Dual — 计算神经元发放的 latency（可自动判断上升或下降）
%
% 输入：
%   trials       - cell array，每个元素为单次 trial 的 spike time
%   windowOnset  - 响应期窗口 [t1 t2]
%   windowBase   - baseline 计算窗口
%   windowPost   - 响应后期窗口，用于检测反应结束
%   th           - Poisson 累积概率阈值（默认 1e-6）
%   nStart       - 从第几个 spike 开始判断（默认 5）
%   tTh          - latency 最大截止（默认 50）
%   minLatency   - latency 最小值（默认 10）
%
% 输出：
%   latency      - 检测到的 latency
%   P            - 对应 Poisson 累积概率序列
%   spikes       - 用于判断的 spike 时间集合
%   index        - 1=上升响应，-1=下降响应，[]=无

% 参数默认
if nargin < 5, th = 1e-6; end
if nargin < 6, nStart = 5; end
if nargin < 7, tTh = 50; end
if nargin < 8, minLatency = 10; end

% 标准化 spike 数据
trials = reshape(trials, [], 1);
trials = cellfun(@(x) reshape(x, [], 1), trials, "UniformOutput", false);
allSpikes = cell2mat(trials(:));

%% === Step 1: baseline firing rate ===
sprate_on   = mean(calFR(trials, windowBase));  % pre baseline Hz
sprate_post = mean(calFR(trials, windowPost));  % post baseline Hz

%% === Step 2: 上升 latency 检测 ===
spikes_on     = sort(allSpikes(allSpikes >= windowOnset(1) & allSpikes <= windowOnset(2)));
spikes_on     = spikes_on - windowOnset(1);
tTh_on        = tTh - windowOnset(1);
minLatency_on = minLatency - windowOnset(1);
if numel(spikes_on) >= nStart
    spikes_use = spikes_on(nStart:end);
    n = nStart:length(spikes_on);
    lambda = numel(trials) * sprate_on * spikes_use / 1000;
    P_on = zeros(length(n), 1); % Probability for rate increase
    for i = 1:length(n)
        P_on(i) = 1 - poisscdf(n(i) - 1, lambda(i));
    end
    valid_on = (P_on < th) & (spikes_use > minLatency_on) & (spikes_use < tTh_on);
    latency_on = spikes_use(find(valid_on, 1));
    latency_on = latency_on + windowOnset(1);
else
    latency_on = [];
    P_on = [];
end

%% === Step 4: 若存在下降趋势，进行反向分析 ===
latency_off = [];
P_off = [];

if isempty(latency_on)
    spikes_rev = sort(windowOnset(2) - allSpikes(allSpikes >= windowOnset(1) & allSpikes <= windowOnset(2)));
    if numel(spikes_rev) >= nStart
        spikes_rev = sort(spikes_rev);
        spikes_rev_use = spikes_rev(nStart:end);
        n_rev = nStart:length(spikes_rev);
        lambda_rev = numel(trials) * sprate_post * spikes_rev_use / 1000;
        P_off_raw = zeros(length(n_rev), 1); 
        for i = 1:length(n_rev)
            P_off_raw(i) = 1 - poisscdf(n_rev(i) - 1, lambda_rev(i));
        end
        valid_rev = (P_off_raw < th) & (spikes_rev_use > minLatency) & (spikes_rev_use < tTh);
        rev_latency = spikes_rev_use(find(valid_rev, 1));
        if ~isempty(rev_latency)
            latency_off = windowOnset(2) - rev_latency;
            P_off = P_off_raw;
        end
    end
end

%% === Step 5: 判断结果输出 ===
if ~isempty(latency_off)
    latency = latency_off;
    P = P_off;
    spikes = spikes_rev;
    index = -1;
elseif ~isempty(latency_on) 
    latency = latency_on;
    P = P_on;
    spikes = spikes_on;
    index = 1;
else
    latency = [];
    P = [];
    spikes = [];
    index = 0;
end


end