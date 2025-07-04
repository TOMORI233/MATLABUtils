function [latency, P, spikes, index] = calLatency_Down(trials, windowOnset, windowPost, th, nStart, tTh, minLatency)
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
if nargin < 4, th = 1e-6; end
if nargin < 5, nStart = 5; end
if nargin < 6, tTh = 50; end
if nargin < 7, minLatency = 10; end

% 标准化 spike 数据
trials = reshape(trials, [], 1);
trials = cellfun(@(x) reshape(x, [], 1), trials, "UniformOutput", false);
allSpikes = cell2mat(trials(:));

%% === Step 1: baseline firing rate ===
sprate_post = mean(calFR(trials, windowPost));  % post baseline Hz


%% === Step 4: 若存在下降趋势，进行反向分析 ===
latency_off = [];
P_off = [];


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


%% === 判断结果输出 ===
if ~isempty(latency_off)
    latency = latency_off;
    P = P_off;
    spikes = spikes_rev;
    index = -1;
else
    latency = [];
    P = [];
    spikes = [];
    index = 0;
end


end