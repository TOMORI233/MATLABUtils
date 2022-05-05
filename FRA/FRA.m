function Fig = FRA(varargin)

    narginchk(0, 1);

    if nargin == 0
        dataPath = 'D:\Education\Lab\monkey\SN\SN mat\m4\c1-20211227\m4c1_FRA.mat';
    else
        dataPath = varargin{1};
    end

    temp = split(dataPath, '\');
    temp = split(temp{end}, '_');
    label = temp{1};

    %% Load data
    mWaitbar = waitbar(0, 'Data loading ...');
    load(dataPath);
    waitbar(1/4, mWaitbar, 'Data loaded');

    %% Parameter Settings
    windowParams.window = [0 100]; % ms

    %% Sort
    waitbar(1 / 4, mWaitbar, 'Sorting ...');
    sortData = mysort(data, [], "reselect", "preview");
    
    waitbar(2 / 4, mWaitbar, 'Plotting sort result ...');
    plotSSEorGap(sortData);
    plotPCA(sortData, [1 2 3]);
    plotWave(sortData);

    %% Process
    result.label = label;
    result.windowParams = windowParams;
    result.data = FRAProcess(data, [], []);
    Fig = plotTuning(result, "on");

    for cIndex = 1:sortData.K
        waitbar(3 / 4, mWaitbar, 'Processing ...');
        result.data = FRAProcess(data, [], [], sortData, cIndex);
        waitbar(3 / 4, mWaitbar, 'Plotting process result ...');
        plotTuning(result, "on");
    end

    waitbar(1, mWaitbar, 'Done');
    close(mWaitbar);

    return;
end
