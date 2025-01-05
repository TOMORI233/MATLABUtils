function popRes = loadDailyData(ROOTPATH, varargin)
mIp = inputParser;
mIp.addRequired("ROOTPATH", @(x) isstring(x) | ischar(x));
mIp.addParameter("MATNAME", "res.mat", @(x) isstring(x));
mIp.addParameter("keyWord", ".", @(x) isstring(x)); % regular expression
mIp.addParameter("protocols", [], @(x) isstring(x) | ischar(x));
mIp.parse(ROOTPATH, varargin{:});

ROOTPATH = mIp.Results.ROOTPATH;
MATNAME = mIp.Results.MATNAME;
keyWord = mIp.Results.keyWord;
protocols = string(mIp.Results.protocols);

%% get MAT path
MATPATH = dirItem(ROOTPATH, MATNAME, "folderOrFile", "file");
PATHPART = cellfun(@(x) strsplit(x, "\"), MATPATH, "UniformOutput", false);

if isempty(protocols)
    protocols = unique(string(cellfun(@(x) x{end - 2}, PATHPART, "UniformOutput", false)));
end
MATPATH = string(MATPATH);

%% merge daily data
for pIndex = 1 : length(protocols)
    
    ProtPATH = MATPATH(~cellfun(@isempty, regexp(MATPATH, keyWord, "match"))& ~cellfun(@isempty, regexp(MATPATH, protocols(pIndex), "match")));
    PATHPART = cellfun(@(x) strsplit(x, "\"), ProtPATH, "UniformOutput", false);
    dateStrs = cellfun(@(x) x{end - 1}, PATHPART, "UniformOutput", false);
    
    try
        popRes.(protocols(pIndex)) = cell2mat(cellfun(@(x, y, z) mLoadData(x, y, z), ProtPATH, string(dateStrs), ProtPATH,  "uni", false));
    catch
        popRes.(protocols(pIndex)) = cellfun(@(x, y, z) mLoadData(x, y, z), ProtPATH, string(dateStrs), ProtPATH, "uni", false);
    end
  

end

    function res = mLoadData(ProtPATH, dateStr, path)
        vars = who('-file', ProtPATH);
        % 按字母顺序对变量名进行排序
        sorted_vars = sort(vars);
        S = load(ProtPATH, sorted_vars{:});
        res.dateStr = dateStr;
        res.path    = fileparts(path);
        res = cell2struct([struct2cell(res); struct2cell(S)], [fields(res); fields(S)]);
    end

end