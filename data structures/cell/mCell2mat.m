function A = mCell2mat(C)
    % Convert cell C to column vector
    % Elements of C can be cell/string/numeric

    A = [];

    for index = 1:numel(C)
        A = [A; C{index}];
    end
    
    return;
end