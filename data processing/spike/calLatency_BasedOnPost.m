function [latency, P, spikes] = calLatency_BasedOnPost(trials, windowResp, windowBase, windowPost, th, nStart, tTh, minLatency, binsize)
    % Return latency of neuron using spike data.
    %
    % If [trials] is a struct array, it should contain field [spike] for each trial.
    % If [trials] is a cell array, its element contains spikes of each trial.
    % [windowBase], [windowResp], and [windowPost] are two-element vectors in milliseconds.
    % [th] for picking up [latency] from Poisson cumulative probability (default: 1e-6).
    % [nStart] for skipping (nStart-1) spikes at the beginning (default: 5).
    % [binsize] for determining the time resolution for finding the minimum firing rate (in milliseconds).
    %
    % The function first detects the onset of a decrease in firing rate
    % in winResp compared to winBase using Poisson distribution,
    % then applies a sliding window to find the minimum firing rate.

    narginchk(4, 9);

    if nargin < 5
        th = 1e-6;
    end

    if nargin < 6
        nStart = 5;
    end

    if nargin < 7
        tTh = 50;
    end

    if nargin < 8
        minLatency = 10;
    end

    if nargin < 9
        binsize = 10; % Default binsize of 10 ms
    end

    trials = reshape(trials, [numel(trials), 1]);
    switch class(trials)
        case "cell"
            trials = cellfun(@(x) reshape(x, [numel(x), 1]), trials, "UniformOutput", false);
            spikes = cell2mat(trials);
        case "struct"
            spikes = vertcat(arrayfun(@(x) reshape(x.spike, [numel(x.spike), 1]), trials, "UniformOutput", false));
    end

    % Calculate baseline firing rate
    sprate_base = mean(calFR(trials, windowBase));
    spikes_resp = sort(spikes(spikes >= windowResp(1) & spikes <= windowResp(2)), "ascend");

    % Detect decrease in firing rate using Poisson distribution
    n_resp = 1:length(spikes_resp);
    lambda_base = numel(trials) * sprate_base * spikes_resp / 1000;
    P_decrease = zeros(length(n_resp), 1);
    for index = 1:length(n_resp)
        P_decrease(index) = poisscdf(n_resp(index) - 1, lambda_base(index));
    end

    % Find the time point where there is a significant decrease
    start_decrease_time = spikes_resp(find(P_decrease < th & spikes_resp < tTh, 1));

    % If a significant decrease is detected, begin the sliding window analysis from this point
    if ~isempty(start_decrease_time)
        min_firing_rate = inf;
        min_firing_time = start_decrease_time;

        % Slide a window of binsize starting from the detected decrease time to find the minimum firing rate
        for t = start_decrease_time:binsize:windowResp(2)-binsize
            curr_window = [t, t + binsize];
            curr_firing_rate = mean(calFR(trials, curr_window));

            if curr_firing_rate < min_firing_rate
                min_firing_rate = curr_firing_rate;
                min_firing_time = t + binsize; % Update to the end of the current window
            end
        end

        % Update winResp(1) to the end of the window with the minimum firing rate
        minLatency = min_firing_time;
    end

    % Calculate the firing rate in winPost for comparison
    sprate_post = mean(calFR(trials, windowPost));

    % Re-calculate lambda based on the adjusted windowResp
    spikes_resp_adjusted = sort(spikes(spikes >= windowResp(1) & spikes <= windowResp(2)), "ascend");
    n = nStart:length(spikes_resp_adjusted);
    lambda_post = numel(trials) * sprate_post * spikes_resp_adjusted / 1000;
    spikes_resp_adjusted = spikes_resp_adjusted(nStart:end);
    P = zeros(length(n), 1); % P(n>=k)=1-P(n<k)
    for index = 1:length(n)
        P(index) = 1 - poisscdf(n(index) - 1, lambda_post(index));
    end

    % Find the first significant latency where P < th and the spike time is within tTh
    latency_candidates = spikes_resp_adjusted(P < th & spikes_resp_adjusted < tTh);
    latency_candidates = latency_candidates(latency_candidates > minLatency);
    % Final check using winPost to determine if there's a significant increase
    if ~isempty(latency_candidates)
        if mean(calFR(trials, [latency_candidates(1), windowResp(2)])) > sprate_post
            latency = latency_candidates(1);
        else
            latency = []; % No significant increase detected
        end
    else
        latency = []; % No significant latency detected
    end

    return;
end
