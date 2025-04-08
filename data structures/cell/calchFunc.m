function [res, trialsData] = calchFunc(fcn, trialsData, padDir)
% General function of calchMean/calchErr/calchStd
% 
% Input:
%   - fcn: function handle to perform on trialsData
% Optional [fcn]: @mean, @SE, @std
% To customize [fcn], it should receive at least two inputs: [data] and
% [dim], and also include methods how to process nan-values.
% e.g., 
%   fcn = @(x, dim) std(x, [], dim, "omitnan"); % same as @std
%   fcn = @(x, dim) mFcn(x, dim, "omitnan"); % custom
%   
%   function y = mFcn(x, dim, omitnanOpt)
%   % [x] is N-dim data.
%   % Compute along dimension [dim] of [x].
%   % e.g., compute rms
%   end
% 
% For detailed information, see calchMean.m

narginchk(2, 3);

if nargin < 3
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
if ~all(nTime == nTime(1))
    % not all trial data of the same size: weighted-average

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

end

if isequal(fcn, @std)
    res = std(cat(dim + 1, trialsData{:}), [], dim + 1, "omitnan");
elseif isequal(fcn, @mean) || isequal(fcn, @SE)
    res = fcn(cat(dim + 1, trialsData{:}), dim + 1, "omitnan");
else
    res = fcn(cat(dim + 1, trialsData{:}), dim + 1);
end

return;
end