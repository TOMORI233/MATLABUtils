function A = mCell2mat(C)
    A = [];
    for index = 1:numel(C)
        A = [A; C{index}];
    end
    return;
end