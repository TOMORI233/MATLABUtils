function [chMean, trialsData] = calchMean(trialsData, padDir)
% Return the weighted-average [chMean] (nCh*xx*xx*...*nTime) and 
% NAN-padded [trialsData].
% 
% [trialsData] is a nTrial*1 cell vector with nCh*xx*xx*...*nTime data.
% Trial data are averaged omitting NAN values (this is important when bad 
% channels are different across days/subjects).
% 
% The last dimension is regarded as time.
% [nTime] can be different for each trial. If so, [padDir] specifies where 
% to pad NAN values for weighted-average computation. Optional [padDir]: 
% "head" and "tail" (default="tail").

narginchk(1, 2);

if nargin < 2
    padDir = "tail";
end

% Convert to column vector
trialsData = trialsData(:);

% Check data
dim = cellfun(@ndims, trialsData);

if ~all(dim == dim(1))
    error("All trial data should have the same dimension number");
else
    dim = dim(1);
    sz = cellfun(@size, trialsData, "UniformOutput", false);

    for index = 1:dim - 1
        temp = cellfun(@(x) x(index), sz);

        if ~all(temp == temp(1))
            error("All trial data should have the same size for all dimensions except the last dimension");
        end

    end
end

nTime = cellfun(@(x) size(x, dim), trialsData);
if all(nTime == nTime(1)) % all trial data of the same size
    chMean = mean(cat(dim + 1, trialsData{:}), dim + 1, "omitnan");
else % weighted-average
    nTimeMax = max(nTime);
    nTime = num2cell(nTime);

    % pad data with NAN
    if strcmpi(padDir, "head")
        trialsData = cellfun(@(x, y, z) cat(dim, nan([y(1:end - 1), nTimeMax - z]), x), trialsData, sz, nTime, "UniformOutput", false);
    elseif strcmpi(padDir, "tail")
        trialsData = cellfun(@(x, y, z) cat(dim, x, nan([y(1:end - 1), nTimeMax - z])), trialsData, sz, nTime, "UniformOutput", false);
    else
        error("Invalid input of [padDir]. It should be either 'head' or 'tail'.");
    end

    chMean = mean(cat(dim + 1, trialsData{:}), dim + 1, "omitnan");
end

return;
end