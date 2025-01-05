function p1 = testWithRS(data, ICI, winBase, winResp, winJoin, joinN, iteration)
        % data should be cell format
        
        % for absolute phase locking
        dataBase = cellfun(@(x) findWithinInterval(x, winBase)-winBase(1), data, "UniformOutput", false);
        dataResp = cellfun(@(x) findWithinInterval(x, winResp), data, "UniformOutput", false);
        dataBase(cellfun(@length, dataBase) < 1)= [];
        dataResp(cellfun(@length, dataResp) < 1)= [];
        if any([length(dataBase), length(dataResp)] < 10)
            p1 = 1;
        else
        dataWhole = [dataBase; dataResp];
        [RSBase, vsBase] = RayleighStatistic(dataBase, ICI);
        [RSResp, vsResp] = RayleighStatistic(dataResp, ICI);
        randResp = cellfun(@(x) dataWhole(randperm(length(dataWhole), length(dataResp))), num2cell(1:iteration)', "UniformOutput", false);
        [randRS, randVS] = cellfun(@(x, y) RayleighStatistic(x, ICI), randResp);
        if vsResp <= vsBase
            p1 = 1-(sum(vsResp < randVS) / length(randVS));
        else
            p1 = 1-(sum(vsResp > randVS) / length(randVS));
        end
        end

%         % for segments joining
%         ITI = diff(winJoin);
%         joinResp = cellfun(@(x) findWithinInterval(x, winJoin), data, "UniformOutput", false);
%         joinIdx  = num2cell(reshape(1:ceil(length(joinResp)/joinN)*joinN, ceil(length(joinResp)/joinN), []), 2);
%         padFlag  = ceil(length(joinResp)/joinN)*joinN - length(joinResp);
%         if padFlag
%            joinIdx(end-padFlag+1:end) = cellfun(@(x) x(1:end-1), joinIdx(end-padFlag+1:end), "UniformOutput", false);
%         end
%         dataJoin = cellfun(@(x) cell2mat(cellfun(@(y, k) y+(k-1)*ITI, joinResp(x), num2cell(1:length(x))', "UniformOutput", false)), joinIdx, "UniformOutput", false);
% %         mRaster_Blocked({dataJoin})
%         [RSJoin, vsJoin] = RayleighStatistic(dataJoin, ITI);


end