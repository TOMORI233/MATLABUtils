function Path = dirItem(rootPath, keyword, varargin)
% Description: find file or folder name in rootpath
% Input:
%       rootpath: ROOTPATH
%       keyword: the raw file or folder name used to find 
%       newName: the string to replace the raw name
%       folderOrFile: decide rename file or folder

mIp = inputParser;
mIp.addRequired("rootPath", @(x) isstring(x) | ischar(x));
mIp.addRequired("keyword", @(x) isstring(x) | ischar(x));
mIp.addParameter("folderOrFile", "all", @(x) any(validatestring(x, {'all', 'file', 'folder'})));
mIp.parse(rootPath, keyword, varargin{:});

folderOrFile = mIp.Results.folderOrFile;

rootPath = string(rootPath);
keyword = string(keyword);
temp = dir(strcat(rootPath, "\**\*"));
mPath = fullfile(string({temp.folder}'), string({temp.name}'));
dirIndex = ~cellfun(@isempty, regexp(mPath, keyword)) & vertcat(temp.isdir) & ~ismember(string({temp.name}'), [".", ".."]);
fileIndex =  ~cellfun(@isempty, regexp(mPath, keyword)) & ~vertcat(temp.isdir) & ~ismember(string({temp.name}'), [".", ".."]);
if strcmpi(folderOrFile, "all")
    Path.dir = cellstr(mPath(dirIndex));
    Path.file = cellstr(mPath(fileIndex));
elseif strcmpi(folderOrFile, "folder")
    Path = cellstr(mPath(dirIndex));
elseif strcmpi(folderOrFile, "file")
    Path = cellstr(mPath(fileIndex));
end
end