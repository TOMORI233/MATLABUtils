function [RS, vs] = RayleighStatistic(spikes, ISI, winRS, trialNum)
narginchk(2, 4);

if iscell(spikes)
    trialNum = length(spikes);
    spikes = cell2mat(spikes);
end

if isempty(spikes)
    vs = 0;
    RS = 0;
    return;
end

if nargin >= 3
    spikes = spikes(spikes >= winRS(1) & spikes <= winRS(2));
end

if ~exist("trialNum", "var")
    error("trialNum should be provided if input is a vector!");
end

piBuffer = 2 * pi * spikes / ISI;
n = length(spikes);
sumCos = sum(cos(piBuffer));
sumSin = sum(sin(piBuffer));
vs = sqrt(sumCos^2 + sumSin^2) / n;
RS = 2 * n * vs^2 / trialNum;

end
