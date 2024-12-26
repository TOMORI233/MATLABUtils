function [cwtres, f, coi] = cwtAny(trialsData, fs, varargin)
% Description: this function returns cwt results of multi-channel and
%              multi-trial data using parallel computation on GPU.
% Parameters:
%     The input [trialsData] is a nTrial*1 cell, or a nCh*nTime matrix for a single trial.
%     The input data should be type double.
%     The input [segNum] specifies the number of waves to combine for computation in a single loop. (default = 10)
%     If the input [mode] is set "auto", cwtAny tries GPU first and then turn to CPU.
%     If the input [mode] is set "CPU", use CPU only for computation.
%     If the input [mode] is set "GPU", use GPU first and then turn to CPU for the rest part.
%     
%     The output [cwtres] is a nTrial*nCh*nFreq*nTime matrix.
%         If the input [outType] is "raw" (default), [cwtres] is a complex double matrix.
%         If the input [outType] is "power", [cwtres] is returned as abs(cwtres).
%         If the input [outType] is "phase", [cwtres] is returned as angle(cwtres).
%     The output [f] is a descendent column vector.
%
% Example:
%     [cwtres, f, coi] = cwtAny(trialsData, fs)
%     [cwtres, f, coi] = cwtAny(trialsData, fs, segNum)
%     [cwtres, f, coi] = cwtAny(..., "mode", "auto | CPU | GPU")
%     [cwtres, f, coi] = cwtAny(..., "outType", "raw | power | phase")
%
% Additional information:
%     1. The wavelet used here is 'morlet'. For other wavelet types, please edit private\CWTMULTIALL
%     2. There are potential risks of spectrum leakage resulted by coi at low frequencies, 
%        especially at the borders. To avoid undesired results, tailor and pad your data.
%        Here is an example for zero padding and continuous wavelet transform computation using CWTANY:
% 
%        % -----------demo script begins-----------%
%        fs = 500; % Hz, sample rate
%        t = 0:1/fs:3; % 3-sec data
%        tNew = 0:1/fs:10; % pad to 10-sec data
%        nPad = fix((length(tNew) - length(t)) / 2);
%        trialsData = cellfun(@(x) wextend(2, 'zpd', x, [0, nPad]), trialsData, "UniformOutput", false);
%        [cwtres, f, coi] = cwtAny(trialsData, fs);
%        cwtres = cwtres(:, :, :, nPad + 1:nPad + length(t));
%        % ----------- demo script ends----------- %
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
mIp.parse(trialsData, fs, varargin{:});

segNum = mIp.Results.segNum;
workMode = mIp.Results.mode;
type = mIp.Results.outType;

switch class(trialsData)
    case "cell"
        trialsData = trialsData(:);
        nTrial = numel(trialsData);
        [nCh, nTime] = size(trialsData{1});
        trialsData = cat(1, trialsData{:});
    case "double"
        nTrial = 1;
        [nCh, nTime] = size(trialsData);
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

if strcmpi(workMode, "auto")
    if exist(['cwtMultiAll', num2str(nTime), 'x', num2str(segNum), '_mex.mexw64'], 'file')
        workMode = "GPU";
        disp('Using GPU...');
    else
        workMode = "CPU";
        disp('mex file is missing. Using CPU...');
    end
elseif strcmpi(workMode, "CPU")
    disp('Using CPU...');
elseif strcmpi(workMode, "GPU")
    disp('Using GPU...');
    if ~exist(['cwtMultiAll', num2str(nTime), 'x', num2str(segNum), '_mex.mexw64'], 'file')
        disp('mex file is missing. Generating mex file...');
        currentPath = pwd;
        cd(fileparts(mfilename("fullpath")));
        ft_removePath;
        cfg = coder.gpuConfig('mex');
        str = ['codegen cwtMultiAll -config cfg -args {coder.typeof(gpuArray(0),[', num2str(nTime), ' ', num2str(segNum), ']),coder.typeof(0)}'];
        eval(str);
        mkdir('private');
        movefile('cwtMultiAll_mex.mexw64', ['private\cwtMultiAll', num2str(nTime), 'x', num2str(segNum), '_mex.mexw64']);
        cd(currentPath);
        ft_defaults;
    end
else
    error("Invalid mode");
end

t1 = tic;
[~, f, coi] = cwtMultiAll(trialsData{1}', fs);
disp(['Frequencies range from ', num2str(min(f)), ' to ', num2str(max(f)), ' Hz']);

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
        
        disp('Computing the rest part using CPU...');
        cwtres = [cwtres; {cwtMultiAll(trialsData{end}', fs)}];
    end
end

cwtres = cat(1, cwtres{:});
nFreq = size(cwtres, 2);
temp = zeros(nTrial, nCh, nFreq, nTime);
for index = 1:size(temp, 1)
    temp(index, :, :, :) = cwtres(nCh * (index - 1) + 1:nCh * index, :, :);
end
cwtres = temp;

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