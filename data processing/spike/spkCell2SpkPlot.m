function spkPlot = spkCell2SpkPlot(spkCell)
    if ~iscell(spkCell)
        error("input should be cell type!");
        return;
    end
    spkPlot = cell2mat(cellfun(@(x, y) [x, ones(length(x), 1)*y], spkCell, num2cell(1:length(spkCell))', "UniformOutput", false));
end