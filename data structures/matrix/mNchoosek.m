function groups = mNchoosek(data, nPool, header)
narginchk(2, 3);
if nargin < 3
    header = [];
else
    if iscolumn(header)
        header = header';
    end
end
if isempty(data) || isempty(nPool)
        groups = [];
else
        groups = cellfun(@(y) [header, y], mCell2mat(cellfun(@(x) num2cell(nchoosek(data, x), 2), num2cell(nPool)', "UniformOutput", false)), "UniformOutput", false);
end
