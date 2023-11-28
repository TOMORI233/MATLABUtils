function [cwtres, f, coi] = cwtAny(trialsData, fs, varargin)
    % [trialsData] is a nTrial*1 cell or a nCh*nTime matrix
    % [cwtres] is a nTrial*nCh*nFreq*nTime matrix
    % [f] is a a descendent column vector

    mIp = inputParser;
    mIp.addRequired("trialsData");
    mIp.addRequired("fs", @(x) validateattributes(x, {'numeric'}, {'scalar', 'positive'}));
    mIp.addOptional("segNum", 10, @(x) validateattributes(x, {'numeric'}, {'scalar', 'positive', 'integer'}));
    mIp.addParameter("mode", "auto", @(x) any(validatestring(x, {'auto', 'CPU', 'GPU'})));
    mIp.parse(trialsData, fs, varargin{:});

    segNum = mIp.Results.segNum;
    workMode = mIp.Results.mode;

    switch class(trialsData)
        case "cell"
            nTrial = length(trialsData);
            [nCh, nTime] = size(trialsData{1});
            trialsData = cell2mat(trialsData);
        case "double"
            nTrial = 1;
            [nCh, nTime] = size(trialsData);
        otherwise
            error("Invalid data type");
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

    [minfreq, maxfreq] = cwtfreqbounds(nTime, fs);
    disp(['Frequencies range from ', num2str(minfreq), ' to ', num2str(maxfreq), ' Hz']);

    if strcmpi(workMode, "CPU")
        [cwtres, f, coi] = cellfun(@(x) cwtMultiAll(x', fs), trialsData, "UniformOutput", false);
        f = f{1};
        coi = coi{1};
    else
        cwtFcn = eval(['@cwtMultiAll', num2str(nTime), 'x', num2str(segNum), '_mex']);
        if all(segIdx == segIdx(1))
            [cwtres, f, coi] = cellfun(@(x) cwtFcn(x', fs), trialsData, "UniformOutput", false);
            cwtres = cellfun(@gather, cwtres, "UniformOutput", false);
        else
            disp('Computing the rest part using CPU...');
            [cwtres, f, coi] = cellfun(@(x) cwtFcn(x', fs), trialsData(1:end - 1), "UniformOutput", false);
            cwtres = cellfun(@gather, cwtres, "UniformOutput", false);
            cwtres = [cwtres; {cwtMultiAll(trialsData{end}', fs)}];
        end
        f = gather(f{1});
        coi = gather(coi{1});
    end

    cwtres = cat(1, cwtres{:});
    nFreq = size(cwtres, 2);
    temp = zeros(nTrial, nCh, nFreq, nTime);
    for index = 1:size(temp, 1)
        temp(index, :, :, :) = cwtres(nCh * (index - 1) + 1:nCh * index, :, :);
    end
    cwtres = temp;

    return;
end