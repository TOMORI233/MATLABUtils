function [latency, P, spikes] = calLatency_Dual(trials, windowOnset, windowBase, th, nStart, tTh, minLatency)
% Return latency of neuron using spike data.
%
% If [trials] is a struct array, it should contain field [spike] for each trial.
% If [trials] is a cell array, its element contains spikes of each trial.
% [windowBase] and [windowOnset] are two-element vectors in millisecond.
% [th] for picking up [latency] from Poisson cumulative probability (default: 1e-6).
% [nStart] for skipping (nStart-1) spikes at the beginning (default: 5).
% [tTh] is the maximum time threshold to consider for latency.
%
% REFERENCE doi: 10.1073/pnas.0610368104

narginchk(3, 7);

if nargin < 4
    th = 1e-6;
end

if nargin < 5
    nStart = 5;
end

if nargin < 6
    tTh = 50;
end

if nargin < 7
    minLatency = 10;
end

trials = reshape(trials, [numel(trials), 1]);
switch class(trials)
    case "cell"
        trials = cellfun(@(x) reshape(x, [numel(x), 1]), trials, "UniformOutput", false);
        spikes = cell2mat(trials);
    case "struct"
        spikes = vertcat(arrayfun(@(x) reshape(x.spike, [numel(x.spike), 1]), trials, "UniformOutput", false));
end


sprate = mean(calFR(trials, windowBase));

spikes = sort(spikes(spikes >= windowOnset(1) & spikes <= windowOnset(2)), "ascend");

n = nStart:length(spikes);
spikes = spikes(nStart:end);
lambda = numel(trials) * sprate * spikes / 1000;

P_increase = zeros(length(n), 1); % Probability for rate increase
P_decrease = zeros(length(n), 1); % Probability for rate decrease
for index = 1:length(n)
    % Calculate probability for rate increase
    P_increase(index) = 1 - poisscdf(n(index) - 1, lambda(index));
    % Calculate probability for rate decrease
    P_decrease(index) = poisscdf(n(index) - 1, lambda(index));
end

% Find latency for rate increase and decrease
latency_increase = spikes(find(P_increase < th & spikes < tTh & spikes > minLatency, 1));
latency_decrease = spikes(find(P_decrease < th & spikes < tTh & spikes > minLatency, 1));

% Determine which latency to use
if isempty(latency_increase) && isempty(latency_decrease)
    latency = []; % No significant latency detected
    P = [];
elseif isempty(latency_increase)
    latency = latency_decrease;
    P = P_decrease;
elseif isempty(latency_decrease)
    latency = latency_increase;
    P = P_increase;
else
    % If both latencies are detected, choose the one that occurs first
    if latency_increase < latency_decrease
        latency = latency_increase;
        P = P_increase;
    else
        latency = latency_decrease;
        P = P_decrease;
    end
end

return;
end
