function bRes = mBootstrp(nboot, bootfun, data)
% nboot: resample times
% bootfun: anonymous function used for bootstrap. eg: @mean
% data: t*n array or t*1 cell, t refers to trial number
if iscell(data)
        [~, bootIdx] = bootstrp(nboot, bootfun, 1:length(data));
        bootData =cellfun(@(x) data(x), num2cell(bootIdx, 1), "UniformOutput", false)';
        
        bRes = cellfun(@(y) cell2mat(changeCellRowNum(cellfun(bootfun, changeCellRowNum(y), "UniformOutput", false))), bootData, "uni", false);
else
        bRes = bootstrp(nboot, bootfun, data);
end

