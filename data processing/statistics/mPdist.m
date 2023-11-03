function distance = mPdist(x, cellData, Method)
narginchk(2, 3)
if nargin < 3
    Method = 'euclidean';
end
if ~iscell(cellData) &&  size(cellData, 2) == 2
    cellData = num2cell(cellData, 2);
end
    distance = cellfun(@(y) pdist([x; y], Method), cellData);
end