function x = replaceVal(x, val)

if isempty(x) || isnan(x) || isinf(x)
    x = val;
end
