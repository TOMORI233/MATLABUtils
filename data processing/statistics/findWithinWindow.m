function [resVal,idx] = findWithinWindow(value, t, range, dim)
% if dim=1, n*m to n*k; if dim=2, n*m to k*m
narginchk(3, 4);
if nargin < 4
    dim = 1;
end
    idx = find(t >= range(1) & t <= range(2));
    if dim == 1
     resVal = value(:, idx);
    else
        resVal = value(idx, :);
    end
end

