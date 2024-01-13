function struct = collectVarsInWS(valName)
valName   = reshape(string(valName), 1, []);
for vIndex = 1:length(valName)
    struct.(valName(vIndex)) = evalin("caller", valName(vIndex));
end