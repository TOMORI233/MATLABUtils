function [y, durs] = ctgen(ICIs, durs, fs, type, varargin)
% Description: 
%   Thie function generates regular/irregular click trains with
%   specified [ICI1,ICI2,...ICIn] and [dur1,dur2,...,durn] for each section.
% Inputs:
%   Required:
%     - [ICIs]: ICI for each section, scalar or vector, in sec
%     - [durs]: duration for each section, must be the same size as [ICIs], in sec
%     - [fs]: sample rate of the stimuli, in Hz
%     - [type]: type of click train ("REG" or "IRREG")
%   Namevalues:
%     - "sigmas": sigma for each section, scalar or vector (if specified as a
%                 vector, it must be the same size of [ICIs]). 
%                 [sigma1,sigma2,...,sigman] for each section. The sigma 
%                 value is a scale factor of standard deviation of a
%                 Gaussian distribution (std = mean * sigma). If specified 
%                 as a scalar, this sigma value will be applied to all 
%                 sections. This parameter is valid only for type set as 
%                 "IRREG". (default: 0.5)
%     - "pulseLen": pulse duration of a click, in sec. (default: 2e-4)
% Outputs:
%   - [y]: sound stimulation, a row vector, in volt.
%   - [durs]: the actual duration for each section, a column vector, in sec.
% Example:
%   % 1. Generate a 1-sec regular click train with a 4-ms ICI
%   y = ctgen(4e-3, 1, 48e3, "REG");
%   
%   % 2. Generate a 1-sec to 1-sec trainsitional regular click train
%   %    with ICI altering from 4 ms to 5 ms
%   y = ctgen([4, 5] * 1e-3, [1, 1], 48e3, "REG");
%   
%   % 3. Insert two 4.06-ms ICIs into the middle of a 2-sec 4-ms ICI
%   %    regular click train
%   %    e.g. | | | | |   |   | | | | |
%   y = ctgen([4, 4.06, 4] * 1e-3, [1, 4.06e-3 * 2, 1], 48e3, "REG");
%   
%   % 4. Generate a 1-sec to 1-sec trainsitional irregular click train
%   %    with ICI altering from 4 ms to 5 ms. Set standard deviation to be 
%   %    0.01 of the mean ICI.
%   y = ctgen([4, 5] * 1e-3, [1, 1], 48e3, "IRREG", "sigmas", 0.01);

mIp = inputParser;
mIp.addRequired("ICIs", @(x) validateattributes(x, {'numeric'}, {'vector', 'positive'}));
mIp.addRequired("durs", @(x) validateattributes(x, {'numeric'}, {'vector', 'positive', 'numel', numel(ICIs)}));
mIp.addRequired("fs", @(x) validateattributes(x, {'numeric'}, {'scalar', 'positive', 'integer'}));
mIp.addRequired("type", @(x) any(validatestring(x, {'REG', 'IRREG'})));
mIp.addParameter("sigmas", 0.5, @(x) validateattributes(x, {'numeric'}, {'vector', 'positive'}));
mIp.addParameter("pulseLen", 2e-4, @(x) validateattributes(x, {'numeric'}, {'scalar', 'positive'}));
mIp.parse(ICIs, durs, fs, type, varargin{:});
sigmas = mIp.Results.sigmas;
pulseLen = mIp.Results.pulseLen;

if isscalar(sigmas)
    sigmas = repmat(sigmas, [numel(ICIs), 1]);
end

ICIs = ICIs(:);
durs = durs(:);
sigmas = ICIs(:) .* sigmas(:);

clickCounts = ceil(fix(durs .* fs) ./ fix(ICIs .* fs));

if strcmpi(type, "REG")
    % generate ICI sequence with fixed click numbers and ICIs
    ICIseq = arrayfun(@(x, y) repmat(x, [y, 1]), ICIs, clickCounts, "UniformOutput", false);

    % return actual duration for each ICI
    durs = cellfun(@sum, ICIseq);

    ICIseq = cat(1, ICIseq{:});
    y = genClickTrainByICIseq(ICIseq, fs, pulseLen);

else % IRREG
    % generate ICI sequence with fixed click numbers but random ICIs
    ICIseq = cell(length(ICIs), 1);

    for index = 1:length(ICIs)
        mu = ICIs(index);
        sigma = sigmas(index);

        % loop for each click
        ICIseq{index} = zeros(clickCounts(index), 1);

        for cIndex = 1:length(ICIseq{index})
            temp = normrnd(mu, sigma, 1);

            if cIndex == 1
                temp = mu;
            elseif cIndex == 2

                while ~(temp >= 0.3 * mu && temp <= 1.7 * mu) || ...
                        ~(temp + ICIseq{index}(cIndex - 1) >= 1.2 * mu && temp + ICIseq{index}(cIndex - 1) <= 3.1 * mu)
                    temp = normrnd(mu, sigma, 1);
                end

            else

                while ~(temp >= 0.3 * mu && temp <= 1.7 * mu) || ...
                        ~(temp + ICIseq{index}(cIndex - 1) >= 1.2 * mu && temp + ICIseq{index}(cIndex - 1) <= 3.1 * mu) || ...
                        ~(temp + sum(ICIseq{index}(cIndex - 2:cIndex - 1)) >= 1.8 * mu && temp + sum(ICIseq{index}(cIndex - 2:cIndex - 1)) <= 4.6 * mu)
                    temp = normrnd(mu, sigma, 1);
                end

            end

            ICIseq{index}(cIndex) = temp;
        end

    end

    % return actual duration for each ICI
    durs = cellfun(@sum, ICIseq);

    ICIseq = cat(1, ICIseq{:});
    y = genClickTrainByICIseq(ICIseq, fs, pulseLen);
end

return;
end

function y = genClickTrainByICIseq(ICIseq, fs, pulseLen)
nHigh = fix(pulseLen * fs);
nEveryICI = fix(ICIseq .* fs);
y = zeros(1, sum(nEveryICI));
temp = cumsum(nEveryICI);

for index = 1:length(temp)
    y(temp(index) + 1:temp(index) + nHigh) = 1;
end

return;
end