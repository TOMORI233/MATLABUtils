function res = batchSpkData_Change(spkData, params)
params.AlphaOn = getOr(params, "AlphaOn", params.Alpha);
parseStruct(params);
if ~iscolumn(spkData)
    spkData = spkData';
end

chSPK_All = {spkData.chSpikeLfp.chSPK}';
stimStr   = {spkData.chSpikeLfp.stimStr}';
trialsRaw = {spkData.chSpikeLfp.trialsRaw}';

%% process spike
for cIndex = 1 : length(spkData.chSpikeLfp(1).chSPK)
    if isfield(spkData, "date")
    dateStr{cIndex, 1} = cellfun(@(x) [spkData.date, char(x(cIndex).info)], chSPK_All(1), "UniformOutput", false);
    else
      dateStr{cIndex, 1} = cellfun(@(x) [spkData.dateStr, char(x(cIndex).info)], chSPK_All(1), "UniformOutput", false);
    end
    temp = addFieldToStruct(rmfield(cell2mat(cellfun(@(x) x(cIndex), chSPK_All, "UniformOutput", false)), "info"), [stimStr, trialsRaw], ["stimStr"; "trialsRaw"]);

    ChangeSpike{cIndex, 1}     = cellfun(@(y, k) rowFcn(@(x) y(y(:, 2) == x), k, "UniformOutput", false), {temp.spikePlot}', {temp.trialsRaw}', "UniformOutput", false);
    ChangeSpikePlot{cIndex, 1} = cellfun(@(x) cell2mat(cellfun(@(y, k)[y, ones(length(y), 1) * k], x, num2cell(1:length(x))', "UniformOutput", false)), ChangeSpike{cIndex, 1}, "uni", false);
    OnsetSpike{cIndex, 1}      = cellfun(@(x, y) cellfun(@(k) k + y, x, "UniformOutput", false), ChangeSpike{cIndex, 1}, num2cell(S1Duration(1:length(spkData.chSpikeLfp))'), "UniformOutput", false);
    OnsetSpikePlot{cIndex, 1}  = cellfun(@(x) cell2mat(cellfun(@(y, k)[y, ones(length(y), 1) * k], x, num2cell(1:length(x))', "UniformOutput", false)), OnsetSpike{cIndex, 1}, "uni", false);

    % judge if there is a significant difference
    ChangeRes{cIndex, 1} = cell2mat(cellfun(@(x) spikeDiffWinTest(x, winChangeResp, winChangeBase, "Tail", tailChange, "Alpha", Alpha, "absThr", absThr, "sdThr", sdThr), ChangeSpike{cIndex, 1}, "UniformOutput", false));
    OnsetRes{cIndex, 1}  = cell2mat(cellfun(@(x) spikeDiffWinTest(x, winOnsetResp, winOnsetBase, "Tail", tailOnset, "Alpha", AlphaOn, "absThr", absThr, "sdThr", sdThr), OnsetSpike{cIndex, 1}, "UniformOutput", false));
    

    % PSTH
    [~, ~, PSTHOn{cIndex, 1}]         = cellfun(@(x) calPSTH(x, EDGEOn, binpara.binsize, binpara.binstep),     OnsetSpike{cIndex, 1},  "UniformOutput", false);
    PSTHOnPlot{cIndex, 1}     = [PSTHOn{cIndex, 1}{1}(:, 1), cell2mat(cellfun(@(x) x(:, 2), PSTHOn{cIndex, 1}, "UniformOutput", false)')];
    [~, ~, PSTHChange{cIndex, 1}]     = cellfun(@(x) calPSTH(x, EDGEOn, binpara.binsize, binpara.binstep), ChangeSpike{cIndex, 1}, "UniformOutput", false);
    PSTHChangePlot{cIndex, 1} = [PSTHChange{cIndex, 1}{1}(:, 1), cell2mat(cellfun(@(x) x(:, 2), PSTHChange{cIndex, 1}, "UniformOutput", false)')];

    % Local Response
%     [~, ~, PSTHLocal{cIndex, 1}, frRawLocal{cIndex, 1}]         = cellfun(@(x) calPSTH(x, localEdge, localPara.binsize, localPara.binstep),     ChangeSpike{cIndex, 1},  "UniformOutput", false);
%     PSTHLocalPlot{cIndex, 1}     = [PSTHLocal{cIndex, 1}{1}(:, 1), cell2mat(cellfun(@(x) x(:, 2), PSTHLocal{cIndex, 1}, "UniformOutput", false)')];
%     PSTHLocalSmoothLeft{cIndex, 1}   = [PSTHLocal{cIndex, 1}{1}(:, 1), mGaussionSmth(PSTHLocalPlot{cIndex, 1}(:, 2:end), smoothSigma, smoothSize, 1, "left")];
%     PSTHLocalSmoothRight{cIndex, 1}   = [PSTHLocal{cIndex, 1}{1}(:, 1), mGaussionSmth(PSTHLocalPlot{cIndex, 1}(:, 2:end), smoothSigma, smoothSize, 1, "right")];

    end

% res = cell2struct([ dateStr,   ChangeRes,    OnsetRes,   OnsetSpike,   ChangeSpike,   OnsetSpikePlot,   ChangeSpikePlot,  PSTHOnPlot,   PSTHChangePlot,   PSTHLocalPlot,   PSTHLocalSmoothLeft,   PSTHLocalSmoothRight] , ...
%                   ["dateStr", "ChangeRes",  "OnsetRes", "OnsetSpike", "ChangeSpike", "OnsetSpikePlot", "ChangeSpikePlot","PSTHOnPlot", "PSTHChangePlot", "PSTHLocalPlot", "PSTHLocalSmoothLeft", "PSTHLocalSmoothRight"], 2);
res = cell2struct([ dateStr,   ChangeRes,    OnsetRes,   OnsetSpike,   ChangeSpike,   OnsetSpikePlot,   ChangeSpikePlot,  PSTHOnPlot,   PSTHChangePlot] , ...
                  ["dateStr", "ChangeRes",  "OnsetRes", "OnsetSpike", "ChangeSpike", "OnsetSpikePlot", "ChangeSpikePlot","PSTHOnPlot", "PSTHChangePlot"], 2);


