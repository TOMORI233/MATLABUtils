function A = replaceValMat(A, newVal, oldVal)
    if isnan(oldVal)
        A(isnan(A)) = newVal;
    else
        A(A == oldVal) = newVal;
    end

    return;
end