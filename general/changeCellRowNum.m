function res = changeCellRowNum(data)
    nChs = size(data{1}, 1);
    temp = cell2mat(data);
    res = cell(nChs, 1);
    
    for index = 1:nChs
        res{index} = temp(index:nChs:size(temp, 1), :);
    end

    return;
end