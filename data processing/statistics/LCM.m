function res = LCM(A)
% Return least common multiple of a real array [A]

if ~isreal(A) || ~isvector(A)
    error("Input should be a real vector");
end

precision = 10 ^ max(arrayfun(@(x) -floor(log10(abs(x))), A));
A = round(A * precision, 0);

res = A(1);
for index = 2:numel(A)
    res = lcm(res, A(index));
end

res = res / precision;
return;
end