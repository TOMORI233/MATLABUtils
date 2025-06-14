function res = LCM(A)
% Return least common multiple of a real array [A]

if ~isreal(A) || ~isvector(A)
    error("Input should be a real vector");
end

precision = 10 ^ max(arrayfun(@countDeciamlPlaces, A));
A = round(A * precision, 0);

res = A(1);
for index = 2:numel(A)
    res = lcm(res, A(index));
end

res = res / precision;
return;
end

function N = countDeciamlPlaces(x)
    if ~isfinite(x)
        N = NaN;
        return;
    end
    
    str = sprintf('%.8f', x);
    str = strrep(str, ' ', '');
    
    while ~isempty(str) && (endsWith(str, '0') || endsWith(str, '.'))
        str = str(1:end - 1);
    end
    
    dot_pos = find(str == '.', 1);
    if isempty(dot_pos)
        N = 0;
    else
        N = length(str) - dot_pos;
    end

    return;
end