function [latency, P, spikes] = calLatency(trials, windowOnset, windowBase, th, nStart, tTh)
    % Return latency of neuron using spike data.
    %
    % If [trials] is a struct array, it should contain field [spike] for each trial.
    % If [trials] is a cell array, its element contains spikes of each trial.
    % [windowBase] and [windowOnset] are two-element vectors in millisecond.
    % [th] for picking up [latency] from Poisson cumulative probability (default: 1e-6).
    % [nStart] for skipping (nStart-1) spikes at the beginning (default: 5).

    narginchk(3, 6);

    if nargin < 4
        th = 1e-6;
    end

    if nargin < 5
        nStart = 5;
    end

    if nargin < 6
        tTh = 50;
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

    P = zeros(length(n), 1);
    for index = 1:length(n)
        P(index) = 1 - poisscdf(n(index) - 1, lambda(index));
    end

    latency = spikes(find(P < th & spikes < tTh, 1));
    return;
end