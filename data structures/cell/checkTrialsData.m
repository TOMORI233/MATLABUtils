function [nch, nsample] = checkTrialsData(varargin)
% Check whether all trialsData_i are of the same size.
% Each of the input should contain the same nch and nsample.

% data type should be cell
if ~all(cellfun(@iscell, varargin))
    error("Invalid data type.");
end

% trial data should be nch*sample
sz = cellfun(@(x) cellfun(@size, x, "UniformOutput", false), varargin, "UniformOutput", false);
sz = cellfun(@(x) cat(1, x{:}), sz, "UniformOutput", false);

if ~all(cellfun(@ismatrix, sz))
    error("Input trial data should be nch*nsample.");
end

sz = cat(1, sz{:});
if ~all(ismember(sz, sz(1, :), "rows"))
    error("All trial data should be of the same size.");
end

nch = sz(1, 1);
nsample = sz(1, 2);
return;
end