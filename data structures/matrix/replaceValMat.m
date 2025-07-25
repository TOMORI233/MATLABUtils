function A = replaceValMat(A, newVal, oldVal)
for i = 1:length(oldVal)
    if isnan(oldVal(i))
        A(isnan(A)) = newVal;
    else
        A(A == oldVal(i)) = newVal;
    end
end
return;
end