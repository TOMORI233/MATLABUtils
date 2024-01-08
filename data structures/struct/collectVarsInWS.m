function struct = collectVarsInWS(valName)
    for index = 1 : length(valName)
        struct.(valName(index)) = evalin("caller", valName(index));
    end
end