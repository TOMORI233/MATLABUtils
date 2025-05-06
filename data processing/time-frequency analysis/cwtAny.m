function [cwtres, f, coi] = cwtAny(trialsData, fs, varargin)
% Description: this function returns cwt results of multi-channel and
%              multi-trial data using parallel computation on GPU.
% Parameters:
%     The input [trialsData] is a nTrial*1 cell, or a nCh*nTime matrix for a single trial.
%     The input data should be type 'double'.
%
%     The input [segNum] specifies the number of waves to combine for
%     computation in a single loop. (default = 10)
%     If the input [segNum] is set 1, work in non-parallel mode, which
%     use "CPU" only and this setting is prior to [mode].
%
%     If the input [mode] is set "auto", cwtAny tries GPU first and then turn to CPU.
%     If the input [mode] is set "CPU", use CPU only for computation.
%     If the input [mode] is set "GPU", use GPU first and then turn to CPU for the rest part.
%
%     The input [tPad] specifies the total duration of two-sided zero
%     padding, in sec (empty for no padding, default).
%
%     The output [cwtres] is a nTrial*nCh*nFreq*nTime matrix.
%         If the input [outType] is "raw" (default), [cwtres] is a complex double matrix.
%         If the input [outType] is "power", [cwtres] is returned as abs(cwtres).
%         If the input [outType] is "phase", [cwtres] is returned as angle(cwtres).
%     The output [f] is a descendent column vector.
%
% Example:
%     [cwtres, f, coi] = cwtAny(...)
%     cwtAny(trialsData, fs)
%     cwtAny(trialsData, fs, segNum)
%     cwtAny(..., "mode", "auto | CPU | GPU")
%     cwtAny(..., "outType", "raw | power | phase")
%     cwtAny(..., "tPad", tPad)
%
% Additional information:
%     1. The wavelet used here is 'morlet'. For other wavelet types, please edit private\CWTMULTIALL
%     2. There are potential risks of spectrum leakage resulted by coi at low frequencies,
%        especially at the borders. To avoid undesired results, tailor and pad your data.
%        (Update 20241228: padding procedure is now available using name-value input "tPad")
%
% %% WARNING ISSUES %%
%    If the error CUDA_ERROR_OUT_OF_MEMORY occurs, restart your computer and delete the
%    recent-created folders 'Jobx' in:
%    'C:\Users\[your account]\AppData\Roaming\MathWorks\MATLAB\local_cluster_jobs\R20xxx\'.
%    The setting files in these folders may not allow you to connect to the parallel pool,
%    which is used in this function. Tailor your data then, to avoid this problem.

mIp = inputParser;
mIp.addRequired("trialsData");
mIp.addRequired("fs", @(x) validateattributes(x, {'numeric'}, {'scalar', 'positive'}));
mIp.addOptional("segNum", 10, @(x) validateattributes(x, {'numeric'}, {'scalar', 'positive', 'integer'}));
mIp.addParameter("mode", "auto", @(x) any(validatestring(x, {'auto', 'CPU', 'GPU'})));
mIp.addParameter("outType", "raw", @(x) any(validatestring(x, {'raw', 'power', 'phase'})));
mIp.addParameter("tPad", [], @(x) validateattributes(x, {'numeric'}, {'scalar', 'positive'}));
mIp.parse(trialsData, fs, varargin{:});

segNum = mIp.Results.segNum;
workMode = mIp.Results.mode;
type = mIp.Results.outType;
tPad = mIp.Results.tPad; % total duratio of padding

% Prepare data
switch class(trialsData)
    case "cell"
        trialsData = trialsData(:);
        nTrial = numel(trialsData);
        [nCh, nTime0] = size(trialsData{1});
        trialsData = cat(1, trialsData{:});
    case "double"
        nTrial = 1;
        [nCh, nTime0] = size(trialsData);
    otherwise
        error("Invalid data type");
end

if size(trialsData, 1) < segNum
    disp(['Segment numebr > nCh*nTrial, set segNum = ', num2str(size(trialsData, 1))]);
    segNum = size(trialsData, 1);
end

if mod(nTrial * nCh, segNum) == 0
    segIdx = segNum * ones(floor(nTrial * nCh / segNum), 1);
else
    segIdx = [segNum * ones(floor(nTrial * nCh / segNum), 1); mod(nTrial * nCh, segNum)];
end
trialsData = mat2cell(trialsData, segIdx);

% Pad data
if ~isempty(tPad)

    if tPad <= nTime0 / fs
        error("Total duration of padding should not be shorter than data duration.");
    end

    nPad = fix((tPad * fs - nTime0) / 2); % nPad for one side
    trialsData = cellfun(@(x) wextend(2, 'zpd', x, [0, nPad]), trialsData, "UniformOutput", false);
    nTime = nTime0 + 2 * nPad;
else
    nTime = nTime0;
end

t1 = tic;
[~, f, coi] = cwtMultiAll_np(trialsData{1}(1, :)', fs);
disp(['Frequencies range from ', num2str(min(f)), ' to ', num2str(max(f)), ' Hz']);

% check if work in non-parallel mode
if segNum == 1 % non-parallel
    disp("Work in non-parallel mode");
    disp("Using CPU...");
    trialsData = cat(1, trialsData{:})';
    cwtres = cwtMultiAll_np(trialsData, fs); % (nTrial*nCh)*nFreq*nTime
else % parallel
    disp("Work in parallel mode");

    if strcmpi(workMode, "auto")

        if exist(['cwtMultiAll', num2str(nTime), 'x', num2str(segNum), '_mex.mexw64'], 'file') ...
           && gpuDeviceCount >= 1
            workMode = "GPU";
            disp("Using GPU...");
        else
            workMode = "CPU";
            warning("MEX file is missing or GPU device is unavailable");
            disp("Using CPU...");
        end

    elseif strcmpi(workMode, "CPU")
        disp("Using CPU...");
    elseif strcmpi(workMode, "GPU")
        disp("Using GPU...");

        if ~exist(['cwtMultiAll', num2str(nTime), 'x', num2str(segNum), '_mex.mexw64'], 'file')
            disp("MEX file is missing. Generating MEX file...");
            currentPath = pwd;
            cd(fileparts(mfilename("fullpath")));
            ft_removePath;
            cfg = coder.gpuConfig('mex');
            str = ['codegen cwtMultiAll -config cfg -args {coder.typeof(gpuArray(0),[', num2str(nTime), ' ', num2str(segNum), ']),coder.typeof(0)}'];
            eval(str);
            if ~exist(fullfile(fileparts(mfilename("fullpath")), 'private'), "dir")
                mkdir('private');
            end
            movefile('cwtMultiAll_mex.mexw64', ['private\cwtMultiAll', num2str(nTime), 'x', num2str(segNum), '_mex.mexw64']);
            cd(currentPath);
            ft_defaults;
        end
    else
        error("Invalid mode");
    end

    if strcmpi(workMode, "CPU")
        cwtres = cellfun(@(x) cwtMultiAll(x', fs), trialsData, "UniformOutput", false);
    else
        cwtFcn = eval(['@cwtMultiAll', num2str(nTime), 'x', num2str(segNum), '_mex']);
        if all(segIdx == segIdx(1))
            cwtres = cellfun(@(x) cwtFcn(x', fs), trialsData, "UniformOutput", false);
            cwtres = cellfun(@gather, cwtres, "UniformOutput", false);
        else
            cwtres = cellfun(@(x) cwtFcn(x', fs), trialsData(1:end - 1), "UniformOutput", false);
            cwtres = cellfun(@gather, cwtres, "UniformOutput", false);

            disp("Computing the rest part using CPU...");
            cwtres = [cwtres; {cwtMultiAll(trialsData{end}', fs)}];
        end
    end

    cwtres = cat(1, cwtres{:}); % (nTrial*nCh)*nFreq*nTime
end

nFreq = size(cwtres, 2);
temp = zeros(nTrial, nCh, nFreq, nTime);
for index = 1:size(temp, 1)
    temp(index, :, :, :) = cwtres(nCh * (index - 1) + 1:nCh * index, :, :);
end
cwtres = temp;

if ~isempty(tPad)
    cwtres = cwtres(:, :, :, nPad + 1:nPad + nTime0);
    coi = coi(nPad + 1:nPad + nTime0);
end

switch type
    case "raw"
        % do nothing
    case "power"
        cwtres = abs(cwtres);
    case "phase"
        cwtres = angle(cwtres);
    otherwise
        error("Invalid output type");
end

disp(['Wavelet transform computation done in ', num2str(toc(t1)), ' sec.']);

return;
end