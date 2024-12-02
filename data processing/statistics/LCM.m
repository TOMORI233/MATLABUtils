function res = LCM(A)
% Return least common multiple of a real array [A]

if ~isreal(A) || ~isvector(A)
    error("Input should be a real vector");
end

res = A(1);
for index = 2:numel(A)
    res = lcm(res, A(index));
end

return;
end