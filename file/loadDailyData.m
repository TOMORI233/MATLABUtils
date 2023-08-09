function popRes = loadDailyData(ROOTPATH, varargin)
mIp = inputParser;
mIp.addRequired("ROOTPATH", @(x) isstring(x));
mIp.addParameter("MATNAME", "res.mat", @(x) isstring(x));
mIp.addParameter("DATE", "", @(x) isstring(x));
mIp.addParameter("protocols", [], @(x) isstring(x));
mIp.parse(ROOTPATH, varargin{:});

ROOTPATH = mIp.Results.ROOTPATH;
MATNAME = mIp.Results.MATNAME;
DATE = mIp.Results.DATE;
protocols = mIp.Results.protocols;

%% get MAT path
MATPATH = dirItem(ROOTPATH, MATNAME);
PATHPART = cellfun(@(x) strsplit(x, "\"), MATPATH, "UniformOutput", false);
if isempty(protocols)
    protocols = unique(string(cellfun(@(x) x{end - 2}, PATHPART, "UniformOutput", false)));
end
MATPATH = string(MATPATH);

%% merge daily data
for pIndex = 1 : length(protocols)
    ProtPATH = MATPATH(mContains(MATPATH, DATE, "all_or", "all") & mContains(MATPATH, protocols(pIndex)));
    PATHPART = cellfun(@(x) strsplit(x, "\"), MATPATH, "UniformOutput", false);
    dateStrs = cellfun(@(x) x{end - 1}, PATHPART, "UniformOutput", false);
    for mIndex = 1 : length(ProtPATH)
        temp = whos('-file', ProtPATH(mIndex));
        varName = string({temp.name})';
        load(ProtPATH(mIndex));
        popRes.(protocols(pIndex))(mIndex).date = dateStrs{mIndex};
        for vIndex = 1 :length(varName)
            eval(['popRes.(protocols(pIndex))(mIndex).(varName(vIndex)) = ', char(varName(vIndex)), ';']);
        end
    end
end



end