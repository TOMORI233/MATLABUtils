function res = mMapminmax(data, yAbs)
narginchk(1, 2);

if nargin < 2
    yAbs = 1;
end

[row, col] = size(data);
res = mapminmax(reshape(abs(data), [1, numel(data)]), 0, yAbs);
res = reshape(res, [row, col]) .* (-1 * (data < 0) + 1 * (data > 0));