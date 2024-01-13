function popRes = loadDailyData(ROOTPATH, varargin)
mIp = inputParser;
mIp.addRequired("ROOTPATH", @(x) isstring(x) | ischar(x));
mIp.addParameter("MATNAME", "res.mat", @(x) isstring(x));
mIp.addParameter("DATE", "", @(x) isstring(x));
mIp.addParameter("protocols", [], @(x) isstring(x));
mIp.addParameter("all_or", "all", @(x) isstring(x));
mIp.parse(ROOTPATH, varargin{:});

ROOTPATH = mIp.Results.ROOTPATH;
MATNAME = mIp.Results.MATNAME;
DATE = mIp.Results.DATE;
protocols = mIp.Results.protocols;
all_or = mIp.Results.all_or;

%% get MAT path
MATPATH = dirItem(ROOTPATH, MATNAME, "folderOrFile", "file");
PATHPART = cellfun(@(x) strsplit(x, "\"), MATPATH, "UniformOutput", false);
if isempty(protocols)
    protocols = unique(string(cellfun(@(x) x{end - 2}, PATHPART, "UniformOutput", false)));
end
MATPATH = string(MATPATH);

%% merge daily data
for pIndex = 1 : length(protocols)
    ProtPATH = MATPATH(mContains(MATPATH, DATE, "all_or", all_or) & mContains(MATPATH, protocols(pIndex)));
    PATHPART = cellfun(@(x) strsplit(x, "\"), ProtPATH, "UniformOutput", false);
    dateStrs = cellfun(@(x) x{end - 1}, PATHPART, "UniformOutput", false);
    popRes.(protocols(pIndex)) = cell2mat(cellfun(@(x, y) mLoadData(x, y), ProtPATH, string(dateStrs), "uni", false));
end

    function res = mLoadData(ProtPATH, dateStr)
        S = load(ProtPATH);
        res.dateStr = dateStr;
        res = structcat(res, S);
    end

end