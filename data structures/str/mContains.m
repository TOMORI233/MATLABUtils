function TF = mContains(str, pat, varargin)
mIp = inputParser;
mIp.addRequired("str", @(x) isstring(x) | iscellstr(x));
mIp.addRequired("pat", @(x) isstring(x));
mIp.addParameter("IgnoreCase", false, @(x) islogical(x));
mIp.addParameter("all_or", "or", @(x) isstring(x));
mIp.parse(str, pat, varargin{:});

IgnoreCase = mIp.Results.IgnoreCase;
all_or = mIp.Results.all_or;


if ~iscolumn(str)
    str = str';
end


if strcmpi(all_or, "or")
    TF = contains(str, pat, "IgnoreCase", IgnoreCase);
else
    TF = cellfun(@(x) contains(str, x, "IgnoreCase", IgnoreCase), pat, "UniformOutput", false);
end

if iscell(TF)
    if iscolumn(TF)
        TF = TF';
    end
    if length(TF) > 1
        TF = all(cell2mat(TF), 2);
    else
        TF = cell2mat(TF);
    end
else
    if ~iscolumn(TF)
        TF = TF';
    end

end

