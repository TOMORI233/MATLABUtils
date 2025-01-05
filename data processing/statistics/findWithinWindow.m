function [resVal,idx] = findWithinWindow(value, t, range, dim, inclusive)
% if dim=1, n*m to n*k; if dim=2, n*m to k*m
narginchk(3, 5);
if nargin < 4
    dim = 1;
end
if nargin < 5
    inclusive = true;
end
if inclusive
    idx = find(t >= range(1) & t <= range(2));
else
    idx = find(t > range(1) & t < range(2));
end
    if dim == 1
     resVal = value(:, idx);
    else
        resVal = value(idx, :);
    end
end

