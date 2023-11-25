function [cwtres, f, coi] = cwtNxM(trialsData, fs, varargin)
    mIp = inputParser;
    mIp.addRequired("trialsData");
    mIp.addRequired("fs", @(x) validateattributes(x, {'numeric'}, {'scalar', 'positive'}));
    mIp.addOptional("segNum", 10, @(x) validateattributes(x, {'numeric'}, {'scalar', 'positive', 'integer'}));
    mIp.parse(trialsData, fs, varargin{:});

    segNum = mIp.Results.segNum;

    switch class(trialsData)
        case "cell"
            nTrial = length(trialsData);
            [nCh, nTime] = size(trialsData{1});

            trialsData = cell2mat(trialsData);
            if mod(nTrial * nCh, segNum) == 0
                segIdx = segNum * ones(floor(nTrial * nCh / segNum), 1);
            else
                segIdx = [segNum * ones(floor(nTrial * nCh / segNum), 1); mod(nTrial * nCh, segNum)];
            end
            trialsData = mat2cell(trialsData, segIdx);

            if exist(['cwtMultiAll', num2str(nTime), 'x', num2str(segNum), '_mex.mexw64'], 'file')
                disp('Using GPU...');
                cwtFcn = eval(['@cwtMultiAll', num2str(nTime), 'x', num2str(segNum), '_mex']);
                [cwtres, f, coi] = cellfun(@(x) cwtFcn(x', fs), trialsData, "UniformOutput", false);
                cwtres = cellfun(@gather, cwtres, "UniformOutput", false);
                f = gather(f{1});
                coi = gather(coi{1});
            else
                disp('Using CPU...');
                cwtFcn = @cwtMultiAll;
                [cwtres, f, coi] = cellfun(@(x) cwtFcn(x', fs), trialsData, "UniformOutput", false);
                f = f{1};
                coi = coi{1};
            end
        case "double"

        otherwise
            error("Invalid data type");
    end

    


end