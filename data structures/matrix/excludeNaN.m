function data = excludeNaN(data, dim)
narginchk(1, 2);
if nargin < 2
    dim = 1;
end
[nanX, nanY] = find(isnan(data) | isinf(data)); 
    if dim == 1
        data(unique(nanX), :) = [];
    elseif dim == 2
        data(unique(nanY), :) = [];
    end
end