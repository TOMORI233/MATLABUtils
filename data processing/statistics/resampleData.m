function dataResample = resampleData(data, fs0, fs)
    % Required: Signal Processing Toolbox for resample.m
    % [data] can be a real vector or a cell array.
    % If [data] is a cell array, each cell is a trial and each row of the
    % matrix in a cell is a channel.
    % The output is the same type as that of the input.

    [P, Q] = rat(fs / fs0);

    if iscell(data)
        dataResample = cellfun(@(x) cell2mat(rowFcn(@(y) resample(y, P, Q), x, "UniformOutput", false)), data, "UniformOutput", false);
    elseif isa(data, "double") || isa(data, "single")
        dataResample = resample(data, P, Q);
    else
        error("resampleData(): Invalid data type");
    end
    
    return;
end