function [res, idx] = mIntersect(A, B, varargin)
narginchk(2, inf);
if nargin == 2
    [res, idx{1}, idx{2}] = intersect(A, B);
else
        res = intersect(A, B);
    for i = 1 : length(varargin)
        res = intersect(res, varargin{i});
    end
    idx = cellfun(@(x) cell2mat(cellfun(@(y) find(cellfun(@(m) isequal(m, y), num2cell(x))), num2cell(res), "UniformOutput", false)), [{A}, {B}, varargin(:)], "UniformOutput", false);
end
    idx = reshape(cell2mat(idx), length(res), []);
end